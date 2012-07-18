//
//  ItemsTableViewController.h
//  Mustard Seed
//
//  Created by Isaac Wang on 6/27/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsTableViewController : UITableViewController {
    NSArray *_items;
    UIActivityIndicatorView *_activityIndicatorView;
    UIButton *_requestButton;
}

- (void) reload:(id) sender;
- (void) listenToAudio:(id) sender;
- (void) initRequestButton;
- (void) requestItem;

@end
