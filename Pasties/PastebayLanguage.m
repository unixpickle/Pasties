//
//  PastebayLanguage.m
//  Pasties
//
//  Created by Alex Nichol on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PastebayLanguage.h"

static struct {
	NSString * name;
	NSString * abbrev;
} _PastebayLanguagesList[] = {
	{@"ActionScript", @"actionscript"},
	{@"Ada", @"ada"},
	{@"AppleScript", @"applescript"},
	{@"ASM (NASM based)", @"asm"},
	{@"Bash", @"bash"},
	{@"C", @"c"},
	{@"C#", @"csharp"},
	{@"C++", @"cpp"},
	{@"CSS", @"css"},
	{@"HTML", @"html4strict"},
	{@"Java", @"java"},
	{@"Javascript", @"javascript"},
	{@"Lua", @"lua"},
	{@"MatLab", @"matlab"},
	{@"MySQL", @"mysql"},
	{@"Objective-C", @"objc"},
	{@"Perl", @"perl"},
	{@"PHP", @"php"},
	{@"Plain Text", @"text"},
	{@"Python", @"python"},
	{@"Ruby", @"ruby"},
	{@"VB.NET", @"vbnet"},
	{@"Visual Basic", @"vb"},
<<<<<<< HEAD
	{@"XML", @"xml"}
=======
	{@"XML", @"xml"} /* 24 */
>>>>>>> 1ccb1c1c7a96dbbd912344e622bcde27e6f00406
};

#define _PastebayLanguagesList_Count 24

@implementation PastebayLanguage

+ (NSArray *)possibleLanguages {
	NSMutableArray * array = [[NSMutableArray alloc] init];
	for (int i = 0; i < _PastebayLanguagesList_Count; i++) {
		[array addObject:_PastebayLanguagesList[i].name];
	}
	NSArray * immutable = [NSArray arrayWithArray:array];
	[array release];
	return immutable;
}

+ (PastebayLanguage *)languageWithName:(NSString *)langName {
	return [[[PastebayLanguage alloc] initWithName:langName] autorelease];
}

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithAbbreviation:(NSString *)abbrev {
	if ((self = [super init])) {
		markupAbbrev = [abbrev retain];
	}
	return self;
}

- (id)initWithName:(NSString *)languageName {
	if ((self = [super init])) {
		for (int i = 0; i < _PastebayLanguagesList_Count; i++) {
			if ([_PastebayLanguagesList[i].name isEqualToString:languageName]) {
				markupAbbrev = [_PastebayLanguagesList[i].abbrev retain];
			}
		}
		if (!markupAbbrev) {
			[super dealloc];
			return nil;
		}
	}
	return self;
}

- (NSString *)languageName {
	for (int i = 0; i < _PastebayLanguagesList_Count; i++) {
		if ([_PastebayLanguagesList[i].abbrev isEqualToString:markupAbbrev]) {
			return _PastebayLanguagesList[i].name;
		}
	}
	return nil;
}

- (NSString *)languageAbbreviation {
	return markupAbbrev;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[PastebayLanguage allocWithZone:zone] initWithAbbreviation:[self languageAbbreviation]];
}

- (void)dealloc {
	[markupAbbrev release];
    [super dealloc];
}

@end

