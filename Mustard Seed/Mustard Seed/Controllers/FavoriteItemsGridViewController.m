//
//  FavoriteItemsGridViewController.m
//  Mustard Seed
//
//  Created by Isaac Wang on 7/19/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import "FavoriteItemsGridViewController.h"
#import "GMGridView.h"

#import "Item.h"
#import "ItemGridView.h"
#import "Constants.h"
#import "RequestItemView.h"

@interface FavoriteItemsGridViewController () <GMGridViewDataSource, GMGridViewActionDelegate>

@end

@implementation FavoriteItemsGridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    self.navigationItem.hidesBackButton = YES;
    
    [super loadView];
    //[_requestItemView removeFromSuperview];
    // Back button text
    //_backButtonText = @"Favorites";
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

- (void)reload:(id)sender {
    //[_activityIndicatorView startAnimating];
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [Item favoriteItemsWithBlock:^(NSArray *items) {
        if (items) {
            _items = items;
            [_gridView reloadData];
        }
        
        //[_activityIndicatorView stopAnimating];
        //self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_items count];
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

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    [super GMGridView:gridView didTapOnItemAtIndex:position];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}

@end
