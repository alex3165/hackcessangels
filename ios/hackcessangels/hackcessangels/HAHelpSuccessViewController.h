//
//  HAHelpSuccessViewController.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 09/06/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+HackcessAngels.h"
#import "HAAssistanceService.h"
#import "HAHelpRequest.h"

@interface HAHelpSuccessViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *whoStatus;
@property (weak, nonatomic) IBOutlet UIButton *cancelHelp;
@property (weak, nonatomic) IBOutlet UIImageView *agentPicture;
@property (nonatomic, strong) HAAssistanceService *assistanceService;
@property (strong, nonatomic) HAHelpRequest* helpRequest;

-(IBAction)cancelHelp:(id)sender;

@end
