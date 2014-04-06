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
    
    HAUser *userActual = [HAUser userFromKeyChain];
    self.emailLabel.text = userActual.email;
    self.nameTextInput.text = userActual.name;
    self.descriptionTextInput.text= userActual.userdescription;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)saveAndDismiss:(id)sender {
    self.editUser = [[HAUserService alloc]init];
    
    HAUser *userActual = [HAUser userFromKeyChain];
    
    [self.editUser updateUser:userActual success:^(HAUser* user) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Bravo" message:@"Profil édité" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        [[self navigationController] popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Profil non édité" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];
}


@end
