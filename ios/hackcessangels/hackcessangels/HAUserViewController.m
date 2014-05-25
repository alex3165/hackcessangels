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
    } failure:^(NSError *error) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }];
    
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(takePicture:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [tapRecognizer setDelegate:self];
    
    self.image.userInteractionEnabled = YES;    [self.image addGestureRecognizer:tapRecognizer];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [self.scroll setScrollEnabled:YES];
    self.scroll.contentSize =CGSizeMake(320, 1100);
    [super viewDidAppear:animated];
}

-(void) takePicture:(id) sender
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
        user.image = UIImageJPEGRepresentation(self.image.image, 0.90);
        
        //user.image = self.image.image.CIImage;
        
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

int i;
- (IBAction)moteur:(id)sender {
    
    _buttonFauteil.backgroundColor=[UIColor colorWithRed:255 green:0 blue:0 alpha:1];
     _buttonCognitif.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalVoyant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalEntendant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonAutre.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSLog(@"MOTEUR");
    i=0;
    [self.view addSubview:self.pickerView];
    
}
- (IBAction)cognitif:(id)sender {
     _buttonCognitif.backgroundColor=[UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    _buttonFauteil.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalVoyant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalEntendant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonAutre.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSLog(@"COGNITIF");
    
}

- (IBAction)visuel:(id)sender {
     _buttonMalVoyant.backgroundColor=[UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    _buttonCognitif.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonFauteil.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalEntendant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonAutre.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSLog(@"VISUEL");
    i=1;
}

- (IBAction)auditif:(id)sender {
     _buttonMalEntendant.backgroundColor=[UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    _buttonCognitif.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalVoyant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonFauteil.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonAutre.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSLog(@"AUDITIF");
    i=2;

}

- (IBAction)autre:(id)sender {
    _buttonAutre.backgroundColor=[UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    _buttonFauteil.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonCognitif.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonMalVoyant.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    _buttonFauteil.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSLog(@"AUTRE");
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (i==0 || i==2){ return 2;}
    if (i==1){ return 3;}
    else{
        return 0;}
}

- (NSString *)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableArray *timersArray = [[NSMutableArray alloc] init];
    
    if(i==0){
        [timersArray addObject:@"Mal-voyant"];
        [timersArray addObject:@"Aveugle"];
    
    }
    
    if(i==1){
        [timersArray addObject:@"Fauteuil roulant manuel"];
        [timersArray addObject:@"Fauteuil électrique"];
        [timersArray addObject:@"Difficultés de marche"];
        
    }

    if(i==2){
    [timersArray addObject:@"Je peux recevoir un appel"];
        [timersArray addObject:@"Je préfère recevoir un sms"];}

    return [timersArray objectAtIndex:row];
}



@end
