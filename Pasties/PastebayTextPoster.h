//
//  PastebayTextPoster.h
//  Pasties
//
//  Created by Alex Nichol on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+Message.h"
#import "NSDictionary+URLEncode.h"
#import "HTTPNoRedirect.h"
#import "OnlineTextPoster.h"
#import "PastebayLanguage.h"

#define kPastebayPostPage @"http://pastebay.com/pastebay.php"

@interface PastebayTextPoster : OnlineTextPoster {
    NSString * text;
	PastebayLanguage * language;
	NSThread * backgroundThread;
}

@property (retain) NSThread * backgroundThread;

- (id)initWithText:(NSString *)theText language:(id)theLanguage;
- (BOOL)postInBackground;

@end
