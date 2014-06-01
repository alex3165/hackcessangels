//
//  EIUserProfilSendViewController.m
//  hackcessangels
//
//  Created by Mac on 28/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "EIUserProfilViewController.h"
#import "HAUserViewController.h"

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
    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
        
        //TOP LABEL
        self.nom.text = user.name;
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
        /*
         switch (user.disabilityType) {
         case Physical_wheelchair:[self.handicapInfos.text=@"Je suis en chaise roulante"]
         case    Physical_powerchair:[self.handicapInfos.text=@"Je suis en chaise électrique"]
         case  Physical_walk:[self.handicapInfos.text=@"J'ai des problèmes de marche."]
         [self.handicap.text=@"Handicap moteur"];
         break;
         case   Vision_blind :[self.handicapInfos.text=@"Je suis aveugle."]
         case   Vision_lowvision:[self.handicapInfos.text=@"J'ai une mauvaise vue"]
         [self.handicap.text=@"Handicap visuel"];
         break;
         case Hearing_call:[self.handicapInfos.text=@"Je répond aux appels."]
         case   Hearing_SMS:[self.handicapInfos.text=@"Je répond aux sms."]
         [self.handicap.text=@"Handicap auditif"]
         break;
         case   Mental:
         [self.handicap.text=@"Handicap Mental"]
         break;
         case   Other :
         [self.handicap.text=@"Handicap Autre"]
         break;
         case Unknown:
         break;
         }*/
        
        
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)modifier:(id)sender  {
    
    HAUserViewController *modifyProfilViewController = [[UIStoryboard storyboardWithName:@"modifyUserProfil" bundle:nil] instantiateViewControllerWithIdentifier:@"accesViewController"];
    [self presentViewController:modifyProfilViewController animated:NO completion:nil];
}

@end