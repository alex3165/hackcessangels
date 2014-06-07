//
//  HAAgentHomeViewController.h
//  hackcessangels
//
//  Created by Etienne Membrives on 19/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HAAgentHomeViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *helloUser;

- (IBAction) verifyHelpRequests:(id)sender;
- (IBAction) createFakeHelpRequest:(id)sender;

@end
