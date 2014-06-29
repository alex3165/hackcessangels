//
//  EIUserProfilSendViewController.m
//  hackcessangels
//
//  Created by Mac on 28/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "EIUserProfilViewController.h"
#import "HAFirstProfilViewController.h"
@interface EIUserProfilViewController ()

@end

@implementation EIUserProfilViewController

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
    
    //self.modifier.layer.borderWidth = 0.5f;
    self.modifier.layer.cornerRadius = 5;
    
    
}

- (void) viewDidAppear:(BOOL)animated {

        [self.scroll setScrollEnabled:YES];
        self.scroll.contentSize =CGSizeMake(320, 1100);

    [super viewDidAppear:animated];
    
    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
        self.user=user;
        //TOP LABEL
        self.nomPrenom.text = user.name;
        
        self.image.layer.cornerRadius = self.image.frame.size.height /2;
        self.image.layer.masksToBounds = YES;
        self.image.layer.borderWidth = 0;
        self.image.image = [[UIImage alloc] initWithData:user.image];
        
        
        //mes numéros
        self.phone.text=user.phone;
        self.urgencePhone.text=user.phoneUrgence;
        
        
        //ma situtation
        
        
        self.handicapAutre.text=user.disability;
        
        //infos complémentaires
        self.infos.text= user.description;
        
        //faire un enum
        //  self.handicap=user.disabilityType;
        // TODO(etienne): Where to display custom string for "other" disability type?
        self.handicapInfos.text = [user getDisabilityString];
        
        
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUserInfos : (HAUser*)user {
    

    
}

-(IBAction)disconnect:(id)sender {
    [[HAUserService sharedInstance] disconnectUser];
    [[self navigationController] popViewControllerAnimated:YES];
}

-(IBAction)modifyProfil:(id)sender{

    [self performSegueWithIdentifier:@"modifyUserProfil" sender:self];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"modifyUserProfil"])
    {
        // Get reference to the destination view controller
        HAFirstProfilViewController *modifyprofil = [segue destinationViewController];
        modifyprofil.user=self.user;


    }
}

@end