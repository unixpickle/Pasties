//
//  PastieLanguage.m
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PastieLanguage.h"

// Associates our meaningless enum with strings.
static struct {
	NSString * languageStr;
	PastieLanguageType languageType;
} _PastieLanguagePair[] = {
	{@"Objective-C/C++", PastieLanguageObjectiveC},
	{@"Action Script", PastieLanguageActionScript},
	{@"Ruby", PastieLanguageRuby},
	{@"Ruby on Rails", PastieLanguageRubyOnRails},
	{@"Diff", PastieLanguageDiff},
	{@"Plain Text", PastieLanguagePlainText},
	{@"C/C++", PastieLanguageCCPP},
	{@"CSS", PastieLanguageCSS},
	{@"Java", PastieLanguageJava},
	{@"Javascript", PastieLanguageJavascript},
	{@"HTML (XML)", PastieLanguageHTMLXML},
	{@"HTML (ERB or Rails)", PastieLanguageHTMLERBorRails},
	{@"Bash", PastieLanguageBash},
	{@"SQL", PastieLanguageSQL},
	{@"PHP", PastieLanguagePHP},
	{@"Python", PastieLanguagePython},
	{@"Pascal", PastieLanguagePascal},
	{@"Perl", PastieLanguagePerl},
	{@"YAML", PastieLanguageYAML},
	{@"C#", PastieLanguageCSharp},
	{@"Go", PastieLanguageGo}
};
#define _PastieLanguagePair_Count 21


@implementation PastieLanguage

@synthesize languageType;

+ (NSArray *)possibleLanguages {
	NSMutableArray * array = [[NSMutableArray alloc] init];
	for (int i = 0; i < _PastieLanguagePair_Count; i++) {
		[array addObject:_PastieLanguagePair[i].languageStr];
	}
	NSArray * immutable = [NSArray arrayWithArray:array];
	[array release];
	return immutable;
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithLanguageType:(PastieLanguageType)language {
	if ((self = [super init])) {
		languageType = language;
	}
	return self;
}

- (id)initWithLanguageName:(NSString *)languageString {
	if ((self = [super init])) {
		languageType = 0;
		for (int i = 0; i < _PastieLanguagePair_Count; i++) {
			if ([_PastieLanguagePair[i].languageStr isEqualToString:languageString]) {
				languageType = _PastieLanguagePair[i].languageType;
				break;
			}
		}
		if (languageType == 0) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}

+ (id)languageWithName:(NSString *)name {
	return [[[PastieLanguage alloc] initWithLanguageName:name] autorelease];
}

+ (id)languageWithType:(PastieLanguageType)type {
	return [[[PastieLanguage alloc] initWithLanguageType:type] autorelease];
}

- (NSString *)getHumanReadableLanguage {
	for (int i = 0; i < _PastieLanguagePair_Count; i++) {
		if (_PastieLanguagePair[i].languageType == languageType) {
			return [[_PastieLanguagePair[i].languageStr retain] autorelease];
		}
	}
	return nil;
}

#pragma mark Copying

- (id)copyWithZone:(NSZone *)zone {
	return [[PastieLanguage allocWithZone:zone] initWithLanguageType:[self languageType]];
}

- (id)copy {
	return [[PastieLanguage alloc] initWithLanguageType:[self languageType]];
}

- (void)dealloc {
    [super dealloc];
}

@end
