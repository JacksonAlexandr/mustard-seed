//
//  ItemGridViewController.h
//  Mustard Seed
//
//  Created by Isaac Wang on 7/18/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommerceViewController.h"

@class Item;
@class GMGridView;
@class RequestItemView;

@interface ItemGridViewController : UIViewController<CommerceViewControllerDelegate> {
    NSArray *_items;
    GMGridView *_gridView;
    NSString *_backButtonText;
}

@property (nonatomic, strong) NSArray *items;

- (void) reload:(id)sender;

- (void) GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position;
- (void) itemSelected;

- (void) showCommerceViewController;
- (void) commerceViewControllerDone:(CommerceViewController *)controller;

@end
