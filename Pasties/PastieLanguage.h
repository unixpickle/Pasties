//
//  PastieLanguage.h
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	PastieLanguageObjectiveC = 1,
	PastieLanguageActionScript = 2,
	PastieLanguageRuby = 3,
	PastieLanguageRubyOnRails = 4,
	PastieLanguageDiff = 5,
	PastieLanguagePlainText = 6,
	PastieLanguageCCPP = 7,
	PastieLanguageCSS = 8,
	PastieLanguageJava = 9,
	PastieLanguageJavascript = 10,
	PastieLanguageHTMLXML = 11,
	PastieLanguageHTMLERBorRails = 12,
	PastieLanguageBash = 13,
	PastieLanguageSQL = 14,
	PastieLanguagePHP = 15,
	PastieLanguagePython = 16,
	PastieLanguagePascal = 17,
	PastieLanguagePerl = 18,
	PastieLanguageYAML = 19,
	PastieLanguageCSharp = 20,
	PastieLanguageGo = 21
} PastieLanguageType;

@interface PastieLanguage : NSObject <NSCopying> {
    PastieLanguageType languageType;
}

@property (readonly) PastieLanguageType languageType;

- (id)initWithLanguageType:(PastieLanguageType)language;
- (id)initWithLanguageName:(NSString *)languageString;

+ (id)languageWithName:(NSString *)name;
+ (id)languageWithType:(PastieLanguageType)type;

- (NSString *)getHumanReadableLanguage;
+ (NSArray *)possibleLanguages;

@end
