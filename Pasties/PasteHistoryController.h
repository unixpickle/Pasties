//
//  PasteHistoryController.h
//  Pasties
//
//  Created by Alex Nichol on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PasteHistoryItem.h"

#define PasteHistoryControllerItemAddedNotification @"PasteHistoryControllerItemAddedNotification"
#define PasteHistoryControllerItemRemovedNotification @"PasteHistoryControllerItemRemovedNotification"

@interface PasteHistoryController : NSObject <NSFastEnumeration> {
    NSString * historyFilePath;
	NSMutableArray * historyItems;
	// not really a checksum.  this value will (hopefully) be different
	// every time a mutation is made to the history list.
	long checksum;
}

+ (PasteHistoryController *)sharedHistoryController;
- (NSInteger)numberOfHistoryItems;
- (PasteHistoryItem *)historyItemAtIndex:(NSInteger)index;
- (void)addHistoryItem:(PasteHistoryItem *)item;
- (void)removeHistoryItemAtIndex:(int)index;
- (void)removeHistoryItemsAtIndexes:(NSIndexSet *)indexes;

@end
