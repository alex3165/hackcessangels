//
//  HAHelpViewController.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 23/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HAAssistanceService.h"
#import "HAUserService.h"
#import "HAMapViewController.h"
#import "HAInfosViewController.h"
#import "HAAccesViewController.h"

@interface HAHelpViewController : UIViewController <UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *helpme;


@property (weak, nonatomic) IBOutlet UIButton *infos;
@property (weak, nonatomic) IBOutlet UIButton *accesplus;

@property (nonatomic, strong) HAAssistanceService *assistanceService;
@property (nonatomic, strong) HAUserService *userService;
@property (nonatomic,strong) HAMapViewController *mapController;

@property (nonatomic,strong) HAInfosViewController *infosService;
@property (nonatomic,strong) HAAccesViewController *accesService;


@end