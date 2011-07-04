//
//  PastebayTextPoster.m
//  Pasties
//
//  Created by Alex Nichol on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PastebayTextPoster.h"

@interface PastebayTextPoster (Private)

- (void)backgroundThread:(NSDictionary *)userInfo;
- (NSURL *)postDictionray:(NSDictionary *)params error:(NSError **)error;
- (void)_informDelegateError:(NSError *)e;
- (void)_informDelegatePosted:(NSURL *)newURL;

@end

@implementation PastebayTextPoster

@synthesize backgroundThread;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithText:(NSString *)theText language:(PastebayLanguage *)theLanguage {
	NSAssert([theLanguage isKindOfClass:[PastebayLanguage class]], @"Pastebay text poster uses PastebayLanguage objects.");
	if ((self = [super init])) {
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
	PastebayLanguage * theLanguage = [userInfo objectForKey:@"language"];
	
	NSDictionary * postKeys = [NSDictionary dictionaryWithObjectsAndKeys:theText, @"code2", 
							   @"m", @"expiry",
							   [theLanguage languageAbbreviation], @"format",
							   @"", @"pam",
							   @"", @"parent_pid", 
							   @"Send", @"paste",
							   @"", @"poster", 
							   @"", @"protected", nil];
	NSError * e = nil;
	NSURL * url = [self postDictionray:postKeys error:&e];
	if (!url) {
		[self _informDelegateError:e];
		self.backgroundThread = nil;
		[pool drain];
		return;
	}
	[self _informDelegatePosted:url];
	
	self.backgroundThread = nil;
	[pool drain];
}

- (NSURL *)postDictionray:(NSDictionary *)params error:(NSError **)error {
	NSString * encoded = [params encodeForURLPost];
	NSData * postData = [encoded dataUsingEncoding:NSUTF8StringEncoding];
	NSString * pastes = kPastebayPostPage;
	NSURL * pastesURL = [NSURL URLWithString:pastes];
	NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:pastesURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:postData];
	[request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
	[request setValue:@"http://pastebay.com" forHTTPHeaderField:@"Referer"];
	// fetch the request
	NSString * redirect = [HTTPNoRedirect getLocationRedirectForRequest:request];
	if (!redirect) {
		if (error) *error = [NSError errorWithCode:1 message:@"Failed to post paste" domain:@"PostTextError"];
		return nil;
	}
	if (error) *error = nil;
	return [NSURL URLWithString:redirect];
}

#pragma mark Delegate Information

- (void)_informDelegateError:(NSError *)e {
	if (![[NSThread currentThread] isMainThread]) {
		[self performSelectorOnMainThread:@selector(_informDelegateError:) withObject:e waitUntilDone:NO];
		return;
	}
	if ([delegate respondsToSelector:@selector(onlineTextPoster:failedWithError:)]) {
		[delegate onlineTextPoster:self failedWithError:e];
	}
}
- (void)_informDelegatePosted:(NSURL *)newURL {
	if (![[NSThread currentThread] isMainThread]) {
		[self performSelectorOnMainThread:@selector(_informDelegatePosted:) withObject:newURL waitUntilDone:NO];
		return;
	}
	if ([delegate respondsToSelector:@selector(onlineTextPoster:postedToURL:)]) {
		[delegate onlineTextPoster:self postedToURL:newURL];
	}
}

- (void)dealloc {
	self.backgroundThread = nil;
	[text release];
	[language release];
    [super dealloc];
}

@end
