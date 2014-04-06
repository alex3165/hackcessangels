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

@property (nonatomic, strong) NSString * textEmail;
@property (nonatomic, strong) NSString * textName;
@property (nonatomic, strong) NSString * textDescription;

@end

@implementation HAUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self navigationController] setNavigationBarHidden:NO];
    }
    return self;
}
- (IBAction)onBackButtonUp:(id)sender {
}

- (IBAction)saisieReturn:(id)sender {
    
    [sender resignFirstResponder];
}

- (IBAction)touchOutside:(id)sender {
    
    [sender resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UITextField appearance] setFont:[UIFont fontWithName:@"Times" size:16]];
    
    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
        self.emailLabel.text = user.email;
        self.nameTextInput.text = user.name;
        self.descriptionTextInput.text= user.description;
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)saveAndDismiss:(id)sender {
    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
        user.name = self.nameTextInput.text;
        user.description = self.descriptionTextInput.text;
        user.password = self.passwordTextInput.text;
        
        [[HAUserService sharedInstance] updateUser:user success:^(HAUser* user) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Bravo" message:@"Profil édité" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
            [[self navigationController] popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Profil non édité" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }];
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];
}


@end
