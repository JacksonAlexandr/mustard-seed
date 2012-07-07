//
//  ItemTableViewCell.m
//  Mustard Seed
//
//  Created by Isaac Wang on 6/27/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ItemTableViewCell.h"

#import "UIImageView+AFNetworking.h"

#import "Item.h"

@implementation ItemTableViewCell {
@private
    __strong Item *_item;
}

@synthesize item = _item;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    self.detailTextLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return self;
}

- (void)setItem:(Item *)item {
    _item = item;
    
    self.textLabel.text = _item.name;
    self.detailTextLabel.text = _item.description;
    [self.imageView setImageWithURL: _item.imgURL placeholderImage: [UIImage imageNamed:@"placeholder-image"]];
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithItem:(Item *)item {
    CGSize sizeToFit = [item.name sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(220.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    return fmaxf(70.0f, sizeToFit.height + 45.0f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
    self.textLabel.frame = CGRectMake(70.0f, 10.0f, 240.0f, 20.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    detailTextLabelFrame.size.height = [[self class] heightForCellWithItem:_item] - 45.0f;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
