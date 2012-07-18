//
//  ItemGridViewControllerViewController.m
//  Mustard Seed
//
//  Created by Isaac Wang on 7/18/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import "ItemGridViewControllerViewController.h"

@interface ItemGridViewControllerViewController ()

@end

@implementation ItemGridViewControllerViewController

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
	// Do any additional setup after loading the view.
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

@end
