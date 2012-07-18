//
//  ItemDetailViewController.h
//  Mustard Seed
//
//  Created by Isaac Wang on 6/27/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommerceViewController.h"

@class Item;
@class MBProgressHUD;
@class MPMoviePlayerController;

@interface ItemDetailViewController : UIViewController <CommerceViewControllerDelegate> {
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) Item *item;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *ownerLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) IBOutlet UIImageView *buttonsView;

- (void)updateFavorite;
- (void)movieFinished:(NSNotification *) notification;

- (IBAction) toggleFavorite:(id)sender;
- (IBAction) shareToFacebook:(id)sender;
- (IBAction) playMovie:(id)sender;

- (void) setupButtons;
- (void) setupScrollView;

@end
