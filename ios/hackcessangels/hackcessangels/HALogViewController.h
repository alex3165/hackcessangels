//
//  HALogViewController.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 23/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HAUserService.h"
#import "HAUser.h"

@interface HALogViewController : UIViewController

@property (nonatomic, strong) HAUserService *userService;
@property (nonatomic, strong) HAUser *actualUser;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)saisieReturn:(id)sender;
- (IBAction)touchOutside:(id)sender;
- (IBAction)validateForm:(id)sender;

@end
