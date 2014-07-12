//
//  HAUserViewController.h
//  hackcessangels
//
//  Created by Mac on 06/03/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HARestRequests.h"
#import "HAUserService.h"

// Libs
#import "AFNetworking.h"

typedef enum HAUserSimpleDisability : NSUInteger {
    kAuditif,
    kMoteur,
    kVisuel,
    kCognitif,
    kAutre
} HAUserSimpleDisability;

@interface HAUserViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextInput;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *nameTextInput;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextInput;
@property (weak, nonatomic) IBOutlet UITextField *numeroTextInput;
@property (weak, nonatomic) IBOutlet UITextField *handicapAutre;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIView *containerScrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContent;


@property (weak, nonatomic) IBOutlet UIButton *buttonMalVoyant;
@property (weak, nonatomic) IBOutlet UIButton *buttonMalEntendant;
@property (weak, nonatomic) IBOutlet UIButton *buttonFauteil;
@property (weak, nonatomic) IBOutlet UIButton *buttonCognitif;
@property (weak, nonatomic) IBOutlet UIButton *buttonAutre;



@property (weak, nonatomic) IBOutlet UIButton *save;

- (IBAction) saisieReturn:(id)sender;
- (IBAction) touchOutside:(id)sender;
- (IBAction) saveAndDismiss:(id)sender;
- (IBAction) auditif:(id)sender;
- (IBAction) moteur:(id)sender;
- (IBAction) cognitif:(id)sender;
- (IBAction) visuel:(id)sender;
- (IBAction) autre:(id)sender;
- (IBAction) takePicture:(id) sender;


@end


