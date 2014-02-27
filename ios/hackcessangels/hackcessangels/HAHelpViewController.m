//
//  HAHelpViewController.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 23/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAHelpViewController.h"

@interface HAHelpViewController ()

@end

@implementation HAHelpViewController

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
	

}

- (IBAction)helpme:(id)sender {
    
    self.assistanceService = [[HAAssistanceService alloc]init];
    
    [self.assistanceService helpMe:@"43" latitude:@"-1.48" success:^(id obj){
        
    } failure:^(NSError *error) {
        
    }];
}



@end
