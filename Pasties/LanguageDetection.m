//
//  LanguageDetection.m
//  Pasties
//
//  Created by Alex Nichol on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LanguageDetection.h"

@interface LanguageDetection (Private)

- (int)scoreC;
- (int)scoreCPP;
- (int)scoreObjC;
- (int)scorePHP;
- (int)scorePerl;

@end

@implementation LanguageDetection

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithText:(NSString *)document {
	if ((self = [super init])) {
		documentContents = [document retain];
	}
	return self;
}

- (int)numberOfOccurrences:(NSString *)needle {
	int count = 0;
	for (NSUInteger i = 0; i < [documentContents length];) {
		NSRange docRange = NSMakeRange(i, [documentContents length] - i);
		NSRange nextStr = [documentContents rangeOfString:needle options:0 range:docRange];
		if (nextStr.location == NSNotFound) break;
		i = nextStr.location + nextStr.length;
		count += 1;
	}
	return count;
}

- (int)numberOfOccurrencesCaseInsensitive:(NSString *)needle {
	int count = 0;
	for (NSUInteger i = 0; i < [documentContents length];) {
		NSRange docRange = NSMakeRange(i, [documentContents length] - i);
		NSRange nextStr = [documentContents rangeOfString:needle options:NSCaseInsensitiveSearch range:docRange];
		if (nextStr.location == NSNotFound) break;
		i = nextStr.location + nextStr.length;
		count += 1;
	}
	return count;
}

- (int)scoreC {
	int score = [self numberOfOccurrencesCaseInsensitive:@"char *"];
	score += [self numberOfOccurrencesCaseInsensitive:@"char*"];
	score += [self numberOfOccurrencesCaseInsensitive:@"malloc"] * 4;
	score += [self numberOfOccurrencesCaseInsensitive:@"#include"];
	score += [self numberOfOccurrencesCaseInsensitive:@"printf"];
	score += [self numberOfOccurrencesCaseInsensitive:@"fopen"];
	score += [self numberOfOccurrencesCaseInsensitive:@"memcpy"] * 2;
	score += [self numberOfOccurrencesCaseInsensitive:@"int"];
	score += [self numberOfOccurrencesCaseInsensitive:@"float"];
	score += [self numberOfOccurrencesCaseInsensitive:@"double"];
	return score;
}
- (int)scoreCPP {
	int score = [self scoreC];
	score += [self numberOfOccurrencesCaseInsensitive:@"<string>"];
	score += [self numberOfOccurrencesCaseInsensitive:@"new"];
	score += [self numberOfOccurrencesCaseInsensitive:@"cout <<"] * 15;
	score += [self numberOfOccurrencesCaseInsensitive:@"cout<<"] * 15;
	score += [self numberOfOccurrencesCaseInsensitive:@"cin>>"] * 15;
	score += [self numberOfOccurrencesCaseInsensitive:@"cin >>"] * 15;
	score += [self numberOfOccurrencesCaseInsensitive:@"delete"];
	score += [self numberOfOccurrencesCaseInsensitive:@"using namespace"] * 10;
	return score;
}
- (int)scoreObjC {
	int score = [self scoreC];
	score += [self numberOfOccurrences:@"NSObject"] * 5;
	score += [self numberOfOccurrences:@"NSString"];
	score += [self numberOfOccurrences:@"NSArray"];
	score += [self numberOfOccurrences:@"NSLog"] * 20;
	score += [self numberOfOccurrences:@"NSMutable"];
	score += [self numberOfOccurrencesCaseInsensitive:@"@interface"];
	score += [self numberOfOccurrences:@"alloc]"];
	score += [self numberOfOccurrences:@"release]"];
	score += [self numberOfOccurrences:@"autorelease]"];
	score += [self numberOfOccurrences:@"NSApp"];
	score += [self numberOfOccurrences:@"@protocol"] * 10;
	score += [self numberOfOccurrences:@"@selector"] * 2;
	score += [self numberOfOccurrences:@"@implementation"] * 10;
	score += [self numberOfOccurrences:@"UInt32"];
	score += (int)round((double)[self numberOfOccurrences:@"NS"] / 2.0);
	return score;
}
- (int)scorePHP {
	int score = [self numberOfOccurrences:@"echo"];
	score += [self numberOfOccurrences:@"$"];
	score += [self numberOfOccurrences:@"mysql_query"] * 2;
	score += [self numberOfOccurrencesCaseInsensitive:@"<?php"]*10; // worth a whole lot
	score += [self numberOfOccurrencesCaseInsensitive:@"?>"] * 10;
	score += [self numberOfOccurrences:@"print_r"];
	score += [self numberOfOccurrences:@"die"];
	return score;
}
- (int)scorePerl {
	int score = [self numberOfOccurrences:@"print"];
	score += [self numberOfOccurrences:@"$"] * 3;
	score += [self numberOfOccurrences:@"$_"] * 4;
	score += [self numberOfOccurrencesCaseInsensitive:@"#!/usr/bin/perl"] * 20;
	score += [self numberOfOccurrences:@"open"];
	score += [self numberOfOccurrences:@"die"];
	score += [self numberOfOccurrences:@"chomp"] * 2;
	score += [self numberOfOccurrences:@"chop"] * 2;
	score += [self numberOfOccurrences:@"<STDIN>"] * 3;
	score += [self numberOfOccurrences:@"STDOUT"] * 2;
	score += [self numberOfOccurrences:@"eq"];
	return score;
}

- (NSString *)languageGuess {
	int scoreC = [self scoreC];
	int scoreCPP = [self scoreCPP];
	int scoreObjC = [self scoreObjC];
	int scorePerl = [self scorePerl];
	int scorePHP = [self scorePHP];
	// find the greatest score
	NSString * greatestName = @"C";
	int greatestScore = scoreC;
	if (scoreCPP > scoreC) { greatestName = @"C++"; greatestScore = scoreCPP; }
	if (scoreObjC > scoreCPP) { greatestName = @"Objective-C"; greatestScore = scoreObjC; }
	if (scorePerl > scoreObjC) { greatestName = @"Perl"; greatestScore = scorePerl; }
	if (scorePHP > scorePerl) { greatestName = @"PHP"; greatestScore = scorePHP; }
	if (greatestScore < 5) return nil;
	return greatestName;
}

- (void)dealloc {
	[documentContents release];
    [super dealloc];
}

@end
