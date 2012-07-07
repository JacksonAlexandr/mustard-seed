//
//  ItemDetailViewController.h
//  Mustard Seed
//
//  Created by Isaac Wang on 6/27/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface ItemDetailViewController : UIViewController

@property (nonatomic, strong) Item *item;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *ownerLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;

@end
