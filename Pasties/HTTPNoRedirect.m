//
//  HTTPNoRedirect.m
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HTTPNoRedirect.h"


@implementation HTTPNoRedirect

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSString *)redirectedLocationForSendingRequest:(NSURLRequest *)request {
	[redirectedURL release];
	redirectedURL = nil;
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connection start];
	while (!isDone) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
	}
	[connection cancel];
	[connection release];
	return redirectedURL;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    if (redirectResponse) {
		[redirectedURL release];
		redirectedURL = [[[request URL] description] retain];
        [connection cancel];
		isDone = YES;
		return nil;
    } else {
        return request;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	isDone = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	isDone = YES;
}

+ (NSString *)getLocationRedirectForRequest:(NSURLRequest *)request {
	HTTPNoRedirect * redirect = [[HTTPNoRedirect alloc] init];
	return [[redirect autorelease] redirectedLocationForSendingRequest:request];
}

- (void)dealloc {
	[redirectedURL release];
    [super dealloc];
}

@end
