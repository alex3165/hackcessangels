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
#import "UIColor+HackcessAngels.h"

@interface HAHelpViewController ()
    @property (nonatomic, strong) HAUser *user;
    @property (nonatomic, strong) NSMutableString *helloUser;
@end

@implementation HAHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkUser];
    [self customToolBar];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor HA_graybg];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)helpme:(id)sender {
    
    self.assistanceService = [[HAAssistanceService alloc] init];
    [self.assistanceService startHelpRequest:nil agentContacted:nil success:nil];
    
}


-(void) customToolBar{
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
        NSString *helloName = [NSString stringWithFormat:@"Bonjour %@", user.name];
        self.titleLabel.text = helloName;
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
    [logViewController setCheckCredentialsBlock:[[HAUserService sharedInstance] getCheckCredentialsBlock]];
    [self presentViewController:logViewController animated:animated completion:nil];
}

@end
