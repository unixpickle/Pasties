//
//  HTTPNoRedirect.h
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTTPNoRedirect : NSObject {
	NSString * redirectedURL;
	BOOL isDone;
}

+ (NSString *)getLocationRedirectForRequest:(NSURLRequest *)request;
- (NSString *)redirectedLocationForSendingRequest:(NSURLRequest *)request;

@end
