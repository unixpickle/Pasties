//
//  PasteHistoryItem.m
//  Pasties
//
//  Created by Alex Nichol on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PasteHistoryItem.h"


@implementation PasteHistoryItem

@synthesize theURL;
@synthesize addDate;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithURL:(NSURL *)aURL addDate:(NSDate *)theDate {
	if ((self = [super init])) {
		theURL = [aURL retain];
		addDate = [theDate retain];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		theURL = [[aDecoder decodeObjectForKey:@"url"] retain];
		addDate = [[aDecoder decodeObjectForKey:@"date"] retain];
	}
	return self;
}

+ (id)historyItemWithURL:(NSURL *)u addDate:(NSDate *)theDate {
	return [[[PasteHistoryItem alloc] initWithURL:u addDate:theDate] autorelease];
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:theURL forKey:@"url"];
	[coder encodeObject:addDate forKey:@"date"];
}

- (void)dealloc {
	[theURL release];
	[addDate release];
    [super dealloc];
}

@end
