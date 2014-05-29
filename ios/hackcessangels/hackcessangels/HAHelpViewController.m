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
#import "PocketSVG.h"

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
    //[self.toolBar setFrame:CGRectMake(0, 380, 320, 80)];
//    UIImage* imgItem1 = [UIImage imageWithContentsOfFile:@"profil44"];
//    NSMutableArray *barButtonArray = [[NSMutableArray alloc] init];
//    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:imgItem1 style:UIBarButtonItemStyleBordered target: nil action: nil];
//    [barButtonArray addObject:item];
//    [self.toolBar setItems:barButtonArray animated:YES];
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
    [logViewController setCheckCredentialsBlock:[[HAUserService sharedInstance] getCheckCredentialsBlock]];
    [self presentViewController:logViewController animated:animated completion:nil];
}

@end
