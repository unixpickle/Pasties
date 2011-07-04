//
//  PastieTextPoster.m
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PastieTextPoster.h"

static NSString * _privateDataToString (NSData * data) {
	NSString * utf8 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if (utf8) return utf8;
	NSString * unicode = [[NSString alloc] initWithData:data encoding:NSUnicodeStringEncoding];
	if (unicode) return unicode;
	NSString * utf16 = [[NSString alloc] initWithData:data encoding:NSUTF16StringEncoding];
	if (utf16) return utf16;
	NSString * windowscp1252 = [[NSString alloc] initWithData:data encoding:NSWindowsCP1252StringEncoding];
	if (windowscp1252) return windowscp1252;
	return nil;
}

@interface PastieTextPoster (Private)

- (void)backgroundThread:(NSArray *)textLangPair;
- (void)_informDelegateError:(NSError *)e;

/**
 * Gets a pastie authorization string, or returns nil on failure.
 */
- (NSString *)fetchPastieAuthString;
/**
 * Sends a post request to pastie.org/pastes/.  Returns nil
 * and sets *e on failure.
 */
- (NSString *)sendPostRequest:(NSString *)encoded error:(NSError **)e;

- (void)_informDelegateGotURL:(NSURL *)pasted;

@end

@implementation PastieTextPoster

@synthesize backgroundThread;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithText:(NSString *)theText language:(id)theLanguage {
	NSAssert([theLanguage isKindOfClass:[PastieLanguage class]], @"Invalid class for PastieTextPoster's language.");
	if ((self = [super initWithText:theText language:language])) {
		text = [theText retain];
		language = [theLanguage retain];
	}
	return self;
}

- (BOOL)postInBackground {
	if (self.backgroundThread) return NO;
	NSArray * pair = [NSArray arrayWithObjects:[[text copy] autorelease], [[language copy] autorelease], nil];
	backgroundThread = [[NSThread alloc] initWithTarget:self selector:@selector(backgroundThread:) object:pair];
	[backgroundThread start];
	return YES;
}

#pragma mark Private

- (void)backgroundThread:(NSArray *)textLangPair {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString * pasteString = [textLangPair objectAtIndex:0];
	PastieLanguage * theLanguage = [textLangPair objectAtIndex:1];
	
	// first, we need to fetch the pastie.org authorization key.
	NSString * authorization = [self fetchPastieAuthString];
	if (!authorization) {
		[self _informDelegateError:[NSError errorWithCode:kPastieTextPosterNoAuthorizationKeyError message:@"Failed to read authorization key from "kPastieHome@"." domain:@"PostTextError"]];
		self.backgroundThread = nil;
		[pool drain];
		return;
	}
	
	// next, we will generate the post fields for pastie.org
	NSDictionary * postKeys = [NSDictionary dictionaryWithObjectsAndKeys:pasteString, @"paste[body]", 
							   [NSString stringWithFormat:@"%d", [theLanguage languageType]], @"paste[parser_id]", 
							   @"", @"lang",
							   authorization, @"paste[authorization]",
							   @"", @"key",
							   @"0", @"paste[restricted]", 
							   @"31", @"x",
							   @"8", @"y", nil];
	NSString * encoded = [postKeys encodeForURLPost];
	if (!encoded) {
		[self _informDelegateError:[NSError errorWithCode:kPastieTextPosterEncodeFailed message:@"Failed to encode the post data." domain:@"PostTextError"]];
		self.backgroundThread = nil;
		[pool drain];
		return;
	}
	
	// Finally we send a POST to the pastie website.
	// This request should return a Location HTTP field
	// for our pasted text.
	NSError * postError = nil;
	NSString * urlString = [self sendPostRequest:encoded error:&postError];
	if (!urlString) {
		[self _informDelegateError:postError];
		self.backgroundThread = nil;
		[pool drain];
		return;
	}
	[self _informDelegateGotURL:[NSURL URLWithString:urlString]];
	self.backgroundThread = nil;
	[pool drain];
}

- (void)_informDelegateError:(NSError *)e {
	if (![[NSThread currentThread] isMainThread]) {
		[self performSelectorOnMainThread:@selector(_informDelegateError:) withObject:e waitUntilDone:NO];
		return;
	}
	if ([self.delegate respondsToSelector:@selector(onlineTextPoster:failedWithError:)]) {
		[delegate onlineTextPoster:self failedWithError:e];
	}
}

- (NSString *)fetchPastieAuthString {
	// first, download the pastie homepage.
	NSURL * homepageURL = [NSURL URLWithString:kPastieHome];
	NSURLRequest * request = [NSURLRequest requestWithURL:homepageURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
	NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	if (!response) {
		return nil;
	} else {
		// convert to string.
		NSString * string = _privateDataToString(response);
		if (!string) return nil;
		// find the authorization.
		NSRange r = [string rangeOfString:@"$('paste_authorization').value='"];
		if (r.location == NSNotFound) return nil;
		NSRange contentR = NSMakeRange(r.location + r.length, 0);
		for (NSUInteger i = contentR.location; i < [string length]; i++) {
			if ([string characterAtIndex:i] == '\'') break;
			contentR.length += 1;
		}
		NSString * idString = [string substringWithRange:contentR];
		return idString;
	}
}

- (NSString *)sendPostRequest:(NSString *)encoded error:(NSError **)e {
	NSData * postData = [encoded dataUsingEncoding:NSUTF8StringEncoding];
	NSString * pastes = [NSString stringWithFormat:@"%@/pastes/", kPastieHome];
	NSURL * pastesURL = [NSURL URLWithString:pastes];
	NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:pastesURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:postData];
	[request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
	[request setValue:@"http://pastie.org" forHTTPHeaderField:@"Referer"];
	// fetch the request
	NSString * redirect = [HTTPNoRedirect getLocationRedirectForRequest:request];
	[request release];
	if (!redirect) {
		if (e) *e = [NSError errorWithCode:kPastieTextPosterPostFailed message:@"Failed to post data (no redirect given)." domain:@"PostTextError"];
		return nil;
	}
	if (e) *e = nil;
	return redirect;
}

- (void)_informDelegateGotURL:(NSURL *)pasted {
	if (![[NSThread currentThread] isMainThread]) {
		[self performSelectorOnMainThread:@selector(_informDelegateGotURL:) withObject:pasted waitUntilDone:NO];
		return;
	}
	if ([self.delegate respondsToSelector:@selector(onlineTextPoster:postedToURL:)]) {
		[delegate onlineTextPoster:self postedToURL:pasted];
	}
}

#pragma mark Dealloc

- (void)dealloc {
    [super dealloc];
}

@end
