//
//  HAAgentUserProfileViewerViewController.h
//
//  HAAgentUserProfileViewerViewController.h
//  hackcessangels
//
//  Created by Mac on 28/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HARestRequests.h"
#import "HAUserService.h"
#import "HAHelpRequest.h"
#import "UIColor+HackcessAngels.h"

@interface HAAgentUserProfileViewerViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *infos;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *handicap;

@property (weak, nonatomic) IBOutlet UIButton *urgencePhone;

@property (weak, nonatomic) IBOutlet UIButton *Phone;

@property (weak, nonatomic) IBOutlet UIImageView *image;

-(void) passHaRequest:(HAHelpRequest *)harequest;

-(IBAction)callUserEmergency:(id)sender;

-(IBAction)callUser:(id)sender;

@end

