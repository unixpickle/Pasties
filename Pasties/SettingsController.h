//
//  SettingsController.h
//  Pasties
//
//  Created by Alex Nichol on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultiServiceHandler.h"


@interface SettingsController : NSObject {
    NSUserDefaults * defaults;
	NSMutableArray * settingsWindows;
}

+ (SettingsController *)sharedSettings;
- (NSString *)getDefaultLanguage;
- (void)setDefaultLanguage:(NSString *)language;
- (NSString *)getDefaultService;
- (void)setDefaultService:(NSString *)service;
- (BOOL)getAutodetectLanguage;
- (void)setAutodetectLanguage:(BOOL)autodetect;

- (NSArray *)possibleDefaultLanguages;
- (NSArray *)possibleServices;
- (NSArray *)possibleDefaultLanguagesForService:(NSString *)service;

- (void)addSettingsWindow:(NSWindow *)aWindow;
- (void)removeSettingsWindow:(NSWindow *)aWindow;
- (NSWindow *)firstSettingsWindow;

@end
