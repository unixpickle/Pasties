//
//  NSDictionary+URLEncode.m
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+URLEncode.h"

static NSString * _privateEncodeStringForURL (NSString * orig) {
	NSMutableString * str = [NSMutableString stringWithString:[orig stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[str replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
	[str replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
	[str replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
	[str replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [str length])];
	return str; // it is casted as an NSString.
}

@implementation NSDictionary (URLEncode)

- (NSString *)encodeForURLPost {
	NSMutableString * paramEncoded = [[NSMutableString alloc] init];
	// we need to escape the strings in a <i>fancy</i> manner.
	for (id key in self) {
		if (![key isKindOfClass:[NSString class]]) {
			[paramEncoded release];
			@throw [NSException exceptionWithName:ANNotEncodableException reason:@"Invalid key class." userInfo:nil];
		}
		id objVal = [self objectForKey:key];
		if (![objVal isKindOfClass:[NSString class]]) {
			[paramEncoded release];
			@throw [NSException exceptionWithName:ANNotEncodableException reason:@"Invalid value class." userInfo:nil];
		}
		NSString * keyString = key;
		NSString * valString = objVal;
		if ([paramEncoded length] == 0) {
			[paramEncoded appendFormat:@"%@=%@", keyString, _privateEncodeStringForURL(valString)];
		} else {
			[paramEncoded appendFormat:@"&%@=%@", keyString, _privateEncodeStringForURL(valString)];
		}
	}
	NSString * immutable = [NSString stringWithString:paramEncoded];
	[paramEncoded release];
	return immutable;
}

@end
