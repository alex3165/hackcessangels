//
//  HAAgentViewController.m
//  hackcessangels
//
//  Created by Mac on 24/04/2014.
//  Copyright (c) 2014 hackcessangels. All rights reserved.
//

#import "HAAgentViewController.h"
#import "HAAgentService.h"
#import "HAAgent.h"
#import "HACurrentStationService.h"

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
        [super viewDidLoad];
        self.image.layer.cornerRadius = self.image.frame.size.height /2;
        self.image.layer.masksToBounds = YES;
        self.image.layer.borderWidth = 0;
        //self.automaticallyAdjustsScrollViewInsets = NO;
        [[HAAgentService sharedInstance] getCurrentAgent:^(HAAgent *agent) {
            
            self.gareLabel.text = agent.gare;
            self.numAgentLabel.text = agent.sncfId;
            self.nameLabel.text = agent.name;
            
            self.nameTextInput.text = agent.name;
            self.gareTextInput.text = agent.gare;
            self.numeroTextInput.text = agent.sncfId;
            
            self.image.image = [[UIImage alloc] initWithData:agent.image];
            
        } failure:^(NSError *error) {

            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Serveur injoignable" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];

        }];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(takePicture:)];
        [tapRecognizer setNumberOfTouchesRequired:1];
        [tapRecognizer setDelegate:self];
    
        //self.image.agentInteractionEnabled = YES;    [self.image addGestureRecognizer:tapRecognizer];
}

- (IBAction)saisieReturn:(id)sender {
    [sender resignFirstResponder];
}

-(void) takePicture:(id) sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.image setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAndDismiss:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)editProfil:(id)sender {
    
    self.save.hidden = FALSE;
    self.passwordSectionLabel.hidden = FALSE;
    self.disconnect.hidden = TRUE;
    self.passwordTextInput.hidden = FALSE;
    self.gareTextInput.hidden = FALSE;
    self.gareLabel.hidden = TRUE;
    self.numeroTextInput.hidden = FALSE;
    self.numAgentLabel.hidden = TRUE;
    self.nameLabel.hidden = TRUE;
    self.nameTextInput.hidden = FALSE;
    self.navigationItem.rightBarButtonItem.enabled = FALSE;
    self.changePicture.hidden = FALSE;
}

- (IBAction)saveAndDismiss:(id)sender {
    // TODO(etienne): add a spinner and disable save button while we are processing the request.
    [[HAAgentService sharedInstance] getCurrentAgent:^(HAAgent *agent) {
        agent.name = self.nameTextInput.text;
        agent.password = self.passwordTextInput.text;
        agent.sncfId = self.numeroTextInput.text;
        agent.image = UIImageJPEGRepresentation(self.image.image, 0.90);
        agent.gare = self.gareTextInput.text;
        
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

- (IBAction)disconnect:(id)sender {
    [[HAAgentService sharedInstance] disconnectAgent];
    [[HACurrentStationService sharedInstance] disconnectFromServer];
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
