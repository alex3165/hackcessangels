//
//  HAWebViewController.m
//  HackcessAngels
//
//  Created by Etienne Membrives on 05/07/2014.
//  Copyright (c) 2014 Hackcess Angels. All rights reserved.
//

#import "HAWebViewController.h"

@interface HAWebViewController ()

@end

@implementation HAWebViewController

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
    //[self.navbar.layer setBorderWidth:1.0];// Just to make sure its working
    //[self.navbar.layer setBorderColor:[[UIColor grayColor] CGColor]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
    [self.webView loadRequest: request];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
