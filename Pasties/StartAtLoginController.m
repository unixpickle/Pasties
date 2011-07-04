//
//  StartAtLoginController.m
//  Pasties
//
//  Created by Alex Nichol on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StartAtLoginController.h"


@implementation StartAtLoginController

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithBundlePath:(NSString *)appBundle {
	if ((self = [super init])) {
		bundlePath = [[appBundle stringByStandardizingPath] retain];
	}
	return self;
}

+ (StartAtLoginController *)controllerForCurrentAppBundle {
	return [[[StartAtLoginController alloc] initWithBundlePath:[[NSBundle mainBundle] bundlePath]] autorelease];
}

- (BOOL)bundleExistsInLaunchItems {
	BOOL wasFound = NO;
	UInt32 seed;
	LSSharedFileListRef theLoginItemsRefs = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	CFArrayRef loginItems = LSSharedFileListCopySnapshot(theLoginItemsRefs, &seed);
	for (int i = 0; i < CFArrayGetCount(loginItems); i++) {
		CFTypeRef object = CFArrayGetValueAtIndex(loginItems, i);
		LSSharedFileListItemRef item = (LSSharedFileListItemRef)object;
		CFURLRef itemURL;
		if (LSSharedFileListItemResolve(item, 0, &itemURL, NULL) == noErr) {
			CFStringRef origPath = CFURLCopyPath(itemURL);
			NSString * string = [(NSString *)origPath stringByStandardizingPath];
			if ([string isEqualToString:bundlePath]) {
				wasFound = YES;
			}
			CFRelease(origPath);
			CFRelease(itemURL);
			if (wasFound) break;
		}
	}
	CFRelease(loginItems);
	CFRelease(theLoginItemsRefs);
	return wasFound;
}

- (void)addBundleToLaunchItems {
	LSSharedFileListRef theLoginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:bundlePath];
	LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(theLoginItemsRef, kLSSharedFileListItemLast, NULL, NULL, url, NULL, NULL);
	if (item) CFRelease(item);
	CFRelease(theLoginItemsRef);
}

- (void)removeBundleFromLaunchItems {
	UInt32 seed;
	LSSharedFileListRef theLoginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	CFURLRef url = CFURLCreateFilePathURL(NULL, (CFURLRef)[NSURL fileURLWithPath:bundlePath], NULL);
	CFArrayRef items = LSSharedFileListCopySnapshot(theLoginItemsRef, &seed);
	for (CFIndex i = 0; i < CFArrayGetCount(items); i++) {
		CFTypeRef object = CFArrayGetValueAtIndex(items, i);
		LSSharedFileListItemRef item = (LSSharedFileListItemRef)object;
		CFURLRef itemURL;
		if (LSSharedFileListItemResolve(item, 0, &itemURL, NULL) == noErr) {
			CFStringRef origPath = CFURLCopyPath(itemURL);
			NSString * string = [(NSString *)origPath stringByStandardizingPath];
			CFRelease(origPath);
			if ([string isEqualToString:bundlePath]) {
				LSSharedFileListItemRemove(theLoginItemsRef, item);
				CFRelease(itemURL);
				break;
			}
		}
		CFRelease(itemURL);
	}
	CFRelease(items);
	CFRelease(url);
	CFRelease(theLoginItemsRef);
}

- (void)dealloc {
	[bundlePath release];
    [super dealloc];
}

@end
