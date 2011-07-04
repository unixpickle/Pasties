//
//  ANWindowRoundedView.m
//  Pasties
//
//  Created by Alex Nichol on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ANWindowRoundedView.h"


@implementation ANWindowRoundedView

@synthesize baseColor;

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.baseColor = [NSColor colorWithCalibratedRed:0.89 green:0.89 blue:0.89 alpha:0.9];
		smallImage = [[NSImage imageNamed:@"window@250x65.png"] retain];
		largeImage = [[NSImage imageNamed:@"window@250x95.png"] retain];
    }
    return self;
}

- (BOOL)canBecomeKeyView {
	return YES;
}

- (void)dealloc {
	self.baseColor = nil;
	[smallImage release];
	[largeImage release];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	if (self.frame.size.height == 65) {
		[smallImage drawAtPoint:NSMakePoint(0, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.9];
	} else if (self.frame.size.height == 95) {
		[largeImage drawAtPoint:NSMakePoint(0, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.9];
	} else {
		NSBezierPath * path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height) xRadius:15 yRadius:15];
		[self.baseColor set];
		[path fill];
	}
}

@end
