//
//  NSDictionary+URLEncode.h
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ANNotEncodableException @"ANNotEncodableException"

@interface NSDictionary (URLEncode)

/**
 * Encodes a dictionary with (string) objects and keys into
 * a URL-safe string.  For example, a dictionary with an object
 * @"test" for the key @"type" would encode as @"type=test".
 * @throws ANNotEncodableException Thrown when an object or key is not in
 * the right format to be encoded.
 */
- (NSString *)encodeForURLPost;

@end
