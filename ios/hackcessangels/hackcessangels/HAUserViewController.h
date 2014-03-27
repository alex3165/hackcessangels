//
//  HAUserViewController.h
//  hackcessangels
//
//  Created by Mac on 06/03/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCRestRequests.h"
#import "HAUserService.h"
#import "DCRestRequests.h"
#import "HAEditUserService.h"

// Libs
#import "AFNetworking.h"

@interface HAUserViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *showLogin;
@property (weak, nonatomic) IBOutlet UITextField *showPassword;
@property (weak, nonatomic) IBOutlet UITextField *showEmail;
@property (weak, nonatomic) IBOutlet UITextField *showDescription;
@property (weak, nonatomic) IBOutlet UITextField *showHandicap;

@property (weak, nonatomic) IBOutlet UIButton *edit;

@property (nonatomic, strong) HAUserService *editUser;
- (IBAction)saisieReturn:(id)sender;
- (IBAction)touchOutside:(id)sender;



@end


