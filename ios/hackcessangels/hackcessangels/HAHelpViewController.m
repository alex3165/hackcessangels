//
//  HAHelpViewController.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 23/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAHelpViewController.h"
#import "HALogViewController.h"
#import "HAUserService.h"
<<<<<<< HEAD
#import "HAInfosViewController.h"
=======
#import "HAHelpInProcess.h"
>>>>>>> f93dac870d1d71ae5bc39e72b49e6e5c406be4da

@interface HAHelpViewController ()

@end

@implementation HAHelpViewController

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
    [self checkUser];
}

- (IBAction)helpme:(id)sender {
    
    self.assistanceService = [[HAAssistanceService alloc] init];
    
    [self.assistanceService startHelpRequest:nil agentContacted:nil success:nil];
    
    HAHelpInProcess *inprocesscontroller = [[HAHelpInProcess alloc]init];
    [self.navigationController pushViewController:inprocesscontroller animated:YES];
    
}

- (IBAction)infos:(id)sender {
    
   // self.viewDidLoad = [[HAInfosViewController alloc] init];
    
}

- (IBAction)accesplus:(id)sender {
    
    // self.viewDidLoad = [[HAInfosViewController alloc] init];
    
}

/******************************************************************************************************************************
 *
 *
 * Service
 *
 *
 *****************************************************************************************************************************/


#pragma mark - Service

- (void)checkUser
{
    self.userService = [HAUserService sharedInstance];
    
    [self.userService getCurrentUser:^(HAUser *user) {
        DLog(@"Success");
    } failure:^(NSError *error) {
        if (error.code == 401 || error.code == 404) {
            [self showModalLoginWithAnimation:NO];
        }
    }];
}


/******************************************************************************************************************************
 *
 *
 * Utils
 *
 *
 *****************************************************************************************************************************/


#pragma mark - Utils

- (void)showModalLoginWithAnimation:(BOOL)animated
{
    HALogViewController *logViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self presentViewController:logViewController animated:animated completion:nil];
}

@end
