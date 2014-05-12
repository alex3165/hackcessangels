//
//  HALogViewController.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 23/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HALogViewController.h"
#import "HAHelpViewController.h"
#import "UIColor+HackcessAngels.h"

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
	
    self.userService = [HAUserService sharedInstance];
    self.helpController = [[HAHelpViewController alloc]init];
    
    [self checkLoginWithUser]; // on check si on a un user de stocké
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor HA_angelGray];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_email resignFirstResponder];
    [_password resignFirstResponder];
    
}

- (IBAction)validateForm:(id)sender
{
    // On fait la requête pour vérifier si le user enregistré sur le serveur est bon.
    [self.userService loginWithEmailAndPassword:self.email.text password:self.password.text success:^(NSDictionary *dico, id obj){
        [self checkLoginWithUser]; // ----- check du User créé
        
    } failure:^(id obj, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)checkLoginWithUser{
    
    // on récupère le user stocké dans keychainStore
    HAUser *userFromKeychain = [HAUser userFromKeyChain];
    
    if (userFromKeychain) { // si on a un user on push vers l'autre view
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

@end
