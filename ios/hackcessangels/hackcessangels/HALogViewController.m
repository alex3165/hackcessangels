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
    
    [self checkLoginWithUser]; // on check si on a un user de stocké
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
    [_login resignFirstResponder];
    [_password resignFirstResponder];
    
}

- (IBAction)validateForm:(id)sender
{
    // On fait la requête pour vérifier si le user enregistré sur le serveur est bon.
    [self.userService loginWithEmailAndPassword:self.login.text password:self.password.text success:^(NSDictionary *dico){
        
        NSDictionary *userSetting = [NSDictionary dictionaryWithObjectsAndKeys:@"email",self.login.text,@"password",self.password.text, nil];
        
        /* On créer le User et on le sage */
        self.actualUser = [[HAUser alloc] initWithDictionary:userSetting];
        [self.actualUser saveUserToKeyChain];
        
        [self checkLoginWithUser]; // ----- check du User créé
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)checkLoginWithUser{
    
    // on récupère le user stocké dans keychainStore
    HAUser *UserFromKeychain = [HAUser userFromKeyChain];
    
    if (UserFromKeychain != Nil) { // si on a un user on push vers l'autre view
        [self.navigationController pushViewController:self.helpController animated:true];
    }

}

@end
