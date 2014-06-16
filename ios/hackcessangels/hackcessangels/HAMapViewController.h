//
//  ViewController.h
//  HackcessAngels
//
//  Created by RIEUX Alexandre on 15/01/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//


#import <UIKit/UIKit.h>

// model
#import "HATileOverlay.h"
#import "HAHelpRequest.h"

// services

#import "HACentralManager.h"
#import "HAPeripheral.h"

@interface HAMapViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) HATileOverlay *overlay;
@property (nonatomic, strong) HACentralManager *bluetoothmanager;
//@property (nonatomic, strong) HAPeripheral *peripheralForResponse;

@property (nonatomic, weak) IBOutlet MKMapView *map;
@property (nonatomic, weak) IBOutlet UIButton *helpok;
@property (nonatomic, weak) IBOutlet UIImageView *userPicture;
@property (nonatomic, weak) IBOutlet UILabel *userName;
@property (nonatomic, weak) IBOutlet UILabel *userDisability;
@property (nonatomic, weak) IBOutlet UIButton *completeProfil;
//@property (nonatomic, assign) BOOL notification;

@property (nonatomic, strong) HAHelpRequest *helpRequest;

@end