//
//  ItemDetailViewController.m
//  Mustard Seed
//
//  Created by Isaac Wang on 6/27/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ItemDetailViewController.h"

#import "Item.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController {
@private
    __strong Item *_item;
    __strong IBOutlet UILabel *_titleLabel;
    __strong IBOutlet UILabel *_ownerLabel;
    __strong IBOutlet UILabel *_descriptionLabel;
}

@synthesize item = _item;
@synthesize titleLabel = _titleLabel;
@synthesize ownerLabel = _ownerLabel;
@synthesize descriptionLabel = _descriptionLabel;

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
    ((UIScrollView *)self.view).contentSize = CGSizeMake(1280, 960);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    // Load item into view
    self.titleLabel.text = _item.name;
    self.descriptionLabel.text = _item.description;
    self.ownerLabel.text = _item.owner;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
