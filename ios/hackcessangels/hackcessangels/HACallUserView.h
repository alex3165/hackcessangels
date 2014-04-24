//
//  HACallUserViewController.h
//  hackcessangels
//
//  Created by Mac on 14/04/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HAUser.h"



@interface HACallUserView : UIView


@property (weak, nonatomic) IBOutlet UIButton *callUser;

- (void) hideProfile;
- (void) showProfile;

@end
