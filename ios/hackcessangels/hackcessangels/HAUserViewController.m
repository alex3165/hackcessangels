//
//  HAUserViewController.m
//  hackcessangels
//
//  Created by Mac on 06/03/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAUserViewController.h"
#import "HAUserService.h"
#import "HAUser.h"

@interface HAUserViewController ()

@property (nonatomic, strong) NSString * textLogin;
@property (nonatomic, strong) NSString * textEmail;
@property (nonatomic, strong) NSString * textPassword;

@end

@implementation HAUserViewController

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
    // Do any additional setup after loading the view from its nib.
}



- (IBAction)editUser:(id)sender {
    
    self.editUser = [[HAUserService alloc]init];
    [self.editUser updateUser:nil withUpdatedEmail:nil login:nil withUpdatedLogin:nil password:nil withUpdatedPassword:nil success:nil failure:nil];
}






@end
