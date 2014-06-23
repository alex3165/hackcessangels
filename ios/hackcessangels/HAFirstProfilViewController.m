//
//  HAFirstProfilViewController.m
//  hackcessangels
//
//  Created by Mac on 09/06/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAFirstProfilViewController.h"
#import "HAUserViewController.h"
#import "HAUserService.h"
#import "HARestRequests.h"
#import "HARequestsService.h"

#import "HAUser.h"
@interface HAFirstProfilViewController ()

@end

@implementation HAFirstProfilViewController

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
    NSLog(@"%hhd", _modifyLoggedTransfer);
    if (self.modifyLoggedTransfer==1) {
        
        [self.view addSubview:_view1];
    }
    
    else {
    [self viewInit];
    }

    _frameAuditif = [_handicapAuditif frame];
    _frameVisuel = [_handicapVisuel frame];
    _frameMoteur = [_handicapMoteur frame];
    
    
    _frameAuditif.origin.y += 100;  // change the location
         _frameMoteur.origin.y += 100;
    _frameVisuel.origin.y += 100; // change the size
    
    
    [_handicapAuditif setFrame:_frameAuditif];
    [_handicapMoteur setFrame:_frameMoteur];
    [_handicapVisuel setFrame:_frameVisuel];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//méthode ac ha user qui remplit les champs


-(void) setUserNameAndPhone {


    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
        
        
        user.name=self.nomPrenom.text;
        //mes numéros
       user.phone=self.phone.text;
        user.phoneUrgence=self.urgencePhone.text;
      
        [[HAUserService sharedInstance] updateUser:user success:^(HAUser* user) {
            
 
            [self.view1 removeFromSuperview];
            [self.view addSubview:self.view2];

        } failure:^(NSError *error) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Profil non édité" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }];
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];
 

}


