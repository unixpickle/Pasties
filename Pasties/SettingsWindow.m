//
//  SettingsWindow.m
//  Pasties
//
//  Created by Alex Nichol on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsWindow.h"


@implementation SettingsWindow

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithSettings:(SettingsController *)sc {
	NSRect screenRect = [[NSScreen mainScreen] frame];
	NSRect contentRect = NSMakeRect(screenRect.size.width / 2.0 - 200, screenRect.size.height / 2.0 - (160.0 / 3.0), 400, 221);
	if ((self = [super initWithContentRect:contentRect styleMask:(NSTitledWindowMask | NSClosableWindowMask) backing:NSBackingStoreBuffered defer:NO])) {
		[self setCollectionBehavior:([self collectionBehavior] | NSWindowCollectionBehaviorCanJoinAllSpaces)];
		[self setLevel:CGShieldingWindowLevel()];
		[self setTitle:@"Pasties Preferences"];
		applyButton = [[NSButton alloc] initWithFrame:NSMakeRect(contentRect.size.width - 105, 10, 100, 24)];
		cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(contentRect.size.width - 200, 10, 100, 24)];
		defaultLanguage = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(130, contentRect.size.height - 32, 200, 22)];
		defaultService = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(130, contentRect.size.height - 64, 200, 22)];
		autodetectLanguage = [[NSButton alloc] initWithFrame:NSMakeRect(10, contentRect.size.height - 106, 380, 22)];
		startAtLogin = [[NSButton alloc] initWithFrame:NSMakeRect(10, contentRect.size.height - 133, 380, 22)];
		privatePost = [[NSButton alloc] initWithFrame:NSMakeRect(10, contentRect.size.height - 160, 380, 22)];
		NSTextField * languageLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(10, contentRect.size.height - 32, 120, 22)];
		NSTextField * serviceLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(10, contentRect.size.height - 64, 120, 22)];
		
		[languageLabel setStringValue:@"Default Language:"];
		[languageLabel setBackgroundColor:[NSColor clearColor]];
		[languageLabel setBordered:NO];
		[languageLabel setEditable:NO];
		[languageLabel setSelectable:NO];
		[languageLabel setFont:[NSFont systemFontOfSize:13]];
		
		[serviceLabel setStringValue:@"Default Service:"];
		[serviceLabel setBackgroundColor:[NSColor clearColor]];
		[serviceLabel setBordered:NO];
		[serviceLabel setEditable:NO];
		[serviceLabel setSelectable:NO];
		[serviceLabel setFont:[NSFont systemFontOfSize:13]];
		
		[cancelButton setBezelStyle:NSRoundedBezelStyle];
		[cancelButton setTitle:@"Cancel"];
		[cancelButton setTarget:self];
		[cancelButton setAction:@selector(cancel:)];
		[cancelButton setFont:[NSFont systemFontOfSize:13]];
		[cancelButton setKeyEquivalent:@"w"];
		[cancelButton setKeyEquivalentModifierMask:NSCommandKeyMask];
		
		[applyButton setBezelStyle:NSRoundedBezelStyle];
		[applyButton setTitle:@"Apply"];
		[applyButton setTarget:self];
		[applyButton setAction:@selector(apply:)];
		[applyButton setFont:[NSFont systemFontOfSize:13]];
		
		[defaultLanguage addItemsWithTitles:[sc possibleDefaultLanguages]];
		[defaultLanguage selectItemWithTitle:[sc getDefaultLanguage]];
		[defaultLanguage setTarget:self];
		[defaultLanguage setAction:@selector(valueChanged:)];
		
		[defaultService addItemsWithTitles:[sc possibleServices]];
		[defaultService selectItemWithTitle:[sc getDefaultService]];
		[defaultService setTarget:self];
		[defaultService setAction:@selector(valueChanged:)];
		
		[autodetectLanguage setButtonType:NSSwitchButton];
		[autodetectLanguage setTitle:@"Auto-detect language when pasting from clipboard"];
		[autodetectLanguage setTarget:self];
		[autodetectLanguage setAction:@selector(valueChanged:)];
		[autodetectLanguage setState:[sc getAutodetectLanguage]];
		[autodetectLanguage setFont:[NSFont systemFontOfSize:13]];
		
		[privatePost setButtonType:NSSwitchButton];
		[privatePost setTitle:@"Make pastes private if applicable"];
		[privatePost setTarget:self];
		[privatePost setAction:@selector(valueChanged:)];
		[privatePost setState:[sc getMakePrivate]];
		[privatePost setFont:[NSFont systemFontOfSize:13]];
		
		[startAtLogin setButtonType:NSSwitchButton];
		[startAtLogin setTitle:@"Start Pasties at login"];
		[startAtLogin setTarget:self];
		[startAtLogin setAction:@selector(valueChanged:)];
		[startAtLogin setState:[[StartAtLoginController controllerForCurrentAppBundle] bundleExistsInLaunchItems]];
		[startAtLogin setFont:[NSFont systemFontOfSize:13]];
		
		[[self contentView] addSubview:defaultLanguage];
		[[self contentView] addSubview:defaultService];
		[[self contentView] addSubview:autodetectLanguage];
		[[self contentView] addSubview:startAtLogin];
		[[self contentView] addSubview:privatePost];
		[[self contentView] addSubview:applyButton];
		[[self contentView] addSubview:cancelButton];
		[[self contentView] addSubview:languageLabel];
		[[self contentView] addSubview:serviceLabel];
		
		[languageLabel release];
		[serviceLabel release];
		[sc addSettingsWindow:self];
		settings = [sc retain];
		[applyButton setEnabled:NO];
		[self setReleasedWhenClosed:NO];
	}
	return self;
}

- (void)orderOut:(id)sender {
	[super orderOut:sender];
	[settings removeSettingsWindow:self];
	[[FocusManager sharedFocusManager] resignAppFocus];
}

- (void)apply:(id)sender {
	[settings setDefaultService:[defaultService titleOfSelectedItem]];
	if ([[settings possibleDefaultLanguages] containsObject:[defaultLanguage titleOfSelectedItem]]) {
		[settings setDefaultLanguage:[NSString stringWithString:[defaultLanguage titleOfSelectedItem]]];
	} else {
		[settings setDefaultLanguage:[[settings possibleDefaultLanguages] objectAtIndex:0]];
	}
	StartAtLoginController * startupController = [StartAtLoginController controllerForCurrentAppBundle];
	if ([startAtLogin state] != [startupController bundleExistsInLaunchItems]) {
		if (![startAtLogin state]) {
			[startupController removeBundleFromLaunchItems];
		} else {
			[startupController addBundleToLaunchItems];
		}
	}
	[settings setAutodetectLanguage:[autodetectLanguage state]];
	[settings setMakePrivate:[privatePost state]];
	[applyButton setEnabled:NO];
}
- (void)cancel:(id)sender {
	[self orderOut:sender];
}
- (void)valueChanged:(id)sender {
	[applyButton setEnabled:YES];
	if (sender == defaultService) {
		NSString * title = [defaultLanguage titleOfSelectedItem];
		NSArray * langs = [settings possibleDefaultLanguagesForService:[defaultService titleOfSelectedItem]];
		[defaultLanguage removeAllItems];
		[defaultLanguage addItemsWithTitles:langs];
		if ([langs containsObject:title]) {
			[defaultLanguage selectItemWithTitle:title];
		}
	}
}

- (void)dealloc {
	[defaultLanguage release];
	[defaultService release];
	[autodetectLanguage release];
	[applyButton release];
	[cancelButton release];
	[settings release];
    [super dealloc];
}

@end
