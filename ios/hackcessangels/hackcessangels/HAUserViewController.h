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


@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextInput;
@property (weak, nonatomic) IBOutlet UITextField *nameTextInput;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextInput;

@property (weak, nonatomic) IBOutlet UIButton *save;

@property (nonatomic, strong) HAUserService *editUser;
- (IBAction) saisieReturn:(id)sender;
- (IBAction) touchOutside:(id)sender;
- (IBAction) saveAndDismiss:(id)sender;
@end


