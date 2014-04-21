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

@interface HAUserViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate
>


@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextInput;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *nameTextInput;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextInput;
@property (weak, nonatomic) IBOutlet UITextField *numeroTextInput;
@property (nonatomic,weak) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UIButton *save;

- (IBAction) saisieReturn:(id)sender;
- (IBAction) touchOutside:(id)sender;
- (IBAction) saveAndDismiss:(id)sender;
@end


