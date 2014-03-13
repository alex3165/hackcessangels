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
    
    self.assistanceService = [[HAAssistanceService alloc]init];
    
    [self.assistanceService helpMe:@"43" latitude:@"-1.48" success:^(id obj, id obj2){
        
    } failure:^(NSError *error) {
        
    }];
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
    HAUser *user = [HAUser userFromKeyChain];
    
    if (!user) {
        [self showModalLoginWithAnimation:NO];
    }
    
    self.userService = [[HAUserService alloc] init];
	
    [self.userService getUserWithEmail:user.email success:^(HAUser *user) {
        
        //Nothing to do, user is updated in service method
        DLog(@"Success");
        
    } failure:^(NSError *error) {
        
        NSInteger statusCode = [[error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        
        if (statusCode == 403) {
            [self showModalLoginWithAnimation:YES];
        }
        
        DLog(@"error");
        
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
