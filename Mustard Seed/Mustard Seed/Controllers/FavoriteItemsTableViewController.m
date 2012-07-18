//
//  FavoriteItemsTableViewController.m
//  Mustard Seed
//
//  Created by Isaac Wang on 7/12/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import "FavoriteItemsTableViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "ItemDetailViewController.h"
#import "ItemTableViewCell.h"
#import "Item.h"

@interface FavoriteItemsTableViewController ()

@end

@implementation FavoriteItemsTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)reload:(id)sender {
    [_activityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [Item favoriteItemsWithBlock:^(NSArray *items) {
        if (items) {
            _items = items;
            [self.tableView reloadData];
        }
        
        [_activityIndicatorView stopAnimating];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    self.navigationController.navigationBar.layer.shadowRadius = 5.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.55f;
    self.navigationController.navigationBar.clipsToBounds = NO;
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.item = [_items objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ItemTableViewCell heightForCellWithItem:[_items objectAtIndex:indexPath.row]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"ItemDetailSegue"]) {
        ItemDetailViewController *detailViewController = (ItemDetailViewController *)[segue destinationViewController];
        
        // Set item for Detail View Controller
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        detailViewController.item = [_items objectAtIndex:selectedRowIndex.row];
    }
}

@end
