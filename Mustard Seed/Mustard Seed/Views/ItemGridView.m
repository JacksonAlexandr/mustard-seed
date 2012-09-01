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
#import "Constants.h"

const float kPadding = 5.0;

@implementation ItemGridView {
    Item *_item;
    
    UIView *_borderView;
    
    UILabel *_titleLabel;
    UILabel *_ownerLabel;
    
    UIButton *_imageButton;
    UIButton *_categoryButton;
    UIButton *_commerceButton;
    UIButton *_shareButton;
    UIButton *_videoButton;
    
    UIViewController *_parentViewController;
}

@synthesize imageButton = _imageButton;
@synthesize item = _item;
@synthesize categoryButton = _categoryButton;
@synthesize commerceButton = _commerceButton;
@synthesize shareButton = _shareButton;
@synthesize videoButton = _videoButton;

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)viewController
{
    self = [super initWithFrame:frame];
    if (self) {
        _parentViewController = viewController;
        
        // Initialize imageView
        _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kItemGridViewWidth, kItemGridViewImageHeight)];
        _borderView.backgroundColor = [UIColor whiteColor];
        _borderView.layer.masksToBounds = NO;
        _borderView.layer.shadowOffset = CGSizeMake(0, 1.5);
        _borderView.layer.shadowRadius = 3;
        _borderView.layer.shadowOpacity = 0.15;
        
        _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(kPadding, kPadding, kItemGridViewWidth  - 2 * kPadding, _borderView.frame.size.height - 5 * kPadding)];
        _imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageButton.imageView.clipsToBounds = YES;
        _imageButton.adjustsImageWhenHighlighted = NO;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _borderView.frame.size.height + kPadding, self.frame.size.width, kItemGridViewTitleHeight)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [FontBook robotoBoldFontWithSize:15.0];
        
        _ownerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.frame.origin.y
                                                                + _titleLabel.frame.size.height, self.frame.size.width, kItemGridViewOwnerHeight)];
        _ownerLabel.backgroundColor = [UIColor clearColor];
        _ownerLabel.textColor = [UIColor grayColor];
        _ownerLabel.font = [FontBook robotoFontWithSize:11.5];
        
        // Buttons
        float buttonX = kItemGridViewBuffer;
        float buttonY = _ownerLabel.frame.origin.y + kItemGridViewBuffer;
        float buttonSize = self.frame.size.width / 4 - 2 * kItemGridViewBuffer;
        
        _categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _categoryButton.frame = CGRectMake(buttonX, buttonY, buttonSize, buttonSize);
        UIImage *icon = [UIImage imageNamed:@"heart-icon-black"];
        [_categoryButton setImage:icon forState:UIControlStateNormal];
        //[_categoryButton setTitle:@"Category" forState:UIControlStateNormal];
        [_categoryButton addTarget:self action:@selector(setItemCategory) forControlEvents:UIControlEventTouchUpInside];
        
        buttonX += buttonSize + 2 * kItemGridViewBuffer;
        _commerceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commerceButton.frame = CGRectMake(buttonX, buttonY, buttonSize, buttonSize);
        icon = [UIImage imageNamed:@"shopping-icon-black"];
        [_commerceButton setImage:icon forState:UIControlStateNormal];
        //[_commerceButton setTitle:@"Buy" forState:UIControlStateNormal];
        [_commerceButton addTarget:viewController action:@selector(showCommerceViewController) forControlEvents:UIControlEventTouchUpInside];
        
        buttonX += buttonSize + 2 * kItemGridViewBuffer;
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(buttonX, buttonY, buttonSize, buttonSize);
        icon = [UIImage imageNamed:@"share-icon-black"];
        [_shareButton setImage:icon forState:UIControlStateNormal];
        //[_shareButton setTitle:@"Share" forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareItem) forControlEvents:UIControlEventTouchUpInside];
        
        buttonX += buttonSize + 2 * kItemGridViewBuffer;
        _videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _videoButton.frame = CGRectMake(buttonX, buttonY, buttonSize, buttonSize);
        icon = [UIImage imageNamed:@"play-icon-black"];
        [_videoButton setImage:icon forState:UIControlStateNormal];
        //[_videoButton setTitle:@"Watch" forState:UIControlStateNormal];
        [_videoButton addTarget:self action:@selector(playItemVideo) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_borderView];
        [self addSubview:_imageButton];
        [self addSubview:_titleLabel];
        [self addSubview:_ownerLabel];
        [self addSubview:_categoryButton];
        [self addSubview:_commerceButton];
        [self addSubview:_shareButton];
        [self addSubview:_videoButton];
    }
    return self;
}

- (void) setItem:(Item *)item {
    _item = item;
    
    _titleLabel.text = _item.name;
    _ownerLabel.text = _item.owner;
    
    // Load image asynchronously
    UIImageView *imageView = [[UIImageView alloc] init];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_item.imgURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    
    [imageView setImageWithURLRequest:request 
                     placeholderImage:[UIImage imageNamed:@"placeholder-image"]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  [_imageButton setImage:image forState:UIControlStateNormal];
                              }
                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                              }];
    [_imageButton setImage:imageView.image forState:UIControlStateNormal];
}

- (void) setItemCategory {
    [_item chooseCategory:self withBlock:nil];
}

- (void) shareItem {
    [_item shareInView:_parentViewController.view];
}

- (void) playItemVideo {
    [_item playVideoInView:_parentViewController.view];
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
