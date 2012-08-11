//
//  ItemGridViewController.m
//  Mustard Seed
//
//  Created by Isaac Wang on 7/18/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "GANTracker.h"

#import "ItemGridViewController.h"
#import "Item.h"
#import "GMGridView.h"
#import "ItemGridView.h"
#import "ItemDetailViewController.h"
#import "ColorBook.h"
#import "Constants.h"
#import "RequestItemView.h"
#import "FontBook.h"

// GMGridViewSortingDelegate, GMGridViewTransformationDelegate
@interface ItemGridViewController () <GMGridViewDataSource, GMGridViewActionDelegate, UIAlertViewDelegate> {
    IBOutlet RequestItemView *_requestItemView;
}

@end

@implementation ItemGridViewController

@synthesize items = _items;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)reload:(id)sender {
    //[_activityIndicatorView startAnimating];
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [Item itemsWithBlock:^(NSArray *items) {
        if (items) {
            _items = items;
            [_gridView reloadData];
            //[self.tableView reloadData];
        }
        
        //[_activityIndicatorView stopAnimating];
        //self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

- (void) loadView {
    [super loadView];
    
    // Setup Grid view
    NSInteger spacing = 10;
    GMGridView *gridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - _requestItemView.frame.size.height)];
    gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gridView];
    _gridView = gridView;
    NSLog(@"Grid height: %f", gridView.frame.size.height);
    
    _gridView.style = GMGridViewStyleSwap; // GMGridViewStylePush
    _gridView.itemSpacing = spacing;
    _gridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gridView.actionDelegate = self;
    _gridView.dataSource = self;
    
    self.title = NSLocalizedString(kTitle, nil);
    
    // Initialize Favorites icon
    [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"person-icon"]];
    self.navigationItem.leftBarButtonItem.tintColor = [ColorBook green];
    
    // Initialize Listen button
    [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"tv-icon"]];
    self.navigationItem.rightBarButtonItem.tintColor = [ColorBook green];
    
    // Setup Request Button
    [_requestItemView.button.layer setCornerRadius:5.0];
    _requestItemView.button.layer.borderColor = [UIColor blackColor].CGColor;
    _requestItemView.button.layer.borderWidth = 0.5f;
    _requestItemView.button.backgroundColor = [ColorBook green];
    _requestItemView.button.titleLabel.layer.shadowOpacity = 0.8;   
    _requestItemView.button.titleLabel.layer.shadowRadius = 1.0;
    _requestItemView.button.titleLabel.layer.shadowColor = [UIColor grayColor].CGColor;
    _requestItemView.button.titleLabel.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    
    // Back button text
    _backButtonText = @"Items";
    
    // Load items
    [self reload:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _gridView.mainSuperView = self.navigationController.view;
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background@2x.png"]];

    [self.view bringSubviewToFront:_requestItemView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"ItemDetailSegue"]) {
        // Set back button text
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:_backButtonText style:UIBarButtonItemStyleBordered target:nil action:nil]; 
        [[self navigationItem] setBackBarButtonItem:backButton];
        
        ItemDetailViewController *detailViewController = (ItemDetailViewController *)[segue destinationViewController];
        
        // Set item for Detail View Controller
        detailViewController.item = [_items objectAtIndex:_selectedIndex];
    }
}

#pragma mark AlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // POST requested item
        [Item postRequest:[alertView textFieldAtIndex:0].text];
    }
}

- (IBAction) onRequestButton:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Request an Item"
                              message:@""
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    
    return;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_items count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(kItemGridViewWidth, kItemGridViewHeight);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) 
    {
        cell = [[GMGridViewCell alloc] init];

        ItemGridView *view = [[ItemGridView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        cell.contentView = view;
    }
    
    Item *item = [_items objectAtIndex:index];
    [(ItemGridView *)cell.contentView setItem:item];
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position {
    // GA
    Item *item = [_items objectAtIndex:position];
    NSString *pageView = [NSString stringWithFormat: @"[%@] %@", item.itemID, item.name];
    NSError* error = nil;
    if (![[GANTracker sharedTracker] trackPageview:pageView
                                         withError:&error]) {
        NSLog(@"Track page view error: %@", error);
    }
    
    _selectedIndex = position;
    [self performSegueWithIdentifier:@"ItemDetailSegue" sender:self];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /*
    if (buttonIndex == 1) 
    {
        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
     */
}

////////////////////////////////////////////////////////////////
//#pragma mark GMGridViewSortingDelegate
////////////////////////////////////////////////////////////////
//
//- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
//{
//    [UIView animateWithDuration:0.3 
//                          delay:0 
//                        options:UIViewAnimationOptionAllowUserInteraction 
//                     animations:^{
//                         cell.contentView.backgroundColor = [UIColor orangeColor];
//                         cell.contentView.layer.shadowOpacity = 0.7;
//                     } 
//                     completion:nil
//     ];
//}
//
//- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
//{
//    [UIView animateWithDuration:0.3 
//                          delay:0 
//                        options:UIViewAnimationOptionAllowUserInteraction 
//                     animations:^{  
//                         cell.contentView.backgroundColor = [UIColor redColor];
//                         cell.contentView.layer.shadowOpacity = 0;
//                     }
//                     completion:nil
//     ];
//}
//
//- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
//{
//    return NO;
//}
//
//- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
//{
//    /*
//    NSObject *object = [_currentData objectAtIndex:oldIndex];
//    [_currentData removeObject:object];
//    [_currentData insertObject:object atIndex:newIndex];
//     */
//}
//
//- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
//{
//    //[_currentData exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
//}
//
//
////////////////////////////////////////////////////////////////
//#pragma mark DraggableGridViewTransformingDelegate
////////////////////////////////////////////////////////////////
//
//- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    return CGSizeMake(700, 530);
//    /*
//    if (INTERFACE_IS_PHONE) 
//    {
//        if (UIInterfaceOrientationIsLandscape(orientation)) 
//        {
//            return CGSizeMake(320, 210);
//        }
//        else
//        {
//            return CGSizeMake(300, 310);
//        }
//    }
//    else
//    {
//        if (UIInterfaceOrientationIsLandscape(orientation)) 
//        {
//            return CGSizeMake(700, 530);
//        }
//        else
//        {
//            return CGSizeMake(600, 500);
//        }
//    }
//     */
//}
//
//- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
//{
//    
//    UIView *fullView = [[UIView alloc] init];
//    fullView.backgroundColor = [UIColor yellowColor];
//    fullView.layer.masksToBounds = NO;
//    fullView.layer.cornerRadius = 8;
//    
//    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
//    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
//    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
//    label.textAlignment = UITextAlignmentCenter;
//    label.backgroundColor = [UIColor clearColor];
//    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    label.font = [UIFont boldSystemFontOfSize:15];
//
//    
//    [fullView addSubview:label];
//    
//    
//    return fullView;
//}
//
//- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
//{
//    [UIView animateWithDuration:0.5 
//                          delay:0 
//                        options:UIViewAnimationOptionAllowUserInteraction 
//                     animations:^{
//                         cell.contentView.backgroundColor = [UIColor blueColor];
//                         cell.contentView.layer.shadowOpacity = 0.7;
//                     } 
//                     completion:nil];
//}
//
//- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
//{
//    [UIView animateWithDuration:0.5 
//                          delay:0 
//                        options:UIViewAnimationOptionAllowUserInteraction 
//                     animations:^{
//                         cell.contentView.backgroundColor = [UIColor redColor];
//                         cell.contentView.layer.shadowOpacity = 0;
//                     } 
//                     completion:nil];
//}
//
//- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
//{
//    
//}
//
//
//
@end
