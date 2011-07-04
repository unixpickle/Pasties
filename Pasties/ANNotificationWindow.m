//
//  ANNotificationWindow.m
//  Pasties
//
//  Created by Alex Nichol on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ANNotificationWindow.h"


@implementation ANNotificationWindow

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])) {
		[self setMovableByWindowBackground:YES];
		[self setContentView:[[[ANWindowRoundedView alloc] initWithFrame:NSMakeRect(0, 0, contentRect.size.width, contentRect.size.height)] autorelease]];
		[self setBackgroundColor:[NSColor clearColor]];
		[self setOpaque:NO];
		[self setLevel:CGShieldingWindowLevel()];
		[self setHasShadow:YES];
		[self setCollectionBehavior:([self collectionBehavior] | NSWindowCollectionBehaviorCanJoinAllSpaces)];
	}
	return self;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen {
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen])) {
		[self setMovableByWindowBackground:YES];
		[self setContentView:[[[ANWindowRoundedView alloc] initWithFrame:NSMakeRect(0, 0, contentRect.size.width, contentRect.size.height)] autorelease]];
		[self setBackgroundColor:[NSColor clearColor]];
		[self setOpaque:NO];
		[self setLevel:CGShieldingWindowLevel()];
		[self setHasShadow:YES];
		[self setCollectionBehavior:([self collectionBehavior] | NSWindowCollectionBehaviorCanJoinAllSpaces)];
	}
	return self;
}

- (BOOL)canBecomeMainWindow {
	return YES;
}

- (BOOL)canBecomeKeyWindow {
	return YES;
}

- (void)dealloc {
    [super dealloc];
}

@end
