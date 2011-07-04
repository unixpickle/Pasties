//
//  PasteWindow.h
//  Pasties
//
//  Created by Alex Nichol on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANNotificationWindow.h"
#import "MultiServiceHandler.h"


@interface PasteWindow : ANNotificationWindow <OnlineTextPosterDelegate> {
    OnlineTextPoster * poster;
	NSProgressIndicator * loadingBar;
	NSTextField * activityLabel;
	NSButton * cancelButton;
	NSButton * viewButton;
	NSButton * copyButton;
	
	NSURL * launchURL;
	
	NSTextField * detailURLLabel;
	NSImageView * statusImage; // x or check mark
	CGFloat origY;
}

@property (nonatomic, retain) NSURL * launchURL;

- (id)initWithText:(NSString *)text language:(NSString *)language service:(NSString *)service;
- (void)startPosting;
- (void)close:(id)sender;
- (void)view:(id)sender;
- (void)copy:(id)sender;

@end
