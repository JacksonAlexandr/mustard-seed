//
//  SearchViewController.m
//  Mustard Seed
//
//  Created by Isaac Wang on 7/6/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "GANTracker.h"

#import "SearchViewController.h"
#import "FavoriteItemsTableViewController.h"
#import "Constants.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

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
	
    // Disable back button
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // GA
    NSError* error = nil;
    if (![[GANTracker sharedTracker] trackPageview:@"Listening to TV Audio"
                                         withError:&error]) {
        NSLog(@"Track page view error: %@", error);
    }
    
    // Listen to input
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	// Set determinate mode
	HUD.mode = MBProgressHUDModeDeterminate;
    
    // Dim background
    HUD.dimBackground = YES;
	
	//HUD.delegate = self;
	HUD.labelText = @"Listening";
	
	// Spawn off listening process uses the HUD instance to update progress
	[HUD showWhileExecuting:@selector(callAudioApi) onTarget:self withObject:nil animated:YES];
}

- (void) callAudioApi {
    // This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		HUD.progress = progress;
		usleep(kWaitingTimeInMicroseconds);
	}
    
    // Processing
	sleep(kWaitingTimeInMicroseconds / 20000);
    
	HUD.mode = MBProgressHUDModeIndeterminate;
	HUD.labelText = @"Processing audio";
	progress = 0.0f;
	while (progress < 1.0f)
	{
		progress += 0.01f;
		HUD.progress = progress;
		usleep(kWaitingTimeInMicroseconds);
	}
    
    [self performSegueWithIdentifier:@"ItemsSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
