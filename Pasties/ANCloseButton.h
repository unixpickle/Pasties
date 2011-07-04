//
//  ANCloseButton.h
//  Pasties
//
//  Created by Alex Nichol on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ANCloseButton : NSView {
    NSImage * unpressed;
	NSImage * pressed;
	BOOL isPressed;
	NSWindow * containingWindow;
}

@property (nonatomic, retain) NSImage * unpressed;
@property (nonatomic, retain) NSImage * pressed;
@property (nonatomic, assign) NSWindow * containingWindow;

@end
