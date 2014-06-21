//
//  HAFirstProfilViewController.h
//  hackcessangels
//
//  Created by Mac on 09/06/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HAFirstProfilViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewInit;

@property (weak, nonatomic) IBOutlet UIButton *buttonInit;

@property (weak, nonatomic) IBOutlet UIView *viewLog;
@property (weak, nonatomic) IBOutlet UITextField *mail;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *buttonLog;


@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UITextField *nomPrenom;
@property (weak, nonatomic) IBOutlet UITextField *urgencePhone;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIButton *button1;

@property (strong, nonatomic)    NSArray *items;
 @property (strong, nonatomic) IBOutlet UIPickerView *pickerView;



@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIButton *handicapAuditif;
@property (weak, nonatomic) IBOutlet UIButton *handicapVisuel;
@property (weak, nonatomic) IBOutlet UIButton *handicapCognitif;
@property (weak, nonatomic) IBOutlet UIButton *handicapMoteur;
@property (weak, nonatomic) IBOutlet UITextField *handicapAutre;
@property (weak, nonatomic) IBOutlet UIButton *button2;


@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UITextView *handicapInfos;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *buttonPhoto;
@property (weak, nonatomic) IBOutlet UIButton *ignorePhoto;


- (IBAction) buttonAuditif:(id)sender;
- (IBAction) buttonMoteur:(id)sender;
- (IBAction) buttonVision:(id)sender;

@property BOOL auditifSelected;
@property BOOL moteurSelected;
@property BOOL visionSelected;




@end
