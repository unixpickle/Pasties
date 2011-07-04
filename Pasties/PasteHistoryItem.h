//
//  PasteHistoryItem.h
//  Pasties
//
//  Created by Alex Nichol on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PasteHistoryItem : NSObject <NSCoding> {
    NSURL * theURL;
	NSDate * addDate;
}

@property (readonly) NSURL * theURL;
@property (readonly) NSDate * addDate;

- (id)initWithURL:(NSURL *)aURL addDate:(NSDate *)theDate;
+ (id)historyItemWithURL:(NSURL *)u addDate:(NSDate *)theDate;

@end
