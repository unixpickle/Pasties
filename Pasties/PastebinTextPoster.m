//
//  PastebinTextPoster.m
//  Pasties
//
//  Created by Alex Nichol on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PastebinTextPoster.h"

@interface PastebinTextPoster (Private)

- (void)backgroundThread:(NSDictionary *)userInfo;
- (NSURL *)postDictionray:(NSDictionary *)params error:(NSError **)error;
- (void)_informDelegateError:(NSError *)error;
- (void)_informDelegateGotURL:(NSURL *)theURL;

@end

@implementation PastebinTextPoster

@synthesize backgroundThread;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithText:(NSString *)theText language:(id)theLanguage {
	if ((self = [super initWithText:theText language:theLanguage])) {
		text = [theText retain];
		language = [theLanguage retain];
	}
	return self;
}

- (BOOL)postInBackground {
	if (self.backgroundThread) return NO;
	NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[[text copy] autorelease], @"text", [[language copy] autorelease], @"language", nil];
	backgroundThread = [[NSThread alloc] initWithTarget:self selector:@selector(backgroundThread:) object:userInfo];
	[backgroundThread start];
	return YES;
}

- (void)backgroundThread:(NSDictionary *)userInfo {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSString * theText = [userInfo objectForKey:@"text"];
	PastebinLanguage * theLanguage = [userInfo objectForKey:@"language"];
	// post info.
	NSString * name = [NSString stringWithFormat:@"Pasties %@", [NSDate date]];
	NSDictionary * postParams = [NSDictionary dictionaryWithObjectsAndKeys:@"submit_hidden", @"submit_hidden",
								 theText, @"paste_code",
								 [NSString stringWithFormat:@"%d", [theLanguage languageType]], @"paste_format",
								 @"N", @"paste_expire_date", 
								 @"0", @"paste_private", 
								 name, @"paste_name", nil];
	NSError * e = nil;
	NSURL * postURL = [self postDictionray:postParams error:&e];
	if (!postURL) {
		[self _informDelegateError:e];
	} else {
		[self _informDelegateGotURL:postURL];
	}
	
	self.backgroundThread = nil;
	[pool drain];
}

- (NSURL *)postDictionray:(NSDictionary *)params error:(NSError **)error {
	NSString * encoded = [params encodeForURLPost];
	NSData * postData = [encoded dataUsingEncoding:NSUTF8StringEncoding];
	NSString * pastes = kPastebinPostPage;
	NSURL * pastesURL = [NSURL URLWithString:pastes];
	NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:pastesURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:postData];
	[request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
	[request setValue:@"http://pastebay.com" forHTTPHeaderField:@"Referer"];
	// fetch the request
	NSString * redirect = [HTTPNoRedirect getLocationRedirectForRequest:request];
	[request release];
	if (!redirect) {
		if (error) *error = [NSError errorWithCode:kPastebinTextPosterPostError message:@"Failed to post paste" domain:@"PostTextError"];
		return nil;
	}
	if (error) *error = nil;
	return [NSURL URLWithString:redirect];
}

- (void)_informDelegateError:(NSError *)error {
	if (![[NSThread currentThread] isMainThread]) {
		[self performSelectorOnMainThread:@selector(_informDelegateError:) withObject:error waitUntilDone:NO];
		return;
	}
	if ([delegate respondsToSelector:@selector(onlineTextPoster:failedWithError:)]) {
		[delegate onlineTextPoster:self failedWithError:error];
	}
}
- (void)_informDelegateGotURL:(NSURL *)theURL {
	if (![[NSThread currentThread] isMainThread]) {
		[self performSelectorOnMainThread:@selector(_informDelegateGotURL:) withObject:theURL waitUntilDone:NO];
		return;
	}
	if ([delegate respondsToSelector:@selector(onlineTextPoster:postedToURL:)]) {
		[delegate onlineTextPoster:self postedToURL:theURL];
	}
}

- (void)dealloc {
	self.backgroundThread = nil;
	[text release];
	[language release];
    [super dealloc];
}

@end
