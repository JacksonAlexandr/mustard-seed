//
//  CommerceViewController.h
//  Mustard Seed
//
//  Created by Isaac Wang on 7/8/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyTracker.h"

@class CommerceViewController;
@class MBProgressHUD;

@protocol CommerceViewControllerDelegate <NSObject>
- (void)commerceViewControllerDone:
(CommerceViewController *)controller;
@end

@interface CommerceViewController : UIViewController <UIWebViewDelegate> {
    MBProgressHUD *HUD;
}

@property (nonatomic, weak) id <CommerceViewControllerDelegate> delegate;
@property (nonatomic, strong) NSURL *url;

- (IBAction)done:(id)sender;

@end
