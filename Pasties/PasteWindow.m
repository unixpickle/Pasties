//
//  PasteWindow.m
//  Pasties
//
//  Created by Alex Nichol on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PasteWindow.h"

#define kTextColor [NSColor whiteColor]

@interface PasteWindow (Private)

- (void)createCopyButton:(NSRect)r;
+ (NSMutableArray *)possibleStartingYs;
+ (CGFloat)popHighestY;
+ (void)putYBack:(CGFloat)restoreY;
- (void)setCompletionImage:(NSImage *)theImage;

@end

@implementation PasteWindow

@synthesize launchURL;

#pragma mark Stacking Static Methods

+ (NSMutableArray *)possibleStartingYs {
	static NSMutableArray * ys = nil;
	if (!ys) {
		NSRect mainScreenFrame = [[NSScreen mainScreen] frame];
		ys = [[NSMutableArray alloc] init];
		for (int i = 95; i < mainScreenFrame.size.height - 100; i += 100) {
			[ys addObject:[NSNumber numberWithDouble:(double)i]];
		}
	}
	return ys;
}
+ (CGFloat)popHighestY {
	NSMutableArray * ys = [self possibleStartingYs];
	if ([ys count] == 0) {
		return 100;
	}
	NSNumber * n = [ys objectAtIndex:0];
	[ys removeObjectAtIndex:0];
	return (CGFloat)[n doubleValue];
}
+ (void)putYBack:(CGFloat)restoreY {
	NSNumber * n = [NSNumber numberWithDouble:(double)restoreY];
	NSMutableArray * ys = [self possibleStartingYs];
	// find a position where it is smaller than a number.
	int insertIndex = 0;
	for (int i = (int)[ys count] - 1; i >= 0; i--) {
		NSNumber * theN = [ys objectAtIndex:i];
		if ([theN doubleValue] < [n doubleValue]) {
			insertIndex = i + 1;
		}
	}
	[ys insertObject:n atIndex:insertIndex];
}

#pragma mark Initializers

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithText:(NSString *)text language:(NSString *)language service:(NSString *)service {
	if ((self = [self initWithText:text language:language service:service makePrivate:NO])) {
		
	}
	return self;
}

- (id)initWithText:(NSString *)text language:(NSString *)language service:(NSString *)service makePrivate:(BOOL)isPrivate {
	NSRect mainScreenFrame = [[NSScreen mainScreen] frame];
	origY = [[self class] popHighestY];
	NSRect contentFrame = NSMakeRect(mainScreenFrame.size.width - 260, mainScreenFrame.size.height - origY, 250, 65);
	if ((self = [super initWithContentRect:contentFrame styleMask:(NSBorderlessWindowMask) backing:NSBackingStoreBuffered defer:YES])) {
		[self setHasShadow:NO];
		[(ANWindowRoundedView *)[self contentView] setBaseColor:[NSColor colorWithCalibratedWhite:0.1 alpha:0.9]];
		
		poster = [[MultiServiceHandler textPosterWithText:text language:language service:service] retain];
		if (!poster) {
			[super dealloc];
			return nil;
		}
		
		[poster setIsPrivate:isPrivate];
		
		activityLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(10, contentFrame.size.height - 30, contentFrame.size.width - 20, 20)];
		loadingBar = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(10, contentFrame.size.height - 55, contentFrame.size.width - 20, 20)];
		cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(contentFrame.size.width - 95, contentFrame.size.height - 55, 90, 24)];
		viewButton = [[NSButton alloc] initWithFrame:NSMakeRect(5, contentFrame.size.height - 55, contentFrame.size.width - 100, 24)];
		[cancelButton setBezelStyle:NSRoundedBezelStyle];
		[viewButton setBezelStyle:NSRoundedBezelStyle];
		[activityLabel setBackgroundColor:[NSColor clearColor]];
		[activityLabel setSelectable:NO];
		[activityLabel setBordered:NO];
		[activityLabel setTextColor:kTextColor];
		[cancelButton setTitle:@"Close"];
		[cancelButton setTarget:self];
		[cancelButton setAction:@selector(close:)];
		[viewButton setTitle:@"View in Browser"];
		[viewButton setTarget:self];
		[viewButton setAction:@selector(view:)];
		[self.contentView addSubview:loadingBar];
		[self.contentView addSubview:activityLabel];
		[activityLabel setFont:[NSFont boldSystemFontOfSize:14]];
		[self setReleasedWhenClosed:NO];
	}
	return self;
}

- (void)startPosting {
	[poster setDelegate:self];
	[poster postInBackground];
	[loadingBar setIndeterminate:YES];
	[loadingBar startAnimation:self];
	[activityLabel setStringValue:@"Posting..."];
}

- (void)createCopyButton:(NSRect)contentFrame {
	copyButton = [[NSButton alloc] initWithFrame:NSMakeRect(contentFrame.size.width - 85, contentFrame.size.height - 34, 80, 24)];
	[copyButton setAction:@selector(copy:)];
	[copyButton setTarget:self];
	[copyButton setBezelStyle:NSRoundedBezelStyle];
	[copyButton setTitle:@"Copy"];
}

