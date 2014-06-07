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
        
         switch (user.disabilityType) {
             case Physical_wheelchair:
                 self.handicapInfos.text=@"Handicap moteur. Je suis en chaise roulante";
             break;
             case    Physical_powerchair:
                 self.handicapInfos.text=@" Handicap moteur. Je suis en chaise électrique";
             break;
             case  Physical_walk:
                 self.handicapInfos.text=@"Handicap moteur. J'ai des problèmes de marche.";
             break;
             case   Vision_blind :
                 self.handicapInfos.text=@"Handicap visuel. Je suis aveugle.";
              break;
             case   Vision_lowvision:
                 self.handicapInfos.text=@"Handicap visuel. J'ai une mauvaise vue";
              break;


             case Hearing_call:
                 self.handicapInfos.text=@"Handicap auditif. Je répond aux appels.";
                 break;
             case   Hearing_SMS:self.handicapInfos.text=@"Handicap auditif. Je répond aux sms.";
             
            break;
         case   Mental:
                 self.handicapInfos.text=@"Handicap Mental";
         break;
         case   Other :
                 self.handicapInfos.text=@"Handicap Autre";
         break;
         case Unknown:
                 self.handicapInfos.text=@" PAS de Handicap.";
         break;
         }
        
        
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