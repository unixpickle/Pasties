//
//  ANCloseButton.m
//  Pasties
//
//  Created by Alex Nichol on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ANCloseButton.h"


@implementation ANCloseButton

@synthesize unpressed;
@synthesize pressed;
@synthesize containingWindow;

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code here.
		self.pressed = [NSImage imageNamed:@"close_press.png"];
		self.unpressed = [NSImage imageNamed:@"close_unpress.png"];
    }
    return self;
}

- (void)dealloc {
	self.pressed = nil;
	self.unpressed = nil;
    [super dealloc];
}

- (void)mouseDown:(NSEvent *)theEvent {
	isPressed = YES;
	[self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
	[self.containingWindow orderOut:self];
	isPressed = NO;
	[self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
	isPressed = NO;
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	if (isPressed) {
		[self.pressed drawAtPoint:NSMakePoint(0, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	} else {
		[self.unpressed drawAtPoint:NSMakePoint(0, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	}
}

@end
