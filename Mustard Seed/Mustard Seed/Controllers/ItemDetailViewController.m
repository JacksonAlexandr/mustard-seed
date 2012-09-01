//
//  ItemDetailViewController.m
//  Mustard Seed
//
//  Created by Isaac Wang on 6/27/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "ActionSheetPicker.h"
#import "GANTracker.h"

#import "Item.h"
#import "FontBook.h"
#import "ColorBook.h"
#import "Constants.h"
#import "Category.h"

// Colors: http://www.colourlovers.com/palette/157085/commons

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController {
@private
    Item *_item;
    MPMoviePlayerController *_moviePlayer;
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_ownerLabel;
    IBOutlet UILabel *_categoryLabel;
    IBOutlet UILabel *_descriptionLabel;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIImageView *_imageView;
    
    IBOutlet UIButton *_favoriteButton;
    IBOutlet UIButton *_commerceButton;
    IBOutlet UIButton *_shareButton;
    IBOutlet UIButton *_videoButton;
    
    IBOutlet UIPickerView *_categoryPickerView;
    
    IBOutlet UIButton *_favoriteIndicator;
    
    IBOutlet UIImageView *_buttonsView;
}

@synthesize item = _item;
@synthesize titleLabel = _titleLabel;
@synthesize ownerLabel = _ownerLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize moviePlayer = _moviePlayer;
@synthesize buttonsView = _buttonsView;
@synthesize categoryLabel = _categoryLabel;
@synthesize categoryPickerView = _categoryPickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    
    [self setupButtons];
    [self setupScrollView];
    
    [_categoryPickerView removeFromSuperview];
}

- (void) setupScrollView {
    // Set background image
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    // Format title label
    _titleLabel.text = _item.name;
    [_titleLabel setFont:[FontBook robotoBoldFontWithSize:20]];
    
    // Format favorite indicator
    [_favoriteIndicator setImage:[UIImage imageNamed:@"heart-red"] forState:UIControlStateSelected];
    [_favoriteIndicator setSelected:![_item.category.categoryID isEqualToString:@""]];
    
    // Format description label
    _descriptionLabel.text = _item.description;
    _descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
    _descriptionLabel.numberOfLines = 0;
    [_descriptionLabel setFont:[FontBook robotoFont]];
    [_descriptionLabel sizeToFit];
    
    // Format owner label
    _ownerLabel.text = _item.owner;
    [_ownerLabel setFont:[FontBook robotoFont]];
    _ownerLabel.textColor = [UIColor grayColor];
    
    // Format category label
    _categoryLabel.text = _item.category.name;
    [_categoryLabel setFont:[FontBook robotoFont]];
    _categoryLabel.textColor = [UIColor grayColor];
    
    // Load image
    [_imageView setImageWithURL:_item.imgURL placeholderImage:[UIImage imageNamed:@"placeholder-image"]];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    
    // Resize scrollView to fit description text
    float minHeight = _descriptionLabel.frame.origin.y + _descriptionLabel.frame.size.height + 5;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, minHeight);
}

- (void) setupButtons {    
    _favoriteButton.selected = _item.favorite;
    
    _buttonsView.layer.shadowOffset = CGSizeMake(0, -5);
    _buttonsView.layer.shadowRadius = 10.0;
    _buttonsView.layer.shadowOpacity = 0.35;
    _buttonsView.clipsToBounds = NO;
    _buttonsView.opaque = NO;
    
    // Customize layout of buttonsView
    _buttonsView.backgroundColor = [ColorBook darkGray];
    
    // Position buttonsView due to weird bug..
    float yPos = _scrollView.frame.origin.y + _scrollView.frame.size.height;
    float height = self.view.frame.size.height - yPos;
    _buttonsView.frame = CGRectMake(0, yPos, self.view.frame.size.width, height);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"CommerceSegue"]) {
		UINavigationController *navigationController = segue.destinationViewController;
		CommerceViewController *commerceViewController = [[navigationController viewControllers] objectAtIndex:0];
        commerceViewController.url = _item.commerceURL;
		commerceViewController.delegate = self;
	}
}

#pragma mark - IBActions
- (IBAction) addToCategory:(id)sender {
    [_item chooseCategory:sender withBlock:^{
        _categoryLabel.text = _item.category.name;
        [_favoriteIndicator setSelected:true];
    }];
}

- (IBAction) shareToFacebook:(id)sender {
    [_item shareInView: self.view];
}

// Plays a fullscreen movie
- (IBAction) playMovie:(id)sender {
    [_item playVideoInView:self.view];
}

#pragma mark - Delegate
- (void) commerceViewControllerDone:(CommerceViewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

@end
