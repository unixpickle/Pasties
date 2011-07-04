//
//  HistoryWindow.m
//  Pasties
//
//  Created by Alex Nichol on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HistoryWindow.h"

@interface HistoryWindow (Private)

- (void)itemInserted:(NSNotification *)aNotification;
- (void)itemRemoved:(NSNotification *)aNotification;
+ (id *)sharedHistoryWindowPtr;
+ (void)sharedHistoryWindowClosed;

@end

@implementation HistoryWindow

+ (id *)sharedHistoryWindowPtr {
	static id obj = nil;
	return &obj;
}

+ (void)showHistoryWindow {
	HistoryWindow ** windPtr = [self sharedHistoryWindowPtr];
	if (!*windPtr) {
		NSRect screenFrame = [[NSScreen mainScreen] visibleFrame];
		NSRect centerFrame = NSMakeRect(screenFrame.size.width / 2.0 - 250, screenFrame.size.height / 2.0 - 250, 500, 400);
		HistoryWindow * hw = [[HistoryWindow alloc] initWithContentRect:centerFrame styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask) backing:NSBackingStoreBuffered defer:NO];
		*windPtr = hw;
		[hw makeKeyAndOrderFront:nil];
	} else {
		[*windPtr makeKeyAndOrderFront:nil];
	}
	[[FocusManager sharedFocusManager] forceAppFocus];
}

+ (void)sharedHistoryWindowClosed {
	if (*[self sharedHistoryWindowPtr]) {
		[*[self sharedHistoryWindowPtr] autorelease];
		*[self sharedHistoryWindowPtr] = nil;
	}
}

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])) {
		[self setContentView:[[[NSView alloc] initWithFrame:contentRect] autorelease]];
		NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 44, contentRect.size.width - 20, contentRect.size.height - 54)];
		tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, contentRect.size.width - 36, contentRect.size.height - 54)];
		removeSelectedButton = [[NSButton alloc] initWithFrame:NSMakeRect(5, 10, 140, 24)];
		closeButton = [[NSButton alloc] initWithFrame:NSMakeRect(contentRect.size.width - 95, 10, 90, 24)];
		[closeButton setBezelStyle:NSRoundedBezelStyle];
		[closeButton setTarget:self];
		[closeButton setAction:@selector(orderOut:)];
		[closeButton setTitle:@"Close"];
		[closeButton setFont:[NSFont systemFontOfSize:13]];
		
		[removeSelectedButton setBezelStyle:NSRoundedBezelStyle];
		[removeSelectedButton setTarget:self];
		[removeSelectedButton setAction:@selector(removeSelected:)];
		[removeSelectedButton setTitle:@"Remove Selected"];
		[removeSelectedButton setFont:[NSFont systemFontOfSize:13]];
		
		NSTableColumn * ucolumn = [[NSTableColumn alloc] initWithIdentifier:@"URL"];
		NSTableColumn * dcolumn = [[NSTableColumn alloc] initWithIdentifier:@"Date"];
		[ucolumn setWidth:252];
		[dcolumn setWidth:198];
		[[ucolumn headerCell] setTitle:@"URL"];
		[[dcolumn headerCell] setTitle:@"Date"];
		[tableView addTableColumn:ucolumn];
		[tableView addTableColumn:dcolumn];
		[ucolumn setEditable:NO];
		[dcolumn setEditable:NO];
		[tableView setAllowsMultipleSelection:YES];
		[tableView setDelegate:self];
		[tableView setDataSource:self];
		[tableView reloadData];
		[tableView setDoubleAction:@selector(itemDoubleClicked:)];
		[tableContainer setDocumentView:tableView];
		[tableContainer setHasVerticalScroller:YES];
		[[self contentView] addSubview:tableContainer];
		[[self contentView] addSubview:removeSelectedButton];
		[ucolumn release];
		[dcolumn release];
		[tableContainer release];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemInserted:) name:PasteHistoryControllerItemAddedNotification object:[PasteHistoryController sharedHistoryController]];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemRemoved:) name:PasteHistoryControllerItemRemovedNotification object:[PasteHistoryController sharedHistoryController]];
		[self setReleasedWhenClosed:NO];
		[self setLevel:CGShieldingWindowLevel()];
	}
	return self;
}

- (void)itemDoubleClicked:(id)sender {
	NSIndexSet * selectedIndexes = [tableView selectedRowIndexes];
	for (int i = 0; i < [[PasteHistoryController sharedHistoryController] numberOfHistoryItems]; i++) {
		if ([selectedIndexes containsIndex:i]) {
			[[NSWorkspace sharedWorkspace] openURL:[[[PasteHistoryController sharedHistoryController] historyItemAtIndex:i] theURL]];
		}
	}
}

- (void)removeSelected:(id)sender {
	NSIndexSet * selectedIndexes = [tableView selectedRowIndexes];
	[[PasteHistoryController sharedHistoryController] removeHistoryItemsAtIndexes:selectedIndexes];
}

- (void)itemInserted:(NSNotification *)aNotification {
	[tableView reloadData];
}

- (void)itemRemoved:(NSNotification *)aNotification {
	[tableView reloadData];
}

- (void)orderOut:(id)sender {
	[super orderOut:sender];
	[[FocusManager sharedFocusManager] resignAppFocus];
	[[self class] sharedHistoryWindowClosed];
}

#pragma mark Table View Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [[PasteHistoryController sharedHistoryController] numberOfHistoryItems];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	if ([[tableColumn identifier] isEqual:@"URL"]) {
		return [[[[PasteHistoryController sharedHistoryController] historyItemAtIndex:row] theURL] description];
	} else if ([[tableColumn identifier] isEqual:@"Date"]) {
		return [[[[PasteHistoryController sharedHistoryController] historyItemAtIndex:row] addDate] description];
	}
	return nil;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[tableView release];
    [super dealloc];
}

@end
