//
//  RequestItemView.m
//  Mustard Seed
//
//  Created by Isaac Wang on 7/23/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import "RequestItemView.h"
#import "FontBook.h"

#import "Item.h"

@implementation RequestItemView {
    UIButton *_button;
    Item *_requestItem;
}

@synthesize button = _button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
