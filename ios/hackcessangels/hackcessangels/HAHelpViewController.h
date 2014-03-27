//
//  HAHelpViewController.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 23/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HAAssistanceService.h"
#import "DCRestRequests.h"
#import "HAUserService.h"
#import "HAMapViewController.h"

@interface HAHelpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *helpme;

@property (nonatomic, strong) HAAssistanceService *assistanceService;
@property (nonatomic, strong) HAUserService *userService;
@property (nonatomic,strong) HAMapViewController *mapController;

@end