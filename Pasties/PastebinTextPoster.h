//
//  PastebinTextPoster.h
//  Pasties
//
//  Created by Alex Nichol on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnlineTextPoster.h"
#import "PastebinLanguage.h"
#import "NSError+Message.h"
#import "NSDictionary+URLEncode.h"
#import "HTTPNoRedirect.h"

#define kPastebinPostPage @"http://pastebin.com/post.php"
#define kPastebinTextPosterPostError 1

@interface PastebinTextPoster : OnlineTextPoster {
	NSString * text;
	PastebinLanguage * language;
	NSThread * backgroundThread;
}

@property (retain) NSThread * backgroundThread;

- (id)initWithText:(NSString *)theText language:(id)language;
- (BOOL)postInBackground;

@end
