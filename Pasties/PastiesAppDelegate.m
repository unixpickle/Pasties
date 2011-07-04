//
//  PastiesAppDelegate.m
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PastiesAppDelegate.h"

@interface PastiesAppDelegate (Private)

- (NSImage *)stretchForSystemBar:(NSImage *)systemItem;
- (void)configureMenu;

@end

@implementation PastiesAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	[self configureMenu];
	/* Key code for 'p' is 35 */
	newPasteKeyEvent = [[ANKeyEvent alloc] initWithKeycode:35 modifiers:(ANKeyEventKeyModifierCommand | ANKeyEventKeyModifierAlt)];
	pasteClipboardKeyEvent = [[ANKeyEvent alloc] initWithKeycode:35 modifiers:(ANKeyEventKeyModifierCommand | ANKeyEventKeyModifierAlt | ANKeyEventKeyModifierShift)];
	[newPasteKeyEvent setTarget:self];
	[pasteClipboardKeyEvent setTarget:self];
	[newPasteKeyEvent setAction:@selector(newPaste:)];
	[pasteClipboardKeyEvent setAction:@selector(pasteClipboard:)];
	[newPasteKeyEvent registerAction];
	[pasteClipboardKeyEvent registerAction];
	// setup statup items
	SettingsController * sc = [SettingsController sharedSettings];
	if ([sc isFirstLaunch]) {
		StartAtLoginController * salc = [StartAtLoginController controllerForCurrentAppBundle];
		if (![salc bundleExistsInLaunchItems]) {
			[[FocusManager sharedFocusManager] forceAppFocus];
			int opt = (int)NSRunAlertPanel(@"Start at Login!", @"If you add this application to your login items, the system bar icon will always be visible while you are logged in.  Adding this application to your login items is highly suggested.  Would you like to do it?", @"Add to Login Items", @"No, thanks", nil);
			if (opt == 1) {
				[salc addBundleToLaunchItems];
			}
		}
		[sc setIsFirstLaunch:NO];
	}
}

- (void)applicationDidResignActive:(NSNotification *)notification {
	[[FocusManager sharedFocusManager] setSecondaryMainApp:[CarbonAppProcess frontmostProcess]];
}

- (void)applicationWillBecomeActive:(NSNotification *)notification {
	CarbonAppProcess * frontmost = [CarbonAppProcess frontmostProcess];
	CarbonAppProcess * current = [CarbonAppProcess currentProcess];
	if (![frontmost isEqual:current]) {
		[[FocusManager sharedFocusManager] setSecondaryMainApp:[CarbonAppProcess frontmostProcess]];
	}
}

- (void)newPaste:(id)sender {
	NSRect screenFrame = [[NSScreen mainScreen] visibleFrame];
	NSRect centerFrame = NSMakeRect(screenFrame.size.width / 2.0 - 250, screenFrame.size.height / 2.0 - 250, 500, 400);
	PasteComposeWindow * composeWindow = [[PasteComposeWindow alloc] initWithContentRect:centerFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	[composeWindow makeKeyAndOrderFront:self];
	[[FocusManager sharedFocusManager] forceAppFocus];
}

- (void)pasteClipboard:(id)sender {
	NSPasteboard * pboard = [NSPasteboard generalPasteboard];
	NSString * str = [pboard stringForType:NSPasteboardTypeString];
	if (str) {
		NSString * language = [[SettingsController sharedSettings] getDefaultLanguage];
		NSString * service = [[SettingsController sharedSettings] getDefaultService];
		if ([[SettingsController sharedSettings] getAutodetectLanguage]) {
			LanguageDetection * detection = [[LanguageDetection alloc] initWithText:str];
			NSString * guess = [detection languageGuess];
			[detection release];
			if (guess) {
				NSLog(@"Guessed language: %@", guess);
			}
			language = [MultiServiceHandler convertLanguage:guess toService:service];
		}
		PasteWindow * window = [[PasteWindow alloc] initWithText:str language:language service:service];
		if (!window) {
			if (![language isEqualToString:[[SettingsController sharedSettings] getDefaultLanguage]]) {
				window = [[PasteWindow alloc] initWithText:str language:[[SettingsController sharedSettings] getDefaultLanguage] service:service];
			}
		}
		if (!window) NSRunAlertPanel(@"Invalid Format", @"Something is pretty messed up.", @"OK", nil, nil);
		[window makeKeyAndOrderFront:self];
		[window startPosting];
		[window release];
	}
}

- (void)showSettings:(id)sender {
	if ([[SettingsController sharedSettings] firstSettingsWindow]) {
		[[[SettingsController sharedSettings] firstSettingsWindow] makeKeyAndOrderFront:self];
		return;
	}
	SettingsWindow * window = [[SettingsWindow alloc] initWithSettings:[SettingsController sharedSettings]];
	[window makeKeyAndOrderFront:self];
	[window release];
	[[FocusManager sharedFocusManager] forceAppFocus];
}

#pragma mark Private

- (void)configureMenu {
	NSZone * menuZone = [NSMenu menuZone];
	NSMenu * menu = [[NSMenu allocWithZone:menuZone] init];
	systemMenu = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
	
	NSMenuItem * item = [menu addItemWithTitle:@"New Paste" action:@selector(newPaste:) keyEquivalent:@"p"];
	[item setTarget:self];
	[item setKeyEquivalentModifierMask:(NSCommandKeyMask | NSAlternateKeyMask)];
	
	item = [menu addItemWithTitle:@"Paste Clipboard" action:@selector(pasteClipboard:) keyEquivalent:@"p"];
	[item setTarget:self];
	[item setKeyEquivalentModifierMask:(NSCommandKeyMask | NSAlternateKeyMask | NSShiftKeyMask)];
	
	[menu addItem:[NSMenuItem separatorItem]];
	[[menu addItemWithTitle:@"Preferences" action:@selector(showSettings:) keyEquivalent:@""] setTarget:self];
	[menu addItem:[NSMenuItem separatorItem]];
	[[menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""] setTarget:[NSApplication sharedApplication]];
	
	systemMenu = [[[NSStatusBar systemStatusBar]
				   statusItemWithLength:NSSquareStatusItemLength] retain];
    [systemMenu setMenu:menu];
    [systemMenu setHighlightMode:YES];
    [systemMenu setToolTip:@"Pasties"];
    [systemMenu setImage:[self stretchForSystemBar:[NSImage imageNamed:@"clipboard.png"]]];
	[systemMenu setAlternateImage:[self stretchForSystemBar:[NSImage imageNamed:@"clipboard_inv.png"]]];
	[menu release];
}

- (NSImage *)stretchForSystemBar:(NSImage *)systemItem {
	NSImage * stretched = [[NSImage alloc] initWithSize:NSMakeSize(18, 19)];
	[stretched lockFocus];
	[systemItem drawAtPoint:NSMakePoint(0, 0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	[stretched unlockFocus];
	NSImage * final = [[NSImage alloc] initWithData:[stretched TIFFRepresentation]];
	[stretched release];
	return [final autorelease];
}

- (void)dealloc {
	[newPasteKeyEvent release];
	[pasteClipboardKeyEvent release];
	[super dealloc];
}

@end
