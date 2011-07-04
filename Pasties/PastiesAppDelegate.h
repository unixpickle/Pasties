//
//  PastiesAppDelegate.h
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PasteWindow.h"
#import "SettingsWindow.h"
#import "PasteComposeWindow.h"
#import "ANKeyEvent.h"
#import "FocusManager.h"
#import "LanguageDetection.h"
#import "StartAtLoginController.h"

@interface PastiesAppDelegate : NSObject <NSApplicationDelegate> {
	NSStatusItem * systemMenu;
	ANKeyEvent * newPasteKeyEvent;
	ANKeyEvent * pasteClipboardKeyEvent;
}

- (void)newPaste:(id)sender;
- (void)pasteClipboard:(id)sender;
- (void)showSettings:(id)sender;

@end
