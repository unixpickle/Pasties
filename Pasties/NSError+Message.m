//
//  NSError+Message.m
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSError+Message.h"


@implementation NSError (Message)

+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message domain:(NSString *)domain {
	NSDictionary * userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
	return [[[NSError alloc] initWithDomain:domain code:code userInfo:userInfo] autorelease];
}

@end
