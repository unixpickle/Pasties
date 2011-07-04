//
//  PasteHistoryController.m
//  Pasties
//
//  Created by Alex Nichol on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PasteHistoryController.h"

@interface PasteHistoryController (Private)

- (void)flushToFile;

@end

@implementation PasteHistoryController

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
		checksum = arc4random();
		historyFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Application Support"];
		historyFilePath = [historyFilePath stringByAppendingPathComponent:@"Pasties"];
		if (![[NSFileManager defaultManager] fileExistsAtPath:historyFilePath]) {
			if (![[NSFileManager defaultManager] createDirectoryAtPath:historyFilePath withIntermediateDirectories:NO attributes:nil error:nil]) {
				[self autorelease];
				@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"App support path could not be created." userInfo:nil];
			} else {
				NSLog(@"Manually created application support directory: %@", historyFilePath);
			}
		}
		historyFilePath = [[historyFilePath stringByAppendingPathComponent:@"history"] retain];
		if (![[NSFileManager defaultManager] fileExistsAtPath:historyFilePath]) {
			historyItems = [[NSMutableArray alloc] init];
			if (![NSKeyedArchiver archiveRootObject:historyItems toFile:historyFilePath]) {
				[self autorelease];
				[historyItems release];
				[historyFilePath release];
				@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Failed to create history file." userInfo:nil];
			}
		} else {
			NSArray * immutable = [NSKeyedUnarchiver unarchiveObjectWithFile:historyFilePath];
			if (!immutable) {
				[self autorelease];
				[historyFilePath release];
				@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Failed to load history file" userInfo:nil];
			} else {
				historyItems = [[NSMutableArray alloc] initWithArray:immutable];
			}
		}
	}
	return self;
}

+ (PasteHistoryController *)sharedHistoryController {
	static PasteHistoryController * c = nil;
	if (!c) c = [[PasteHistoryController alloc] init];
	return [[c retain] autorelease];
}

- (NSInteger)numberOfHistoryItems {
	@synchronized (self) {
		return [historyItems count];
	}
}

- (PasteHistoryItem *)historyItemAtIndex:(NSInteger)index {
	@synchronized (self) {
		return [historyItems objectAtIndex:index];
	}
}

- (void)addHistoryItem:(PasteHistoryItem *)item {
	@synchronized (self) {
		// TODO: send notification
		checksum ^= arc4random();
		[historyItems insertObject:item atIndex:0];
		[[NSNotificationCenter defaultCenter] postNotificationName:PasteHistoryControllerItemAddedNotification object:self userInfo:[NSDictionary dictionaryWithObject:item forKey:@"item"]];
		[self flushToFile];
	}
}

- (void)removeHistoryItemAtIndex:(int)index {
	@synchronized (self) {
		// TODO: send notification
		checksum ^= arc4random();
		[historyItems removeObjectAtIndex:index];
		[[NSNotificationCenter defaultCenter] postNotificationName:PasteHistoryControllerItemRemovedNotification object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:index] forKey:@"item"]];
		[self flushToFile];
	}
}

- (void)removeHistoryItemsAtIndexes:(NSIndexSet *)indexes {
	@synchronized (self) {
		NSMutableArray * removeList = [[NSMutableArray alloc] init];
		for (int i = 0; i < [historyItems count]; i++) {
			if ([indexes containsIndex:i]) {
				[removeList addObject:[historyItems objectAtIndex:i]];
			}
		}
		for (PasteHistoryItem * item in removeList) {
			int index = (int)[historyItems indexOfObject:item];
			[historyItems removeObjectAtIndex:index];
			[[NSNotificationCenter defaultCenter] postNotificationName:PasteHistoryControllerItemRemovedNotification object:self userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:index] forKey:@"item"]];
		}
		[removeList release];
		[self flushToFile];
	}
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
	@synchronized (self) {
		if (state->state == 0) {
			// zero our mutations pointer.
			state->mutationsPtr = state->extra;
			state->extra[1] = checksum;
		} else if (state->extra[1] != checksum) {
			@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"PastieHistoryController was mutated while being enumerated." userInfo:nil];
		}
		NSUInteger count = 0;
		if (state->state == [historyItems count]) return 0;
		else {
			count = [historyItems count] - state->state;
			if (count > len) {
				count = len;
			}
			for (NSUInteger i = state->state; i < state->state + count; i++) {
				stackbuf[i - state->state] = [[[historyItems objectAtIndex:i] retain] autorelease];
			}
			return count;
		}
	}
}

- (void)flushToFile {
	// NSDate * start = [NSDate date];
	[NSKeyedArchiver archiveRootObject:historyItems toFile:historyFilePath];
	// NSDate * end = [NSDate date];
	// NSLog(@"Encoded history to file in %lf seconds.", [end timeIntervalSinceDate:start]);
}

- (void)dealloc {
	[historyFilePath release];
	[historyItems release];
    [super dealloc];
}

@end
