//
//  LanguageDetection.h
//  Pasties
//
//  Created by Alex Nichol on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LanguageDetection : NSObject {
    NSString * documentContents;
}

/**
 * Creates a new language detector with some code.
 */
- (id)initWithText:(NSString *)document;

/**
 * Returns the number of times that a particular string appears
 * in the contents of the document.
 */
- (int)numberOfOccurrences:(NSString *)needle;

/**
 * Returns the number of times that a particular string appears
 * in the contents of the document.  This string is not case
 * sensitive.
 */
- (int)numberOfOccurrencesCaseInsensitive:(NSString *)needle;

/**
 * Guesses the programming language of the document text.
 * @return A language name, or nil of no language could be detected.
 */
- (NSString *)languageGuess;

@end
