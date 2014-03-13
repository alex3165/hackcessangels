//
//  HAUserViewController.m
//  hackcessangels
//
//  Created by Mac on 06/03/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAUserViewController.h"
#import "HAUserService.h"
#import "HAUser.h"

@interface HAUserViewController ()

@property (nonatomic, strong) NSString * textLogin;
@property (nonatomic, strong) NSString * textEmail;
@property (nonatomic, strong) NSString * textPassword;

@end

@implementation HAUserViewController

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
    [[UITextField appearance] setFont:[UIFont fontWithName:@"Times" size:16]];
    
     HAUser *userActual = [HAUser userFromKeyChain];
    //self.showLogin.text= userActual.login;
    self.showEmail.text= userActual.email;
    self.showPassword.text= userActual.password;
    //[self.showLogin setFont:[UIFont fontWithName:@"Helvetica" size:16]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)editUser:(id)sender {
    
    self.editUser = [[HAUserService alloc]init];
    
    HAUser *userActual = [HAUser userFromKeyChain];
    
    [self.editUser updateUser:userActual.email withUpdatedEmail:self.showEmail.text password:userActual.password withUpdatedPassword:self.showPassword.text success:^(id obj, id obj2) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Bravo" message:@"Profil édité" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Profil  non édité" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];
}
     

- (IBAction)saisieReturn:(id)sender {
    
    [sender resignFirstResponder];
}

- (IBAction)touchOutside:(id)sender {
    
    [sender resignFirstResponder];
}




@end
