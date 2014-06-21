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

NSString *const agentAnnounceFormatString = @"L'agent SNCF %@ arrive";

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
    [self setHAHelpRequest:self.helpRequest];
    [[self.cancelHelp layer] setBorderWidth:1.0f];
    [[self.cancelHelp layer] setCornerRadius:5.0f];
    [[self.cancelHelp layer] setBorderColor:[UIColor HA_red].CGColor];
    self.agentPicture.layer.cornerRadius = self.agentPicture.frame.size.height /2;
    self.agentPicture.layer.masksToBounds = YES;
    self.agentPicture.layer.borderWidth = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)cancelHelp:(id)sender{
    self.assistanceService = [HAAssistanceService sharedInstance];
    [self.assistanceService stopHelpRequest];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setHAHelpRequest:(HAHelpRequest *)helpRequest{
    UIImage *agentPicture = [UIImage imageWithData:helpRequest.agent.image];
    [self.agentPicture setImage:agentPicture];
    [self.whoStatus setText: [NSString stringWithFormat:agentAnnounceFormatString, helpRequest.agent.name]];
}

@end
