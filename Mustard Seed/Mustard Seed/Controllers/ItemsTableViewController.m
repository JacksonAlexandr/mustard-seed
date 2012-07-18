//
//  ItemsTableViewController.m
//  Mustard Seed
//
//  Created by Isaac Wang on 6/27/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ItemsTableViewController.h"

#import "Item.h"
#import "ItemTableViewCell.h"
#import "ItemDetailViewController.h"
#import "ColorBook.h"
#import "SearchViewController.h"

// Constants
NSString *kTitle = @"KUBE-IT";
float kRequestButtonHeight = 40.0f;

@implementation ItemsTableViewController

- (void)reload:(id)sender {
    [_activityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [Item itemsWithBlock:^(NSArray *items) {
        if (items) {
            _items = items;
            [self.tableView reloadData];
        }
        
        [_activityIndicatorView stopAnimating];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    // Initialize Activity Indicator
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.hidesWhenStopped = YES;
    
    // Initialize Back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    backButton.tintColor = [ColorBook green];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    // Initialize Person icon
    [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"person-icon"]];
    self.navigationItem.leftBarButtonItem.tintColor = [ColorBook green];
    
    // Initialize Listen button
    self.navigationItem.rightBarButtonItem.title = @"Listen";
    self.navigationItem.rightBarButtonItem.tintColor = [ColorBook green];
    
    [self initRequestButton];
}

- (void) initRequestButton {
    _requestButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_requestButton addTarget:self action:@selector(requestItem) forControlEvents:UIControlEventTouchDown];
    [_requestButton setTitle:@"Request Item" forState:UIControlStateNormal];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self reload:nil];
}

- (void)listenToAudio:(id) sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    
    SearchViewController *searchViewController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self presentModalViewController:searchViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(kTitle, nil);
    /*
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Listen" style:UIBarButtonItemStylePlain target:self action:@selector(listenToAudio:)];
    */
    self.tableView.rowHeight = 70.0f;
    
    [self reload:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    _activityIndicatorView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) requestItem {
    NSLog(@"Requesting item");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Extra row for button
    return [_items count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    // Last cell should be the request button
    if (indexPath.row == _items.count) {
        CellIdentifier = @"_requestButtonCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        // Add button
        _requestButton.frame = cell.bounds;
        [cell addSubview:_requestButton];
        
        return cell;
    } else {
        CellIdentifier = @"ItemCell";
        ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[ItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        cell.item = [_items objectAtIndex:indexPath.row];
        
        return cell;
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Request button
    if (indexPath.row == _items.count)
        return kRequestButtonHeight;
    
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
