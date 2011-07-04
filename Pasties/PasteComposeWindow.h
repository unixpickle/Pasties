//
//  PasteComposeWindow.h
//  Pasties
//
//  Created by Alex Nichol on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANNotificationWindow.h"
#import "ANCloseButton.h"
#import "PasteWindow.h"
#import "SettingsController.h"
#import "FocusManager.h"

@interface PasteComposeWindow : ANNotificationWindow <NSTextViewDelegate> {
	NSTextView * textView;
	NSTextField * titleLabel;
	NSScrollView * textScroll;
	NSPopUpButton * language;
	NSPopUpButton * service;
	NSButton * submitButton;
	ANCloseButton * closeButton;
}

- (void)submit:(id)sender;
- (void)serviceChange:(id)sender;

@end
