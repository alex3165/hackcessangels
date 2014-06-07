//
//  HALogViewController.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 23/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HAAbstractLoginService.h"

@interface HALogViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *loginContainer;
@property (weak, nonatomic) IBOutlet UILabel *loginTitle;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *valider;
- (void)setCheckCredentialsBlock:(HACheckCredentials) checkCredentials;

- (IBAction)saisieReturn:(id)sender;
- (IBAction)touchOutside:(id)sender;
- (IBAction)validateForm:(id)sender;

@end
