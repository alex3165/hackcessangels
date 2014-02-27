//
//  HALogViewController.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 23/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HALogViewController.h"
#import "HAHelpViewController.h"

@interface HALogViewController ()

@property (nonatomic, strong) NSString * textEmail;
@property (nonatomic, strong) NSString * textPassword;
@property (nonatomic, strong) HAHelpViewController *helpController;

@end

@implementation HALogViewController

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
	
    self.userService = [[HAUserService alloc] init];
    self.helpController = [[HAHelpViewController alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saisieReturn:(id)sender {
    
    [sender resignFirstResponder];
}

- (IBAction)touchOutside:(id)sender {
    
    [sender resignFirstResponder];
}

- (IBAction)validateForm:(id)sender
{
        self.textEmail = self.login.text;
        self.textPassword = self.password.text;

        [self.userService loginWithEmailAndPassword:self.textEmail password:self.textPassword success:^(id obj){
    
            // On stock les données sur l'utilisateur et on passe à la vue suivante
            [self.navigationController pushViewController:self.helpController animated:true];
    
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_login resignFirstResponder];
    [_password resignFirstResponder];
    
}

@end
