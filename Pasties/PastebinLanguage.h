//
//  PastebinLanguage.h
//  Pasties
//
//  Created by Alex Nichol on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	PastebinLanguagePlainText = 1,
	PastebinLanguageActionScript = 2,
	PastebinLanguageActionScript3 = 74,
	PastebinLanguageAppleScript = 5,
	PastebinLanguageASP = 7,
	PastebinLanguageBash = 8,
	PastebinLanguageC = 9,
	PastebinLanguageCSharp = 14,
	PastebinLanguageCPP = 13,
	PastebinLanguageCOBOL = 84,
	PastebinLanguageCSS = 16,
	PastebinLanguageD = 17,
	PastebinLanguageDiff = 19,
	PastebinLanguageGo = 162,
	PastebinLanguageHTML = 25,
	PastebinLanguageHTML5 =	196,
	PastebinLanguageJava = 27,
	PastebinLanguageJavascript = 28,
	PastebinLanguageLua = 30,
	PastebinLanguageNASM = 6,
	PastebinLanguageObjectiveC = 35,
	PastebinLanguagePerl = 40,
	PastebinLanguagePHP = 41,
	PastebinLanguagePython = 42,
	PastebinLanguageRails = 67
} PastebinLanguageType;

@interface PastebinLanguage : NSObject <NSCopying> {
    PastebinLanguageType languageType;
}

- (id)initWithLanguageType:(PastebinLanguageType)langType;
- (id)initWithLanguageName:(NSString *)name;
- (NSString *)languageName;
- (PastebinLanguageType)languageType;
+ (PastebinLanguage *)languageWithName:(NSString *)languageName;
+ (NSArray *)possibleLanguages;

@end
