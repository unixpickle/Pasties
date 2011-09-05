//
//  PasteComposeWindow.m
//  Pasties
//
//  Created by Alex Nichol on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PasteComposeWindow.h"


@implementation PasteComposeWindow

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])) {
		closeButton = [[ANCloseButton alloc] initWithFrame:NSMakeRect(10, [[self contentView] frame].size.height - 26, 16, 16)];
		[self.contentView addSubview:closeButton];
		[closeButton setContainingWindow:self];
		
		textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, [[self contentView] frame].size.width - 36, [[self contentView] frame].size.height - 91)];
		titleLabel = [[NSTextField alloc] initWithFrame:NSMakeRect([[self contentView] frame].size.width / 2.0 - 100, [[self contentView] frame].size.height - 30, 200, 18)];
		textScroll = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 45, [[self contentView] frame].size.width - 20, [[self contentView] frame].size.height -91)];
		language = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(10, 10, contentRect.size.width - 320, 22) pullsDown:NO];
		service = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(contentRect.size.width - 310, 10, 125, 22) pullsDown:NO];
		makePrivate = [[NSButton alloc] initWithFrame:NSMakeRect(contentRect.size.width - 180, 10, 90, 22)];
		
		[textView setFont:[NSFont systemFontOfSize:13]];
		NSClipView * cv = [[NSClipView alloc] initWithFrame:NSMakeRect(0, 0, [[self contentView] frame].size.width - 20, [[self contentView] frame].size.height - 91)];
		[cv setDocumentView:textView];
		[textScroll setContentView:cv];
		[textScroll setScrollsDynamically:YES];
		[textScroll setHasVerticalScroller:YES];
		[cv release];
		[self.contentView addSubview:textScroll];
		[textView setDelegate:self];
		
		[service addItemsWithTitles:[[SettingsController sharedSettings] possibleServices]];
		[language addItemsWithTitles:[[SettingsController sharedSettings] possibleDefaultLanguages]];
		[service setTarget:self];
		[service setAction:@selector(serviceChange:)];
		
		submitButton = [[NSButton alloc] initWithFrame:NSMakeRect(contentRect.size.width - 90, 10, 80, 24)];
		[submitButton setBezelStyle:NSTexturedRoundedBezelStyle];
		[submitButton setTitle:@"Paste!"];
		[submitButton setTarget:self];
		[submitButton setAction:@selector(submit:)];
		
		[titleLabel setBackgroundColor:[NSColor clearColor]];
		[titleLabel setBordered:NO];
		[titleLabel setSelectable:NO];
		[titleLabel setFont:[NSFont boldSystemFontOfSize:14.0]];
		[titleLabel setAlignment:NSCenterTextAlignment];
		[titleLabel setStringValue:@"New Paste"];
		
		[makePrivate setButtonType:NSSwitchButton];
		[makePrivate setTitle:@"Private"];
		[makePrivate setState:[[SettingsController sharedSettings] getMakePrivate]];
		[makePrivate setFont:[NSFont systemFontOfSize:13]];
		
		if (![MultiServiceHandler serviceHasPrivatePosts:[[SettingsController sharedSettings] getDefaultService]]) {
			[makePrivate setState:0];
			[makePrivate setEnabled:NO];
		}
		
		[self.contentView addSubview:language];
		[self.contentView addSubview:service];
		[self.contentView addSubview:submitButton];
		[self.contentView addSubview:titleLabel];
		[self.contentView addSubview:makePrivate];
		[language selectItemWithTitle:[[SettingsController sharedSettings] getDefaultLanguage]];
		[service selectItemWithTitle:[[SettingsController sharedSettings] getDefaultService]];
		[self becomeKeyWindow];
		[self makeFirstResponder:[self contentView]];
		[self performSelector:@selector(makeFirstResponder:) withObject:textView afterDelay:0.5];
		[textView performSelector:@selector(selectAll:) withObject:self afterDelay:0.5];
	}
	return self;
}

- (BOOL)canBecomeKeyWindow {
	return YES;
}

- (void)keyUp:(NSEvent *)theEvent {
	if ([theEvent keyCode] == 53) {
		[self orderOut:self];
	}
}

- (void)submit:(id)sender {
	BOOL private = [makePrivate state];
	PasteWindow * pw = [[PasteWindow alloc] initWithText:[textView string] language:[language titleOfSelectedItem] service:[service titleOfSelectedItem] makePrivate:private];
	[pw makeKeyAndOrderFront:self];
	[pw startPosting];
	[pw release];
	[self orderOut:self];
}

- (void)serviceChange:(id)sender {
	NSString * curTitle = [language titleOfSelectedItem];
	[language removeAllItems];
	[language addItemsWithTitles:[[SettingsController sharedSettings] possibleDefaultLanguagesForService:[service titleOfSelectedItem]]];
	if ([language itemWithTitle:curTitle]) {
		[language selectItemWithTitle:curTitle];
	} else [language selectItemWithTitle:@"Plain Text"];
	
	if (![MultiServiceHandler serviceHasPrivatePosts:[service titleOfSelectedItem]]) {
		[makePrivate setState:0];
		[makePrivate setEnabled:NO];
	} else {
		if (![makePrivate isEnabled]) {
			[makePrivate setState:[[SettingsController sharedSettings] getMakePrivate]];
			[makePrivate setEnabled:YES];
		}
	}
}

- (void)orderOut:(id)sender {
	[[FocusManager sharedFocusManager] resignAppFocus];
	[super orderOut:sender];
}

- (void)dealloc {
	[titleLabel release];
	[textView release];
	[language release];
	[submitButton release];
	[closeButton release];
    [super dealloc];
}

@end
