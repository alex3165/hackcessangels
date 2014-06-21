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


-(void)buttonAuditif:(id)sender {
    _auditifSelected=1;
    _moteurSelected=0;
    _visionSelected=0;
     [self.handicapAuditif setBackgroundColor:[UIColor purpleColor]];
    [self.handicapMoteur setBackgroundColor:[UIColor clearColor]];
    [self.handicapVisuel setBackgroundColor:[UIColor clearColor]];

    [self.handicapMoteur setFrame:CGRectMake(self.handicapMoteur.frame.origin.x, self.handicapMoteur.frame.origin.y +50, self.handicapMoteur.frame.size.width, self.handicapMoteur.frame.size.height)];
    
    [self.handicapVisuel setFrame:CGRectMake(self.handicapVisuel.frame.origin.x, self.handicapVisuel.frame.origin.y +50, self.handicapVisuel.frame.size.width, self.handicapVisuel.frame.size.height)];
    
    
    _items =[[NSArray alloc]initWithObjects:@"Je préfère recevoir un SMS",@"Je peux recevoir un appel",nil];
    

    //_pickerView.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
    
    _pickerView.delegate = self;
    
    _pickerView.dataSource = self;
    
    _pickerView.showsSelectionIndicator = YES;
    
    _pickerView.backgroundColor = [UIColor clearColor];
    
    [_pickerView selectRow:1 inComponent:0 animated:YES];
    self.pickerView.hidden=false;

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_auditifSelected){
        
        return 2;
    }
    if (_moteurSelected){
        
        return 3;
    }
    
    if (_visionSelected){
        
        return 2;
    }
    else {
        return 0;
        
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    
    return [_items objectAtIndex:row];
    
    
}


-(void)buttonVision:(id)sender {
    
    
    _auditifSelected=0;
    _moteurSelected=0;
    _visionSelected=1;
       [self.handicapVisuel setBackgroundColor:[UIColor purpleColor]];
    [self.handicapMoteur setBackgroundColor:[UIColor whiteColor]];
    [self.handicapAuditif setBackgroundColor:[UIColor whiteColor]];
    UIPickerView *pickerViewVision;
    
    _items =[[NSArray alloc]initWithObjects:@"Je suis malvoyante",@"Je suis aveugle",nil];
    
    _pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0,100,self.view2.frame.size.width,self.view2.frame.size.height - 100)];
    
    _pickerView.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
    
    _pickerView.delegate = self;
    
    _pickerView.dataSource = self;
    
    _pickerView.showsSelectionIndicator = YES;
    
    _pickerView.backgroundColor = [UIColor clearColor];
    
    [_pickerView selectRow:1 inComponent:0 animated:YES];

        self.pickerView.hidden=false;
    
    
    
}

-(void)buttonMoteur:(id)sender{
    
    _auditifSelected=0;
    _moteurSelected=1;
    _visionSelected=0;
      [self.handicapMoteur setBackgroundColor:[UIColor purpleColor]];
    [self.handicapVisuel setBackgroundColor:[UIColor whiteColor]];
      [self.handicapAuditif setBackgroundColor:[UIColor whiteColor]];
    
    _items =[[NSArray alloc]initWithObjects:@"Fauteuil roulant manuel",@"Fauteuil roulant électrique",@"Difficultés de marche",nil];
    
    _pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0,100,self.view2.frame.size.width,self.view2.frame.size.height - 100)];
    
    _pickerView.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
    
    _pickerView.delegate = self;
    
    _pickerView.dataSource = self;
    
    _pickerView.showsSelectionIndicator = YES;
    
    _pickerView.backgroundColor = [UIColor clearColor];
    
    [_pickerView selectRow:1 inComponent:0 animated:YES];
          self.pickerView.hidden=false;
}



-(void) setUserHandicap {

        [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user)  {
            
            if (_auditifSelected){
                
                int res=[_pickerView selectedRowInComponent:0];
                
                user.disabilityType= 6 + res;
 
            }
            else if (self.handicapCognitif.isSelected){
                
                [self.handicapCognitif setBackgroundColor:[UIColor purpleColor]];
                user.disabilityType=Mental;
                
            }
            else if (_visionSelected){
             
               
                int res=[_pickerView selectedRowInComponent:0];
                
                user.disabilityType= 4 + res;
                
            }
            else if (_moteurSelected){
              
                int res=[_pickerView selectedRowInComponent:0];
                
                user.disabilityType= 1 + res;
                
            }
            else {
                
             
                user.disabilityType=Other;
                
            }
            
            
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
       [self setUserHandicap];

    
}

- (IBAction)button3:(id)sender  {
    [self setUserHandicapInfos];

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
            
          user.image =  UIImageJPEGRepresentation(self.image.image, 0.90);
            
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
    [self view1];
}




- (IBAction)saisieReturn:(id)sender {
    
    [sender resignFirstResponder];
}





@end
