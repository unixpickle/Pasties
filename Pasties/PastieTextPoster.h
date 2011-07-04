//
//  PastieTextPoster.h
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+Message.h"
#import "NSDictionary+URLEncode.h"
#import "HTTPNoRedirect.h"
#import "OnlineTextPoster.h"
#import "PastieLanguage.h"

#define kPastieHome @"http://pastie.org"
#define kPastieTextPosterNoAuthorizationKeyError 1
#define kPastieTextPosterEncodeFailed 2
#define kPastieTextPosterPostFailed 3

@interface PastieTextPoster : OnlineTextPoster {
	NSString * text;
	PastieLanguage * language;
	NSThread * backgroundThread;
}

@property (retain) NSThread * backgroundThread;

- (id)initWithText:(NSString *)theText language:(id)theLanguage;
- (BOOL)postInBackground;

@end
