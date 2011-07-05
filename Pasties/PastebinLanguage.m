//
//  PastebinLanguage.m
//  Pasties
//
//  Created by Alex Nichol on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PastebinLanguage.h"

static struct {
	NSString * languageName;
	PastebinLanguageType languageType;
} _PastebinLanguageNames[] = {
	{@"ActionScript", PastebinLanguageActionScript},
	{@"ActionScript 3", PastebinLanguageActionScript3},
	{@"AppleScript", PastebinLanguageAppleScript},
	{@"ASM (NASM based)", PastebinLanguageNASM},
	{@"ASP", PastebinLanguageASP},
	{@"Bash", PastebinLanguageBash},
	{@"C", PastebinLanguageC},
	{@"C#", PastebinLanguageCSharp},
	{@"COBOL", PastebinLanguageCOBOL},
	{@"C++", PastebinLanguageCPP},
	{@"CSS", PastebinLanguageCSS},
	{@"D", PastebinLanguageD},
	{@"Diff", PastebinLanguageDiff},
	{@"Go", PastebinLanguageGo},
	{@"HTML", PastebinLanguageHTML},
	{@"HTML5", PastebinLanguageHTML5},
	{@"Java", PastebinLanguageJava},
	{@"Javascript", PastebinLanguageJavascript},
	{@"Lua", PastebinLanguageLua},
	{@"Objective-C", PastebinLanguageObjectiveC},
	{@"Perl", PastebinLanguagePerl},
	{@"PHP", PastebinLanguagePHP},
	{@"Plain Text", PastebinLanguagePlainText},
	{@"Python", PastebinLanguagePython},
	{@"Rails", PastebinLanguageRails}
};

#define _PastebinLanguageNames_Count 25

@implementation PastebinLanguage

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithLanguageType:(PastebinLanguageType)langType {
	if ((self = [super init])) {
		languageType = langType;
	}
	return self;
}

- (id)initWithLanguageName:(NSString *)name {
	if ((self = [super init])) {
		BOOL wasFound = NO;
		for (int i = 0; i < _PastebinLanguageNames_Count; i++) {
			if ([_PastebinLanguageNames[i].languageName isEqual:name]) {
				wasFound = YES;
				languageType = _PastebinLanguageNames[i].languageType;
				break;
			}
		}
		if (!wasFound) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}

- (NSString *)languageName {
	for (int i = 0; i < _PastebinLanguageNames_Count; i++) {
		if (_PastebinLanguageNames[i].languageType == languageType) {
			return [[_PastebinLanguageNames[i].languageName retain] autorelease];
		}
	}
	return nil;
}

- (PastebinLanguageType)languageType {
	return languageType;
}

+ (PastebinLanguage *)languageWithName:(NSString *)languageName {
	return [[[PastebinLanguage alloc] initWithLanguageName:languageName] autorelease];
}

+ (NSArray *)possibleLanguages {
	NSMutableArray * array = [[NSMutableArray alloc] init];
	for (int i = 0; i < _PastebinLanguageNames_Count; i++) {
		[array addObject:_PastebinLanguageNames[i].languageName];
	}
	NSArray * immutable = [NSArray arrayWithArray:array];
	[array release];
	return immutable;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[PastebinLanguage allocWithZone:zone] initWithLanguageType:[self languageType]];
}

- (void)dealloc {
    [super dealloc];
}

@end