#pragma mark Window Events

- (void)orderOut:(id)sender {
	[poster autorelease];
	[poster setDelegate:nil];
	poster = nil;
	[super orderOut:sender];
	[[self class] putYBack:origY];
}

- (void)close:(id)sender {
	[cancelButton setEnabled:NO];
	[viewButton setEnabled:NO];
	[[NSAnimationContext currentContext] setDuration:0.6];
	[NSAnimationContext beginGrouping];
	[[self animator] setAlphaValue:0];
	[NSAnimationContext endGrouping];
	[self performSelector:@selector(orderOut:) withObject:self afterDelay:0.8];
}

- (void)view:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL:self.launchURL];
	[cancelButton setEnabled:NO];
	[viewButton setEnabled:NO];
	[[NSAnimationContext currentContext] setDuration:0.6];
	[NSAnimationContext beginGrouping];
	[[self animator] setAlphaValue:0];
	[NSAnimationContext endGrouping];
	[self performSelector:@selector(orderOut:) withObject:self afterDelay:0.8];
}

- (void)copy:(id)sender {
	[[NSPasteboard generalPasteboard] setString:[self.launchURL description] forType:NSPasteboardTypeString];
	NSPasteboard * pasteBoard = [NSPasteboard generalPasteboard];
	[pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
	[pasteBoard setString:[self.launchURL absoluteString] forType:NSStringPboardType];
}

#pragma mark Poster

- (void)onlineTextPoster:(OnlineTextPoster *)thePoster postedToURL:(NSURL *)textURL {
	NSDate * date = [NSDate date];
	[[PasteHistoryController sharedHistoryController] addHistoryItem:[PasteHistoryItem historyItemWithURL:textURL addDate:date]];
	
	[cancelButton setAlphaValue:0];
	[viewButton setAlphaValue:0];
	[[self contentView] addSubview:cancelButton];
	[[self contentView] addSubview:viewButton];
	
	NSRect contentFrame = NSMakeRect([self frame].origin.x, self.frame.origin.y - 30, 250, 95);
	[self setFrame:contentFrame display:YES];
	
	detailURLLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(10, contentFrame.size.height - 55, contentFrame.size.width - 20, 18)];
	[detailURLLabel setEditable:NO];
	[detailURLLabel setBackgroundColor:[NSColor clearColor]];
	[detailURLLabel setBordered:NO];
	[detailURLLabel setBezeled:NO];
	[detailURLLabel setAlphaValue:0];
	[detailURLLabel setTextColor:kTextColor];
	[[self contentView] addSubview:detailURLLabel];
	
	[self createCopyButton:contentFrame];
	[copyButton setAlphaValue:0];
	[[self contentView] addSubview:copyButton];
	
	[[NSAnimationContext currentContext] setDuration:1];
	[NSAnimationContext beginGrouping];
	[[cancelButton animator] setAlphaValue:1];
	[[viewButton animator] setAlphaValue:1];
	[[loadingBar animator] removeFromSuperview];
	[[detailURLLabel animator] setAlphaValue:1];
	[[copyButton animator] setAlphaValue:1];
	[NSAnimationContext endGrouping];
	
	[detailURLLabel setStringValue:[NSString stringWithFormat:@"%@", textURL]];
	[activityLabel setStringValue:@"Success!"];
	self.launchURL = textURL;
	[self setCompletionImage:[NSImage imageNamed:@"success.png"]];
}

- (void)onlineTextPoster:(OnlineTextPoster *)thePoster failedWithError:(NSError *)theError {
	[cancelButton setAlphaValue:0];
	[[self contentView] addSubview:cancelButton];
	[cancelButton setFrame:NSMakeRect([[self contentView] frame].size.width - 90, 10, 80, 24)];
	
	[[NSAnimationContext currentContext] setDuration:1];
	[NSAnimationContext beginGrouping];
	[[cancelButton animator] setAlphaValue:1];
	[[viewButton animator] setAlphaValue:1];
	[[loadingBar animator] removeFromSuperview];
	[NSAnimationContext endGrouping];
	
	[activityLabel setStringValue:@"Failed"];
	[self setCompletionImage:[NSImage imageNamed:@"failed.png"]];
}

- (void)setCompletionImage:(NSImage *)theImage {
	statusImage = [[NSImageView alloc] initWithFrame:NSMakeRect(10, [[self contentView] frame].size.height - 28, 16, 16)];
	[statusImage setImage:theImage];
	[self.contentView addSubview:statusImage];
	[activityLabel setFrame:NSMakeRect(31, [[self contentView] frame].size.height - 30, [[self contentView] frame].size.width - 20, 20)];
}

- (void)dealloc {
	[poster release];
	[loadingBar release];
	[activityLabel release];
	[statusImage release];
	[detailURLLabel release];
	[copyButton release];
	self.launchURL = nil;
    [super dealloc];
}

@end
