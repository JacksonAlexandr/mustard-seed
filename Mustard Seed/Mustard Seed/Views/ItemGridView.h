//
//  ItemGridView.h
//  Mustard Seed
//
//  Created by Isaac Wang on 7/18/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface ItemGridView : UIView

@property (nonatomic, strong) Item *item;

// Buttons
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *categoryButton;
@property (nonatomic, strong) UIButton *commerceButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *videoButton;

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)viewController;

- (void) setItem:(Item *)item;

- (void) setItemCategory;
- (void) shareItem;
- (void) playItemVideo;

@end
