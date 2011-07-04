//
//  HistoryWindow.h
//  Pasties
//
//  Created by Alex Nichol on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PasteHistoryController.h"
#import "FocusManager.h"


@interface HistoryWindow : NSWindow <NSTableViewDataSource, NSTableViewDelegate> {
    NSTableView * tableView;
	NSButton * closeButton;
	NSButton * removeSelectedButton;
}

+ (void)showHistoryWindow;
- (void)itemDoubleClicked:(id)sender;
- (void)removeSelected:(id)sender;

@end
