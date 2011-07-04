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
		bundlePath = [[appBundle retain] stringByStandardizingPath];
	}
	return self;
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
			CFStringRef string = CFURLCopyPath(itemURL);
			if (CFStringCompare(string, (CFStringRef)bundlePath, 0) == kCFCompareEqualTo) {
				wasFound = YES;
			}
			CFRelease(string);
		}
	}
	CFRelease(loginItems);
	CFRelease(theLoginItemsRefs);
	return NO;
}

- (void)addBundleToLaunchItems {
	
}

- (void)removeBundleFromLaunchItems {
	
}

- (void)dealloc {
	[bundlePath release];
    [super dealloc];
}

@end
