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

#import "Item.h"
#import "FontBook.h"
#import "ColorBook.h"

// Colors: http://www.colourlovers.com/palette/157085/commons

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController {
@private
    Item *_item;
    MPMoviePlayerController *_moviePlayer;
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_ownerLabel;
    IBOutlet UILabel *_descriptionLabel;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIImageView *_imageView;
    
    IBOutlet UIButton *_favoriteButton;
    IBOutlet UIButton *_commerceButton;
    IBOutlet UIButton *_shareButton;
    IBOutlet UIButton *_videoButton;
    
    IBOutlet UIButton *_favoriteIndicator;
    
    IBOutlet UIImageView *_buttonsView;
}

@synthesize item = _item;
@synthesize titleLabel = _titleLabel;
@synthesize ownerLabel = _ownerLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize moviePlayer = _moviePlayer;
@synthesize buttonsView = _buttonsView;

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
}

- (void) setupScrollView {
    // Set background image
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    // Format title label
    _titleLabel.text = _item.name;
    [_titleLabel setFont:[FontBook robotoBoldFontWithSize:20]];
    
    // Format favorite indicator
    [_favoriteIndicator setImage:[UIImage imageNamed:@"heart-red"] forState:UIControlStateSelected];
    [_favoriteIndicator setSelected:_item.favorite];
    
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
    
    // Load image
    [_imageView setImageWithURL:_item.imgURL placeholderImage:[UIImage imageNamed:@"placeholder-image"]];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    
    // Resize scrollView to fit description text
    float minHeight = _descriptionLabel.frame.origin.y + _descriptionLabel.frame.size.height - 20;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, minHeight);
}

- (void) setupButtons {
    /*
    _favoriteButton.backgroundColor = UIColorFromRGB(0xC92020);
    _commerceButton.backgroundColor = UIColorFromRGB(0x88C6C9);
    _shareButton.backgroundColor = UIColorFromRGB(0x798EE0);
    _videoButton.backgroundColor = UIColorFromRGB(0xCDD3E9);

    NSMutableArray *buttons = [NSMutableArray arrayWithObjects:_favoriteButton, _videoButton, _shareButton, _commerceButton, nil];
    
    float x = kButtonBorder;
    float width = (_buttonsView.frame.size.width - kButtonBorder) / buttons.count - kButtonBorder;
    for (UIButton *button in buttons) {
        button.frame = CGRectMake(x, kButtonBorder, width, _buttonsView.frame.size.height - kButtonBorder);
        x += width + kButtonBorder;
    }
     */
    
    _favoriteButton.selected = _item.favorite;
    
    _buttonsView.layer.shadowOffset = CGSizeMake(0, -5);
    _buttonsView.layer.shadowRadius = 10.0;
    _buttonsView.layer.shadowOpacity = 0.35;
    _buttonsView.clipsToBounds = NO;
    _buttonsView.opaque = NO;
    
    // Customize layout of buttonsView
    _buttonsView.image = [[UIImage imageNamed:@"tab-bar"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
    
    // Position buttonsView due to weird bug..
    float yPos = _scrollView.frame.origin.y + _scrollView.frame.size.height;
    float height = self.view.frame.size.height - yPos;
    NSLog(@"Height: %f", height);
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

- (void)updateFavorite {
    /*
    if (_item.favorite) {
        _favoriteButton.titleLabel.text = @"Unfavorite";
    } else {
        _favoriteButton.titleLabel.text = @"Favorite";
    }
     */
}

- (void) movieFinished:(NSNotification *) notification {
    MPMoviePlayerController *moviePlayer = [notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self      
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {
        [moviePlayer.view removeFromSuperview];
    }
}

#pragma mark - IBActions

- (IBAction) toggleFavorite:(id)sender {
    [_item setFavorite:!_item.favorite];
    [self updateFavorite];
    //[_favoriteButton setSelected:!_favoriteButton.selected];
    [_favoriteIndicator setSelected:!_favoriteIndicator.selected];
}

- (IBAction) shareToFacebook:(id)sender {
    // Load HUD
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Sharing on Facebook";
    [HUD show:YES];
    
    // @TODO: Facebook API calls here
    
    [HUD hide:YES afterDelay:2];
    //[HUD hide:YES];
}

// Plays a fullscreen movie
- (IBAction) playMovie:(id)sender {
    //NSURL *url = [NSURL URLWithString:@"http://www.ebookfrenzy.com/ios_book/movie/movie.mov"];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]];
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinished:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}

#pragma mark - Delegate
- (void) commerceViewControllerDone:(CommerceViewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

@end