- (IBAction)buttonAuditif:(id)sender  {
    _auditifSelected=1;
    _moteurSelected=0;
    _visionSelected=0;
    _actionSheetAuditif = [[UIActionSheet alloc] initWithTitle:@"Handicap Auditif"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Je préfère recevoir un SMS",@"Je peux recevoir un appel", nil];
    [_actionSheetAuditif showInView:self.view];
}

-(void)buttonVision:(id)sender {

    _auditifSelected=0;
    _moteurSelected=0;
    _visionSelected=1;
    
    [self.handicapVisuel setBackgroundColor:[UIColor purpleColor]];
    [self.handicapMoteur setBackgroundColor:[UIColor whiteColor]];
    [self.handicapAuditif setBackgroundColor:[UIColor whiteColor]];
    _actionSheetVision = [[UIActionSheet alloc] initWithTitle:@"Handicap Auditif"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Je suis malvoyante",@"Je suis aveugle", nil];
    [_actionSheetVision showInView:self.view];
    

    
}

-(void)buttonMoteur:(id)sender{

    _auditifSelected=0;
    _moteurSelected=1;
    _visionSelected=0;
      [self.handicapMoteur setBackgroundColor:[UIColor purpleColor]];
    [self.handicapVisuel setBackgroundColor:[UIColor whiteColor]];
      [self.handicapAuditif setBackgroundColor:[UIColor whiteColor]];
    
    
    _actionSheetMoteur = [[UIActionSheet alloc] initWithTitle:@"Handicap Auditif"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Fauteuil roulant manuel",@"Fauteuil roulant électrique", @"Difficultés de marche", nil];
    
    
    [_actionSheetMoteur showInView:self.view];

}





-(void) setUserHandicap :(HAUSerDisability)disability{

        [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user)  {
            user.disabilityType=disability;
            user.disability=_handicapAutre.text;
            
            [[HAUserService sharedInstance] updateUser:user success:^(HAUser* user) {

                [self.view2 removeFromSuperview];
                [self.view addSubview:self.view3];
 
        } failure:^(NSError *error) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Profil non édité" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }];

        
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];
}


-(void) setUserHandicapInfos {

    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
          user.description=self.handicapInfos.text;
     
        [[HAUserService sharedInstance] updateUser:user success:^(HAUser* user) {
            
          
            [self.view3 removeFromSuperview];
            [self.view addSubview:self.view4];

        
        } failure:^(NSError *error) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Profil non édité" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }];
        
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];
    
    
    
}



-(void) createUserAndLog {

    HAUserService *userService = [[HAUserService alloc] init];
    
    [userService createUserWithEmailAndPassword:self.mail.text password:self.password.text success:^(id obj, id obj2){

        [userService loginWithEmailAndPassword:self.mail.text password:self.password.text success:^(id obj, id obj2){
            [self.viewLog removeFromSuperview];
            [self.view addSubview:self.view1];
        }
         
                                       failure:^(id obj, NSError *error) {
                                           
                                           UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                           [alert show];} ];

    } failure:^(id obj, NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
        
    } ];

}

- (IBAction)buttonInit:(id)sender  {
     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Mentions Légales" message:@"Veuillez accepter les mentions légales" delegate:self cancelButtonTitle:@"Accepter" otherButtonTitles:@"Refuser", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Accepter"])
    {
        NSLog(@"Button 1 was selected.");
        [self.viewInit removeFromSuperview];
        [self.view addSubview:self.viewLog];
    }
    else if([title isEqualToString:@"Refuser"])
    {
        [self.view addSubview:self.viewInit];
    }
    
}

- (IBAction)button1:(id)sender  {
    [self createUserAndLog];
}

- (IBAction)button12:(id)sender  {
    [self setUserNameAndPhone];


}

- (IBAction)button2:(id)sender  {
    [self setUserHandicap:Other];
    
    
}

- (IBAction)button3:(id)sender  {
    [self setUserHandicapInfos];

}

- (IBAction)buttonPhoto:(id)sender  {

    
    _actionSheetPhoto = [[UIActionSheet alloc] initWithTitle:@"Choisir une photo"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Appareil-photo",@"Bibliothèque", nil];
    [_actionSheetPhoto showInView:self.view];
}


-(IBAction) buttonMental :(id) sender {
    [self setUserHandicap:Mental];

}



- (void) actionSheet: (UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    
    
    
    if (actionSheet==_actionSheetPhoto) {
    if (buttonIndex == 0)
        [self takeAPicture];
    else
        [self takePictureFromLibrary]; }
    
    
    else if ( actionSheet==_actionSheetVision ) {
        if (buttonIndex == 0) {
            [self setUserHandicap:Vision_lowvision];}
        else{
              [self setUserHandicap:Vision_blind];
         }
    
    }
    else if ( actionSheet==_actionSheetMoteur ) {
       
        if (buttonIndex == 0){
            [self setUserHandicap:Physical_wheelchair];}
        else if (buttonIndex == 1)
           [self setUserHandicap:Physical_powerchair];
        else {
         [self setUserHandicap:Physical_walk];
        }
            
    }

    else if ( actionSheet==_actionSheetAuditif ) {
        if (buttonIndex == 0) {
            [self setUserHandicap:Hearing_SMS];}
        else{
            [self setUserHandicap:Hearing_call];
        }

    }
    
    
}




-(void)takeAPicture{
    NSLog(@"CHEESE");
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypeCamera;
    
    imagePicker.mediaTypes =
    @[(NSString *) kUTTypeImage];
    
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}



-(void)takePictureFromLibrary{
    NSLog(@"Jolie image ça");
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.mediaTypes =
    @[(NSString *) kUTTypeImage];
    
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    [alert show];
    
    
}

-(void)imagePickerController:
(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
            UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
          user.image =  UIImageJPEGRepresentation(pickedImage, 0.90);
            
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
        

    }];
}

- (IBAction)ignorePhoto:(id)sender  {
    
    //Allez sur la page d'accueil
}


- (IBAction)backToInfos:(id)sender  {
    
    [self.view4 removeFromSuperview];
    
    [self.view addSubview:self.view3];
    [self view3];
}

- (IBAction)backToHandicap:(id)sender  {
    
    [self.view3 removeFromSuperview];
    
    [self.view addSubview:self.view2];
    [self view2];
}

- (IBAction)backToNom:(id)sender  {
    
    [self.view2 removeFromSuperview];
    
    [self.view addSubview:self.view1];
   
}




- (IBAction)saisieReturn:(id)sender {
    
    [sender resignFirstResponder];
}





@end
