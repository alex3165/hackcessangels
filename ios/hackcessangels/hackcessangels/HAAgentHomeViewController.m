//
//  HAAgentHomeViewController.m
//  hackcessangels
//
//  Created by Etienne Membrives on 19/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAAgentHomeViewController.h"
#import "HALogViewController.h"
#import "HAAgentService.h"

@interface HAAgentHomeViewController ()

@property(nonatomic, strong) HAAgentService* agentService;

@end

@implementation HAAgentHomeViewController

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/******************************************************************************************************************************
 *
 * Service
 *
 *****************************************************************************************************************************/


#pragma mark - Service

- (void)checkUser
{
    self.agentService = [HAAgentService sharedInstance];
    
    [self.agentService getCurrentAgent:^(HAAgent *agent) {
        DLog(@"Success");
    } failure:^(NSError *error) {
        if (error.code == 401 || error.code == 404) {
            [self showModalLoginWithAnimation:NO];
        }
    }];
}


/******************************************************************************************************************************
 *
 * Utils
 *
 *****************************************************************************************************************************/


#pragma mark - Utils

- (void)showModalLoginWithAnimation:(BOOL)animated
{
    HALogViewController *logViewController = [[UIStoryboard storyboardWithName:@"Agent" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
    [logViewController setCheckCredentialsBlock:[[HAAgentService sharedInstance] getCheckCredentialsBlock]];
    [self presentViewController:logViewController animated:animated completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
