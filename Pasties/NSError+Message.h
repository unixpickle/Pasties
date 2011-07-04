//
//  NSError+Message.h
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSError (Message)

+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message domain:(NSString *)domain;

@end
