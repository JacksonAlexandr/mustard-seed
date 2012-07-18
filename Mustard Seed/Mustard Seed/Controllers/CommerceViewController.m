//
//  CommerceViewController.m
//  Mustard Seed
//
//  Created by Isaac Wang on 7/8/12.
//  Copyright (c) 2012 LMD Corp. All rights reserved.
//

#import "CommerceViewController.h"
#import "MBProgressHUD.h"

@interface CommerceViewController ()

@end

@implementation CommerceViewController {
@private
    IBOutlet UIWebView *webView;
    NSURL *_url;
}

@synthesize delegate;
@synthesize url = _url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [webView loadRequest:request];
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    // Load HUD
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Loading";
    
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

- (void) webViewDidStartLoad:(UIWebView *)webView {
    [HUD show:YES];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    [HUD hide:YES];
}

- (IBAction)done:(id)sender {
    [self.delegate commerceViewControllerDone:self];
}

@end
