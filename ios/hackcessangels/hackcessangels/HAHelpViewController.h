//
//  HAHelpViewController.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 23/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HAAssistanceService.h"
#import "HAUserService.h"
#import "HAMapViewController.h"

@interface HAHelpViewController : UIViewController <UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *helpme;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelHelp;
@property (weak, nonatomic) IBOutlet UIButton *urgencyNumber;
@property (weak, nonatomic) IBOutlet UILabel *whoStatus;
@property (weak, nonatomic) IBOutlet UILabel *whatStatus;
@property (weak, nonatomic) IBOutlet UILabel *timeNotification;

@property (nonatomic, strong) HAAssistanceService *assistanceService;
@property (nonatomic, strong) HAUserService *userService;
@property (nonatomic, strong) HAMapViewController *mapController;

-(void) defaultRequestAgentStatus;
-(void) requestAgentContactedStatus;
-(void) requestAgentTryAgainStatus;
-(void) requestAgentFailedAgainStatus;
-(void) requestAgentCancelStatus;

- (IBAction) showProfil:(id)sender;
-(IBAction)cancelHelp:(id)sender;

@end