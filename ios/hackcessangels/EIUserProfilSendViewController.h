//
//  EIUserProfilSendViewController.h
//
//  EIUserProfilViewController.h
//  hackcessangels
//
//  Created by Mac on 28/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HARestRequests.h"
#import "HAUserService.h"
@interface EIUserProfilSendViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *infos;

@property (weak, nonatomic) IBOutlet UILabel *nom;
@property (weak, nonatomic) IBOutlet UILabel *prenom;
@property (weak, nonatomic) IBOutlet UILabel *handicap;

@property (weak, nonatomic) IBOutlet UIButton *urgencePhone;

@property (weak, nonatomic) IBOutlet UIButton *Phone;


@property (weak, nonatomic) IBOutlet UIImageView *image;


@end

