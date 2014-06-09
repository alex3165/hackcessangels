//
//  HAHelpSuccessViewController.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 09/06/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAHelpSuccessViewController.h"

@interface HAHelpSuccessViewController ()

@end

@implementation HAHelpSuccessViewController

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
    self.whoStatus.textColor = [UIColor HA_purple];
    self.whatStatus.textColor = [UIColor HA_green];
    [[self.cancelHelp layer] setBorderWidth:1.0f];
    [[self.cancelHelp layer] setCornerRadius:5.0f];
    [[self.cancelHelp layer] setBorderColor:[UIColor HA_red].CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)cancelHelp:(id)sender{
    self.assistanceService = [[HAAssistanceService alloc] init];
    [self.assistanceService stopHelpRequest];
}

-(void)getHAHelpRequest:(HAHelpRequest *)helpRequest{
    UIImage *agentPicture = [UIImage imageWithData:helpRequest.user.image];
    [self.agentPicture setImage:agentPicture];
    NSString *whoStatus = [NSString stringWithFormat:@"L'agent SNCF %@", helpRequest.agent.name];
    self.whoStatus.text = whoStatus;
}

@end
