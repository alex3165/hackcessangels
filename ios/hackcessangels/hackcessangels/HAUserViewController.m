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
#import "HALogViewController.h"

@interface HAUserViewController ()

@property (nonatomic, strong) NSString * textEmail;
@property (nonatomic, strong) NSString * textName;
@property (nonatomic, strong) NSString * textDescription;
@property (nonatomic, strong) NSString * textNumero;
@property (nonatomic, assign) enum HAUserDisability disabilityType;
@end

@implementation HAUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
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
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
        self.emailLabel.text = user.email;
        self.nameTextInput.text = user.name;
        self.descriptionTextInput.text= user.description;
        self.numeroTextInput.text=user.phone;
        self.image.image = [[UIImage alloc] initWithData:user.image];
        self.handicapAutre.text=user.disability;
        self.disabilityType=user.disabilityType;
        switch (self.disabilityType) {
            case Physical_wheelchair:
            case    Physical_powerchair:
            case  Physical_walk:
                [self moteur:nil];
                break;
            case   Vision_blind :
            case   Vision_lowvision:
                [self visuel:nil];
                break;
            case Hearing_call:
            case   Hearing_SMS:
                [self auditif:nil];
                break;
            case   Mental:
                [self cognitif:nil];
                break;
            case   Other :
                [self autre:nil];
                break;
            case Unknown:
                break;
        }
        
        
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];
    
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(takePicture:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [tapRecognizer setDelegate:self];
    
    self.image.userInteractionEnabled = YES;    [self.image addGestureRecognizer:tapRecognizer];
    
    self.pickerView.hidden=true;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.scroll setScrollEnabled:YES];
    self.scroll.contentSize =CGSizeMake(320, 1100);
    [super viewDidAppear:animated];
}

-(IBAction) takePicture:(id) sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [imagePicker setDelegate:self];
    
    [self presentModalViewController:imagePicker animated:YES];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.image setImage:image];
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)saveAndDismiss:(id)sender {
    [[HAUserService sharedInstance] getCurrentUser:^(HAUser *user) {
        user.name = self.nameTextInput.text;
        user.description = self.descriptionTextInput.text;
        user.password = self.passwordTextInput.text;
        user.phone = self.numeroTextInput.text;
        if (i==kAutre){
            user.disability=self.handicapAutre.text;}
        else {
            user.disability=nil;
        }

        user.image = UIImageJPEGRepresentation(self.image.image, 0.90);
        
        //user.image = self.image.image.CIImage;
        switch (i) {
            case kAuditif:
                if ([self.pickerView selectedRowInComponent:0]==0){
                
                    self.disabilityType=Hearing_call;
                }
                else {
                    self.disabilityType=Hearing_SMS;
                }
                break;
            case kMoteur:
                if ([self.pickerView selectedRowInComponent:0]==0){
                    
                    self.disabilityType=Physical_wheelchair;
                }
                else if ([self.pickerView selectedRowInComponent:0]==1){
                    
                    self.disabilityType=Physical_powerchair;
                }
                else {
                    self.disabilityType=Physical_walk;
                }
                break;
            case kVisuel:
                if ([self.pickerView selectedRowInComponent:0]==0){
                    
                    self.disabilityType=Vision_lowvision;
                }
                else {
                    self.disabilityType=Vision_blind;
                }
                break;
                
                
                
                
            default:
                break;
        }
        
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

HAUserSimpleDisability i;

- (IBAction)moteur:(id)sender {
    
    _buttonFauteil.backgroundColor=[UIColor colorWithRed:255 green:0 blue:0 alpha:1];
     _buttonCognitif.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalVoyant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalEntendant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonAutre.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSLog(@"MOTEUR");
    if (i!=kMoteur){
        self.pickerView.hidden=false;
    }
    else { [self pickerDoneClicked];}
    i=kMoteur;
    
    [self.pickerView reloadAllComponents];
    
    if (self.disabilityType==Physical_wheelchair){
        [self.pickerView selectRow:0 inComponent:0 animated:NO];}
    else if (self.disabilityType==Physical_powerchair){
        [self.pickerView selectRow:1 inComponent:0 animated:NO];}
    else{
        [self.pickerView selectRow:2 inComponent:0 animated:NO];}
    
    
}
- (IBAction)cognitif:(id)sender {
     _buttonCognitif.backgroundColor=[UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    _buttonFauteil.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalVoyant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalEntendant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonAutre.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSLog(@"COGNITIF");
    self.pickerView.hidden=true;
    i=kCognitif;
    
}

- (IBAction)visuel:(id)sender {
     _buttonMalVoyant.backgroundColor=[UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    _buttonCognitif.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonFauteil.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalEntendant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonAutre.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSLog(@"VISUEL");
    if (i!=kVisuel){
        self.pickerView.hidden=false;
    }
    else { [self pickerDoneClicked];}

    i=kVisuel;
    [self.pickerView reloadAllComponents];
    
    if (self.disabilityType==Vision_lowvision){
        [self.pickerView selectRow:0 inComponent:0 animated:NO];}
    
    else{
        [self.pickerView selectRow:1 inComponent:0 animated:NO];}

}

- (IBAction)auditif:(id)sender {
     _buttonMalEntendant.backgroundColor=[UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    _buttonCognitif.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalVoyant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonFauteil.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonAutre.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSLog(@"AUDITIF");
    if (i!=kAuditif){
        self.pickerView.hidden=false;
    }
    else { [self pickerDoneClicked];}
    i=kAuditif;
    [self.pickerView reloadAllComponents];
    
    if (self.disabilityType==Hearing_call){
        [self.pickerView selectRow:0 inComponent:0 animated:NO];}
    
    else{
        [self.pickerView selectRow:1 inComponent:0 animated:NO];}

    
}

- (IBAction)autre:(id)sender {
    _buttonAutre.backgroundColor=[UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    _buttonFauteil.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonCognitif.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalVoyant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonFauteil.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSLog(@"AUTRE");
    self.pickerView.hidden=true;
    i=kAutre;
   
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (i==kAuditif || i==kVisuel){ return 2;}
    else if (i==kMoteur){ return 3;}
    else{
        return 0;}
}

- (NSString *)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableArray *timersArray = [[NSMutableArray alloc] init];
    
    switch (i) {
        case kAuditif:
            [timersArray addObject:@"Je peux recevoir un appel"];
            [timersArray addObject:@"Je préfère recevoir un sms"];
           
            break;
        case kMoteur:
            [timersArray addObject:@"Fauteuil roulant manuel"];
            [timersArray addObject:@"Fauteuil électrique"];
            [timersArray addObject:@"Difficultés de marche"];
            break;
        case kVisuel:
            [timersArray addObject:@"Mal-voyant"];
            [timersArray addObject:@"Aveugle"];
            break;
            
        default:
            break;
    }
    return [timersArray objectAtIndex:row];
    
}

-(void) pickerDoneClicked{
    
    self.pickerView.hidden=!self.pickerView.hidden;
}

@end
