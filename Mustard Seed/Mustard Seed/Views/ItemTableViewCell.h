//
//  ItemTableViewCell.h
//  Mustard Seed
//
//  Created by Isaac Wang on 6/27/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface ItemTableViewCell : UITableViewCell

@property (nonatomic, strong) Item *item;

+ (CGFloat)heightForCellWithItem:(Item *) item;

@end
