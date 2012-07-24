//
//  ItemGridViewController.h
//  Mustard Seed
//
//  Created by Isaac Wang on 7/18/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;
@class GMGridView;

@interface ItemGridViewController : UIViewController {
    NSArray *_items;
    GMGridView *_gridView;
    NSString *_backButtonText;
    
    NSInteger _selectedIndex;
}

@property (nonatomic, strong) NSArray *items;

- (void)reload:(id)sender;

@end
