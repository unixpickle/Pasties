//
//  SettingsWindow.h
//  Pasties
//
//  Created by Alex Nichol on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsController.h"
#import "FocusManager.h"
#import "StartAtLoginController.h"

@interface SettingsWindow : NSWindow {
    NSPopUpButton * defaultLanguage;
	NSPopUpButton * defaultService;
	NSButton * autodetectLanguage;
	NSButton * startAtLogin;
	NSButton * privatePost;
	NSButton * applyButton;
	NSButton * cancelButton;
	SettingsController * settings;
}

- (id)initWithSettings:(SettingsController *)sc;
- (void)apply:(id)sender;
- (void)cancel:(id)sender;
- (void)valueChanged:(id)sender;

@end
