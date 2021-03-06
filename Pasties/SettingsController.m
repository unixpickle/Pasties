//
//  SettingsController.m
//  Pasties
//
//  Created by Alex Nichol on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"

@implementation SettingsController

- (id)init {
    if ((self = [super init])) {
        defaults = [[NSUserDefaults standardUserDefaults] retain];
		settingsWindows = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (SettingsController *)sharedSettings {
	static SettingsController * sc = nil;
	if (!sc) sc = [[SettingsController alloc] init];
	return [[sc retain] autorelease];
}

#pragma mark User Defined Settings

- (NSString *)getDefaultLanguage {
	NSString * lang = [defaults objectForKey:@"Language"];
	if (!lang) {
		[self setDefaultLanguage:@"Plain Text"];
		return @"Plain Text";
	}
	return lang;
}

- (void)setDefaultLanguage:(NSString *)language {
	[defaults setObject:language forKey:@"Language"];
	[defaults synchronize];
}

- (NSString *)getDefaultService {
	NSString * service = [defaults objectForKey:@"Service"];
	if (!service) {
		[self setDefaultService:@"Pastie"];
		return @"Pastie";
	}
	return service;
}

- (void)setDefaultService:(NSString *)service {
	[defaults setObject:service forKey:@"Service"];
	[defaults synchronize];
}

- (BOOL)getAutodetectLanguage {
	NSNumber * autodetect = [defaults objectForKey:@"Autodetect"];
	if (!autodetect) {
		[self setAutodetectLanguage:NO];
		return NO;
	}
	return [autodetect boolValue];
}

- (void)setAutodetectLanguage:(BOOL)autodetect {
	[defaults setObject:[NSNumber numberWithBool:autodetect] forKey:@"Autodetect"];
	[defaults synchronize];
}

- (BOOL)isFirstLaunch {
	NSNumber * n = [defaults objectForKey:@"HasUsed"];
	if (!n || [n boolValue] == NO) return YES;
	return NO;
}

- (void)setIsFirstLaunch:(BOOL)isFirst {
	[defaults setObject:[NSNumber numberWithBool:(isFirst ^ 1)] forKey:@"HasUsed"];
	[defaults synchronize];
}

- (void)setMakePrivate:(BOOL)isPrivate {
	[defaults setObject:[NSNumber numberWithBool:isPrivate] forKey:@"IsPrivate"];
	[defaults synchronize];
}

- (BOOL)getMakePrivate {
	NSNumber * n = [defaults objectForKey:@"IsPrivate"];
	if (!n) {
		[self setMakePrivate:NO];
		return NO;
	}
	return [n boolValue];
}

#pragma mark Utils

- (NSArray *)possibleDefaultLanguages {
	return [MultiServiceHandler possibleLanguagesForService:[self getDefaultService]];
}

- (NSArray *)possibleServices {
	return [MultiServiceHandler possibleServices];
}

- (NSArray *)possibleDefaultLanguagesForService:(NSString *)service {
	return [MultiServiceHandler possibleLanguagesForService:service];
}

#pragma mark UI

- (void)addSettingsWindow:(NSWindow *)aWindow {
	[settingsWindows addObject:aWindow];
}
- (void)removeSettingsWindow:(NSWindow *)aWindow {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[settingsWindows removeObject:aWindow];
	[pool drain];
}
- (NSWindow *)firstSettingsWindow {
	if ([settingsWindows count] == 0) return nil;
	else return [settingsWindows objectAtIndex:0];
}

- (void)dealloc {
	NSLog(@"-dealloc: Settings controller");
	[defaults release];
	[settingsWindows release];
    [super dealloc];
}

@end
