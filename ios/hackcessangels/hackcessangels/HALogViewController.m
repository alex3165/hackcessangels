//
//  HALogViewController.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 23/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HALogViewController.h"
#import "HAHelpViewController.h"
#import "UIColor+HackcessAngels.h"

@interface HALogViewController ()

@property (nonatomic, strong) NSString * textEmail;
@property (nonatomic, strong) NSString * textPassword;
@property (nonatomic, strong) HACheckCredentials checkCredentials;

@end

@implementation HALogViewController

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
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor HA_angelGray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saisieReturn:(id)sender {
    
    [sender resignFirstResponder];
}

- (IBAction)touchOutside:(id)sender {
    
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_email resignFirstResponder];
    [_password resignFirstResponder];
    
}

- (void)setCheckCredentialsBlock:(HACheckCredentials)checkCredentials {
    self.checkCredentials = checkCredentials;
}

- (IBAction)validateForm:(id)sender
{
    self.checkCredentials(self.email.text, self.password.text, ^() {
        [self dismissViewControllerAnimated:YES completion:nil];
    }, ^( NSError *error) {
        NSLog(@"%@",error);
    });
}

@end
