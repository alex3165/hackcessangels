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
    
    self.navbar.clipsToBounds = YES;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor lightGrayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, -1, CGRectGetWidth(self.navbar.frame)+4, CGRectGetHeight(self.navbar.frame)+1);
    [self.navbar.layer addSublayer:bottomBorder];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
    [self.webView loadRequest: request];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
