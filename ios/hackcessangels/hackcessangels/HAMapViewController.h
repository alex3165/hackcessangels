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

// services
#import "DCRestRequests.h"
#import "HAUserService.h"

// Libs
#import "AFNetworking.h"

@interface HAMapViewController : UIViewController <MKMapViewDelegate>


/* Objet de la classe DCRestRequest (à voir) */
@property (nonatomic, strong) HAUserService *userService;
@property (nonatomic, strong) DCRestRequests *restRequests;
@property (nonatomic, strong) HATileOverlay *overlay;

@property (nonatomic, weak) IBOutlet MKMapView *map;


@end