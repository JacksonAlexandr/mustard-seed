//
//  ItemGridView.m
//  Mustard Seed
//
//  Created by Isaac Wang on 7/18/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ItemGridView.h"
#import "UIImageView+AFNetworking.h"

#import "Item.h"
#import "FontBook.h"

const float kPadding = 5.0;

@implementation ItemGridView {
    Item *_item;
    
    UIImageView *_imageView;
    UIView *_borderView;
    
    UILabel *_titleLabel;
    UILabel *_ownerLabel;
}

@synthesize item = _item;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize imageView
        _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 2.0 / 3.0)];
        _borderView.backgroundColor = [UIColor whiteColor];
        _borderView.layer.masksToBounds = NO;
        _borderView.layer.shadowOffset = CGSizeMake(0, 1.5);
        _borderView.layer.shadowRadius = 3;
        _borderView.layer.shadowOpacity = 0.15;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPadding, kPadding, self.frame.size.width - 2 * kPadding, _borderView.frame.size.height - 5 * kPadding)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _borderView.frame.size.height + kPadding, self.frame.size.width, 20.0)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [FontBook robotoBoldFontWithSize:15.0];
        
        _ownerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.frame.origin.y
                                                                + _titleLabel.frame.size.height, self.frame.size.width, 15.0)];
        _ownerLabel.backgroundColor = [UIColor clearColor];
        _ownerLabel.textColor = [UIColor grayColor];
        _ownerLabel.font = [FontBook robotoFontWithSize:11.5];
        
        [self addSubview:_borderView];
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        [self addSubview:_ownerLabel];
    }
    return self;
}

- (void) setItem:(Item *)item {
    _item = item;
    
    _titleLabel.text = _item.name;
    _ownerLabel.text = _item.owner;
    [_imageView setImageWithURL:_item.imgURL placeholderImage:[UIImage imageNamed:@"placeholder-image"]];
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
