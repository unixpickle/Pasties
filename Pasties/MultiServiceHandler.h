//
//  MultiServiceHandler.h
//  Pasties
//
//  Created by Alex Nichol on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PastieTextPoster.h"
#import "PastebayTextPoster.h"
#import "PastebinTextPoster.h"

@interface MultiServiceHandler : NSObject {
    
}

+ (NSArray *)possibleServices;
+ (NSArray *)possibleLanguagesForService:(NSString *)service;
+ (OnlineTextPoster *)textPosterWithText:(NSString *)text language:(NSString *)languageName service:(NSString *)serviceName;
+ (NSString *)convertLanguage:(NSString *)lang toService:(NSString *)service;

@end
