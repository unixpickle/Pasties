//
//  ANWindowRoundedView.h
//  Pasties
//
//  Created by Alex Nichol on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


@interface ANWindowRoundedView : NSView {
    NSColor * baseColor;
	NSImage * smallImage;
	NSImage * largeImage;
}

@property (nonatomic, retain) NSColor * baseColor;

@end
