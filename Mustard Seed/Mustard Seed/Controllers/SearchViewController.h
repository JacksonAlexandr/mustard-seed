//
//  SearchViewController.h
//  Mustard Seed
//
//  Created by Isaac Wang on 7/6/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface SearchViewController : UIViewController {
    MBProgressHUD *HUD;
}

- (void) callAudioApi;

@end
