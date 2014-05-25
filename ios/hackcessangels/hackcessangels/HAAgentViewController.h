//
//  HAAgentViewController.h
//  hackcessangels
//
//  Created by Mac on 24/04/2014.
//  Copyright (c) 2014 hackcessangels All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HARestRequests.h"

@interface HAAgentViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *passwordTextInput;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *nameTextInput;
@property (weak, nonatomic) IBOutlet UITextField *numeroTextInput;
@property (weak, nonatomic) IBOutlet UITextField *gareTextInput;
@property (nonatomic,weak) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UIButton *save;

- (IBAction) saisieReturn:(id)sender;
- (IBAction) touchOutside:(id)sender;
- (IBAction) saveAndDismiss:(id)sender;

@end
