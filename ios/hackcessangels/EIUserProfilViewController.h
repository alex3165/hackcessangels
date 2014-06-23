//  hackcessangels
//
//  Created by Mac on 28/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HARestRequests.h"
#import "HAUserService.h"
@interface EIUserProfilViewController : UIViewController <UIScrollViewDelegate>

//LABELS TITRES

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *infos;
@property (weak, nonatomic) IBOutlet UILabel *numeros;

//LABLES USER
@property (weak, nonatomic) IBOutlet UILabel *nomPrenom;
@property (weak, nonatomic) IBOutlet UILabel *prenom;
@property (weak, nonatomic) IBOutlet UILabel *handicap;
@property (weak, nonatomic) IBOutlet UILabel *handicapAutre;
@property (weak, nonatomic) IBOutlet UILabel *handicapInfos;
@property (weak, nonatomic) IBOutlet UILabel *urgencePhone;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@property (weak, nonatomic) IBOutlet UIImageView *image;

//BUTTON TO HAUserViewController
@property (weak, nonatomic) IBOutlet UIButton *modifier;
@property (weak, nonatomic) IBOutlet UIButton *callPhone;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;






@end