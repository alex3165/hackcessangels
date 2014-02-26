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

@end

@implementation HALogViewController

NSString * text_email;
NSString * text_password;
HAHelpViewController *helpController;

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
    helpController = [[HAHelpViewController alloc]init];
    

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

- (IBAction)validateForm:(id)sender {
        text_email = self.login.text;
        text_password = self.password.text;
        NSLog(@"hehehe on est bien dans la boucle");
        [self.userService loginWithEmailAndPassword:text_email password:text_password success:^{
    
            // On stock les données sur l'utilisateur et on passe à la vue suivante
    
            [self.navigationController pushViewController:helpController animated:true];
    
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
