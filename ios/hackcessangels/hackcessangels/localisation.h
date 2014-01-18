//
//  localisation.h
//  HackcessAngels
//
//  Created by RIEUX Alexandre on 16/01/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface localisation : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager* locationManager;
}

@property (nonatomic, retain) NSString* maPosition;

@end
