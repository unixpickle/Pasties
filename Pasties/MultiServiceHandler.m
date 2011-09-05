//
//  MultiServiceHandler.m
//  Pasties
//
//  Created by Alex Nichol on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiServiceHandler.h"


@implementation MultiServiceHandler

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

+ (NSArray *)possibleServices {
	return [NSArray arrayWithObjects:@"Pastie", @"Pastebay", @"Pastebin", nil];
}
+ (NSArray *)possibleLanguagesForService:(NSString *)service {
	if ([service isEqualToString:@"Pastie"]) {
		return [PastieLanguage possibleLanguages];
	} else if ([service isEqualToString:@"Pastebay"]) {
		return [PastebayLanguage possibleLanguages];
	} else if ([service isEqualToString:@"Pastebin"]) {
		return [PastebinLanguage possibleLanguages];
	}
	return nil;
}
+ (OnlineTextPoster *)textPosterWithText:(NSString *)text language:(NSString *)languageName service:(NSString *)serviceName {
	if ([serviceName isEqual:@"Pastie"]) {
		PastieLanguage * lang = [PastieLanguage languageWithName:languageName];
		if (!lang) return nil;
		PastieTextPoster * ptp = [[PastieTextPoster alloc] initWithText:text language:lang];
		return [ptp autorelease];
	} else if ([serviceName isEqual:@"Pastebay"]) {
		PastebayLanguage * lang = [PastebayLanguage languageWithName:languageName];
		if (!lang) return nil;
		PastebayTextPoster * ptp = [[PastebayTextPoster alloc] initWithText:text language:lang];
		return [ptp autorelease];
	} else if ([serviceName isEqual:@"Pastebin"]) {
		PastebinLanguage * lang = [PastebinLanguage languageWithName:languageName];
		if (!lang) return nil;
		PastebinTextPoster * ptp = [[PastebinTextPoster alloc] initWithText:text language:lang];
		return [ptp autorelease];
	}
	return nil;
}
+ (NSString *)convertLanguage:(NSString *)lang toService:(NSString *)service {
	if ([lang isEqualToString:@"Objective-C"] && [service isEqualToString:@"Pastie"]) {
		return @"Objective-C/C++";
	} else if (([lang isEqualToString:@"C"] || [lang isEqualToString:@"C++"]) && [service isEqualToString:@"Pastie"]) {
		return @"C/C++";
	}
	return lang;
}
+ (BOOL)serviceHasPrivatePosts:(NSString *)service {
	return ([service isEqualToString:@"Pastie"] | [service isEqualToString:@"Pastebin"]);
}

- (void)dealloc {
    [super dealloc];
}

@end
