//
//  HALocationService.m
//  hackcessangels
//
//  Created by Etienne Membrives on 27/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HALocationService.h"

@interface HALocationService ()

@property(nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation HALocationService

- (bool) startLocation {
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    if (![self.locationManager locationServicesEnabled]) {
        return FALSE;
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 1; // meters
    
    [self.locationManager startUpdatingLocation];
    return TRUE;
}

- (void) stopLocation {
    [self.locationManager stopUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    // If the event is recent, do something with it.
    DLog(@"latitude %+.6f, longitude %+.6f, accuracy %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude,
          location.horizontalAccuracy);
}
@end
