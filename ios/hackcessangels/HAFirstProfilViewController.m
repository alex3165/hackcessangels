//
//  HAFirstProfilViewController.m
//  hackcessangels
//
//  Created by Mac on 09/06/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAFirstProfilViewController.h"
#import "HAUserService.h"
#import "HARestRequests.h"
#import "HARequestsService.h"
#import "HALogViewController.h"
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.user!=nil) {
        [self.viewLog removeFromSuperview];
        [self.viewInit removeFromSuperview];
        
        self.nomPrenom.text = self.user.name;
        self.phone.text=self.user.phone;
        self.urgencePhone.text=self.user.phoneUrgence;
        self.handicapInfos.text=self.user.description;
        self.handicapAutre.text=self.user.disability;
        
        NSLog(@"%u HANDICAP", self.user.disabilityType );
        
        if (self.user.disabilityType==Physical_powerchair || self.user.disabilityType==Physical_walk || self.user.disabilityType==Physical_wheelchair) {
            [self.handicapMoteur setBackgroundColor:[UIColor purpleColor]];
        }
        else if (self.user.disabilityType==Vision_blind || self.user.disabilityType==Vision_lowvision) {
            [self.handicapVisuel setBackgroundColor:[UIColor purpleColor]];
        }
        else if (self.user.disabilityType==Hearing_SMS || self.user.disabilityType==Hearing_call  ) {
            [self.handicapAuditif setBackgroundColor:[UIColor purpleColor]];
        }
        else if (self.user.disabilityType==Mental) {
            [self.handicapCognitif setBackgroundColor:[UIColor purpleColor]];
        }
        else if (self.user.disabilityType==Other) {
            // Nothing here: it's already been set above.
        }
        
        NSLog(@"%hhd", _modifyLoggedTransfer);
        NSLog(@"%@", _nomPrenom.text);
        NSLog(@"%@", _phone.text);
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// End of second page of tutorial
-(void) setUserNameAndPhone {
    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
        
        user.name=self.nomPrenom.text;
        //mes numéros
        user.phone=self.phone.text;
        user.phoneUrgence=self.urgencePhone.text;
        
        [[HAUserService sharedInstance] updateUser:user success:^(HAUser* user) {
            self.view1.hidden=YES;
            self.view2.hidden=NO;
            
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
    
    [self.handicapCognitif setBackgroundColor:[UIColor whiteColor]];
    [self.handicapVisuel setBackgroundColor:[UIColor whiteColor]];
    [self.handicapMoteur setBackgroundColor:[UIColor whiteColor]];
    [self.handicapAuditif setBackgroundColor:[UIColor purpleColor]];
    
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
    
    [self.handicapCognitif setBackgroundColor:[UIColor whiteColor]];
    [self.handicapVisuel setBackgroundColor:[UIColor purpleColor]];
    [self.handicapMoteur setBackgroundColor:[UIColor whiteColor]];
    [self.handicapAuditif setBackgroundColor:[UIColor whiteColor]];
    
    _actionSheetVision = [[UIActionSheet alloc] initWithTitle:@"Handicap Auditif"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Je suis malvoyant(e)",@"Je suis aveugle", nil];
    [_actionSheetVision showInView:self.view];
    

    
}

-(void)buttonMoteur:(id)sender{
    _auditifSelected=0;
    _moteurSelected=1;
    _visionSelected=0;

    [self.handicapCognitif setBackgroundColor:[UIColor whiteColor]];
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

-(IBAction) buttonMental :(id) sender {
    [self setUserHandicap:Mental];
}

-(void) setUserHandicap :(HAUSerDisability)disability{
    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user)  {
        user.disability=_handicapAutre.text;
        user.disabilityType=disability;
        
        [[HAUserService sharedInstance] updateUser:user success:^(HAUser* user) {
            self.view2.hidden=YES;
            self.view3.hidden=NO;
            
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
            self.view3.hidden=YES;
            self.view4.hidden=NO;
            
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
            self.viewLog.hidden=YES;
            self.view1.hidden=NO;
            
        } failure:^(id obj, NSError *error) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];} ];
    } failure:^(id obj, NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    } ];
}

- (IBAction)buttonInit:(id)sender  {
     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Mentions Légales" message:@"Veuillez accepter les mentions légales" delegate:self cancelButtonTitle:@"Accepter" otherButtonTitles:@"Voir", @"Refuser", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Accepter"]) {
        NSLog(@"Button 1 was selected.");
        self.viewInit.hidden=YES;
        self.viewLog.hidden=NO;
    } else if ([title isEqualToString:@"Voir"]) {
        [self displayCGU:nil];
    } else if([title isEqualToString:@"Refuser"]) {
        [self.view addSubview:self.viewInit];
    }
    
}

// Next Step, from the first view (create user credentials)
- (IBAction)button1:(id)sender  {
    [self createUserAndLog];
}

// Next step, from the 2nd view (set user name and phones)
- (IBAction)button12:(id)sender  {
    [self setUserNameAndPhone];
}

// Next step, from the 3rd view (set user disability)
- (IBAction)button2:(id)sender  {
    [self setUserHandicap:Other];
}

// Next step, from the 4th view (set user description)
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

// Process a click on an action sheet. As we have 4 action sheets in this controller, we need to know which one it is before interpreting the click.
- (void) actionSheet: (UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet==_actionSheetPhoto) {
        if (buttonIndex == 0) {
            [self takeAPicture];
        } else {
            [self takePictureFromLibrary];
        }
    } else if ( actionSheet==_actionSheetVision ) {
        if (buttonIndex == 0) {
            [self setUserHandicap:Vision_lowvision];
        } else {
            [self setUserHandicap:Vision_blind];
        }
    } else if ( actionSheet==_actionSheetMoteur ) {
        if (buttonIndex == 0){
            [self setUserHandicap:Physical_wheelchair];
        }
        else if (buttonIndex == 1) {
            [self setUserHandicap:Physical_powerchair];
        } else {
            [self setUserHandicap:Physical_walk];
        }
    } else if ( actionSheet==_actionSheetAuditif ) {
        if (buttonIndex == 0) {
            [self setUserHandicap:Hearing_SMS];
        } else {
            [self setUserHandicap:Hearing_call];
        }
    }
}

-(void)takeAPicture{
    DLog(@"CHEESE");
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
    DLog(@"Jolie image ça");
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


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertView *alert;
    
    // Unable to save the image
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    }
    [alert show];
}

-(void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
            UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
          user.image =  UIImageJPEGRepresentation(pickedImage, 0.90);
            
            [[HAUserService sharedInstance] updateUser:user success:^(HAUser* user) {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Bravo" message:@"Profil édité" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
                if ([[self presentingViewController] class] == [HALogViewController class]) {
                    ((HALogViewController*)[self presentingViewController]).email.text = self.mail.text;
                     ((HALogViewController*)[self presentingViewController]).password.text = self.password.text;
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
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
    if ([[self presentingViewController] class] == [HALogViewController class]) {
        ((HALogViewController*)[self presentingViewController]).email.text = self.mail.text;
        ((HALogViewController*)[self presentingViewController]).password.text = self.password.text;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)backToInfos:(id)sender  {
    self.view4.hidden=YES;
    self.view3.hidden=NO;
}

- (IBAction)backToHandicap:(id)sender  {
    self.view3.hidden=YES;
    self.view2.hidden=NO;
}

- (IBAction)backToNom:(id)sender  {
    self.view2.hidden=YES;
    self.view1.hidden=NO;
}

- (IBAction)saisieReturn:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)displayCGU:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://aidegare.membrives.fr/static/cgu.html"]];
}

@end
