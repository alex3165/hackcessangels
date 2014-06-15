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
    [self view1];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewone {
    [self.view addSubview:self.view1];
    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
        
        self.nomPrenom.text = user.name;
        //mes numéros
        self.phone.text=user.phone;
        self.urgencePhone.text=user.phoneUrgence;
        
        
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];


}

-(void) viewtwo {


        [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user)  {
        
            if (self.handicapAuditif.isSelected){
            //user.disabilityType=Hearing_call;
            UIPickerView *pickerAuditif;
            [self.handicapAuditif setBackgroundColor:[UIColor purpleColor]];
            [pickerAuditif setFrame:CGRectMake(self.view2.frame.size.width/2, 0, self.view2.frame.size.width/2, self.view2.frame.size.height/2)];
            
        
        }
        else if (self.handicapCognitif.isSelected){
            
            [self.handicapCognitif setBackgroundColor:[UIColor purpleColor]];
            user.disabilityType=Mental;
            
        }
        else if (self.handicapVisuel.isSelected){
            [self.handicapVisuel setBackgroundColor:[UIColor purpleColor]];
            UIPickerView *pickerVisuel;
            
            [pickerVisuel setFrame:CGRectMake(self.view2.frame.size.width/2, 0, self.view2.frame.size.width/2, self.view2.frame.size.height/2)];
           // user.disabilityType=vi
            
        }
        else if (self.handicapMoteur.isSelected){
            [self.handicapMoteur setBackgroundColor:[UIColor purpleColor]];
            UIPickerView *pickerMoteur;
            
            [pickerMoteur setFrame:CGRectMake(self.view2.frame.size.width/2, 0, self.view2.frame.size.width/2, self.view2.frame.size.height/2)];
            
            
            
        }
        else {
            
            [self.handicapAutre setBackgroundColor:[UIColor purpleColor]];
             user.disabilityType=Other;
        
        }
        
        
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];
    
    
    
}

-(void) viewthree {

    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
        
        self.handicapInfos=user.description;
        
        
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];
    

    
}

- (IBAction)button1:(id)sender  {
   // [self.view1 removeFromSuperview];
    [self.view addSubview:self.view1];
    [self view2];
    
}

- (IBAction)button12:(id)sender  {
    [self.view1 removeFromSuperview];
    [self.view addSubview:self.view2];
    [self view2];
    
}

- (IBAction)button2:(id)sender  {
     [self.view2 removeFromSuperview];
    [self.view addSubview:self.view3];
        [self view3];
}

- (IBAction)button3:(id)sender  {
    [self.view3 removeFromSuperview];
    [self.view addSubview:self.view4];
      [self view4];
}

- (IBAction)buttonPhoto:(id)sender  {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    
    
    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
        //self.image.image = [[UIImage alloc] initWithData:user.image];
        
        
        
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];

    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.image setImage:image];
    [self dismissModalViewControllerAnimated:YES];
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
