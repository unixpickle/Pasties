//
//  PastebayLanguage.h
//  Pasties
//
//  Created by Alex Nichol on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PastebayLanguage : NSObject <NSCopying> {
    NSString * markupAbbrev;
}

- (id)initWithAbbreviation:(NSString *)abbrev;
- (id)initWithName:(NSString *)languageName;
- (NSString *)languageName;
- (NSString *)languageAbbreviation;
+ (NSArray *)possibleLanguages;
+ (PastebayLanguage *)languageWithName:(NSString *)langName;

@end
