//
//  StartAtLoginController.h
//  Pasties
//
//  Created by Alex Nichol on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StartAtLoginController : NSObject {
    NSString * bundlePath;
}

- (id)initWithBundlePath:(NSString *)appBundle;
+ (StartAtLoginController *)controllerForCurrentAppBundle;
- (BOOL)bundleExistsInLaunchItems;
- (void)addBundleToLaunchItems;
- (void)removeBundleFromLaunchItems;

@end
