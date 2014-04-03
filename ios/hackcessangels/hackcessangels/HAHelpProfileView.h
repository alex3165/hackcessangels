//
//  HAHelpProfileViewController.h
//  hackcessangels
//
//  Created by Etienne Membrives on 03/04/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HAHelpProfileProtocol <NSObject>
- (void) hideProfile;
- (void) showProfile;
@end

@interface HAHelpProfileView : UIView
@end
