//
//  OnlineTextPoster.m
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OnlineTextPoster.h"


@implementation OnlineTextPoster

@synthesize delegate;
@synthesize isPrivate;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

/**
 * Creates a new text poster with text and a language.
 * @param theText The text to post to the text poster.
 * @param language An object that carries information to the text poster
 * was to which programming/text language the posted text is written in.
 */
- (id)initWithText:(NSString *)theText language:(id)language {
	if ((self = [super init])) {
		
	}
	return self;
}

/**
 * Begins an asynchronous post to the text poster site.
 * @return YES if the background post was initiated successfully.  NO on
 * any sort of failure or if a background thread is already running.
 */
- (BOOL)postInBackground {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"This is an abstract class and must be subclassed." userInfo:nil];
}

- (void)dealloc {
	self.delegate = nil;
    [super dealloc];
}

@end
