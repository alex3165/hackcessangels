//
//  HAFirstProfilViewController.h
//  hackcessangels
//
//  Created by Mac on 09/06/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HAFirstProfilViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewInit;
@property (weak, nonatomic) IBOutlet UITextField *mail;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *buttonInit;


@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UITextField *nomPrenom;
@property (weak, nonatomic) IBOutlet UITextField *urgencePhone;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIButton *button1;


@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIButton *handicapAuditif;
@property (weak, nonatomic) IBOutlet UIButton *handicapVisuel;
@property (weak, nonatomic) IBOutlet UIButton *handicapCognitif;
@property (weak, nonatomic) IBOutlet UIButton *handicapMoteur;
@property (weak, nonatomic) IBOutlet UITextField *handicapAutre;
@property (weak, nonatomic) IBOutlet UIButton *button2;


@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UITextField *handicapInfos;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *buttonPhoto;
@property (weak, nonatomic) IBOutlet UIButton *ignorePhoto;

@end
