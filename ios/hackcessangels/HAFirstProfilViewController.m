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
    [self viewInit];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setUserNameAndPhone {
    [self.view addSubview:self.view1];

    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
      
        [[HAUserService sharedInstance] updateUser:user success:^(HAUser* user) {
            
            self.nomPrenom.text = user.name;
            //mes numéros
            self.phone.text=user.phone;
            self.urgencePhone.text=user.phoneUrgence;
            
            
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

-(void) setUserHandicap {

        [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user)  {
            [[HAUserService sharedInstance] updateUser:user success:^(HAUser* user) {
                
            
            if (self.handicapAuditif.isSelected){
            user.disabilityType=Hearing_call;
            
            UIPickerView *pickerAuditif;
            [self.handicapAuditif setBackgroundColor:[UIColor purpleColor]];
            //[pickerAuditif setFrame:CGRectMake(self.view2.frame.size.width/2, 0, self.view2.frame.size.width/2, self.view2.frame.size.height/2)];
        }
        else if (self.handicapCognitif.isSelected){
            
            [self.handicapCognitif setBackgroundColor:[UIColor purpleColor]];
            user.disabilityType=Mental;
            
        }
        else if (self.handicapVisuel.isSelected){
            [self.handicapVisuel setBackgroundColor:[UIColor purpleColor]];
            UIPickerView *pickerVisuel;
            
           // [pickerVisuel setFrame:CGRectMake(self.view2.frame.size.width/2, 0, self.view2.frame.size.width/2, self.view2.frame.size.height/2)];
            user.disabilityType=Vision_blind;
            
        }
        else if (self.handicapMoteur.isSelected){
            [self.handicapMoteur setBackgroundColor:[UIColor purpleColor]];
           // UIPickerView *pickerMoteur;
            
           // [pickerMoteur setFrame:CGRectMake(self.view2.frame.size.width/2, 0, self.view2.frame.size.width/2, self.view2.frame.size.height/2)];

        }
        else {
            
            [self.handicapAutre setBackgroundColor:[UIColor purpleColor]];
             user.disabilityType=Other;
        
        }
 
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
        
     
        [[HAUserService sharedInstance] updateUser:user success:^(HAUser* user) {
            
               self.handicapInfos.text=user.description;
            
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



-(void) createUserAndLog {

    HAUserService *userService = [[HAUserService alloc] init];
    
    [userService createUserWithEmailAndPassword:self.mail.text password:self.password.text success:^(id obj, id obj2){
        
        [userService loginWithEmailAndPassword:self.mail.text password:self.password.text success:^(id obj, id obj2){
            
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
    [self.viewLog removeFromSuperview];
    [self.view addSubview:self.view1];
    
    
}

- (IBAction)button12:(id)sender  {
    [self setUserNameAndPhone];
    [self.view1 removeFromSuperview];
    [self.view addSubview:self.view2];

}

- (IBAction)button2:(id)sender  {
       [self setUserHandicap];
     [self.view2 removeFromSuperview];
    [self.view addSubview:self.view3];
    
}

- (IBAction)button3:(id)sender  {
    [self setUserHandicapInfos];
    [self.view3 removeFromSuperview];
    [self.view addSubview:self.view4];
    
}

- (IBAction)buttonPhoto:(id)sender  {

    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choisir une photo"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Appareil-photo",@"Bibliothèque", nil];
    [actionSheet showInView:self.view];
}



- (void) actionSheet: (UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0)
        [self takeAPicture];
    else
        [self takePictureFromLibrary];
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
            
           
            [[HAUserService sharedInstance] updateUser:user success:^(HAUser* user) {
                 self.image.image = [[UIImage alloc] initWithData:user.image];
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
    [self view1];
}




- (IBAction)saisieReturn:(id)sender {
    
    [sender resignFirstResponder];
}


@end
