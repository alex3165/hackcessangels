//
//  HAAgentViewController.m
//  hackcessangels
//
//  Created by Mac on 24/04/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAAgentViewController.h"

@interface HAAgentViewController ()


@property (nonatomic, strong) NSString * textName;
@property (nonatomic, strong) NSString * textGare;
@property (nonatomic, strong) NSString * textNumero;



@end

@implementation HAAgentViewController

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
    {
        [super viewDidLoad];
        [[UITextField appearance] setFont:[UIFont fontWithName:@"Times" size:16]];
        //self.automaticallyAdjustsScrollViewInsets = NO;
        [[HAAgentService sharedInstance] getCurrentAgent:^(HAAgent *agent) {
            
            self.nameTextInput.text = agent.name;
            self.numeroTextInput.text=agent.phone;
            self.image.image = [[UIImage alloc] initWithData:agent.image];
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
        self.scroll.contentSize =CGSizeMake(320, 800);
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
        [[HAAgentService sharedInstance] getCurrentAgent:^(HAAgent *agent) {
            agent.name = self.nameTextInput.text;
            agent.password = self.passwordTextInput.text;
            agent.phone = self.numeroTextInput.text;
            agent.image = UIImageJPEGRepresentation(self.image.image, 0.90);
            
            //user.image = self.image.image.CIImage;
            
            [[HAAgentService sharedInstance] updateAgent:agent success:^(HAAgent* agent) {
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
    
    


@end
