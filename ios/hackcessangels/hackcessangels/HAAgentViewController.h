//
//  HAAgentViewController.h
//  hackcessangels
//
//  Created by Mac on 24/04/2014.
//  Copyright (c) 2014 hackcessangels All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HARestRequests.h"

@interface HAAgentViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextInput;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *nameTextInput;
@property (weak, nonatomic) IBOutlet UITextField *numeroTextInput;
@property (weak, nonatomic) IBOutlet UITextField *gareTextInput;
@property (weak, nonatomic) IBOutlet UIButton *changePicture;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gareLabel;
@property (weak, nonatomic) IBOutlet UILabel *numAgentLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordSectionLabel;

@property (weak, nonatomic) IBOutlet UIButton *save;
@property (weak, nonatomic) IBOutlet UIButton *disconnect;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

- (IBAction) saisieReturn:(id)sender;
- (IBAction) touchOutside:(id)sender;
- (IBAction) saveAndDismiss:(id)sender;
- (IBAction) cancelAndDismiss:(id)sender;
- (IBAction) takePicture:(id) sender;

@end
