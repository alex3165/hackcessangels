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
@property(nonatomic, strong) HALocationServiceLocationUpdate update;

@end

@implementation HALocationService

- (bool) startLocation {
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        return FALSE;
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 1; // meters
    
    [self.locationManager startUpdatingLocation];
    return TRUE;
}

- (void) stopLocation {
    [self.locationManager stopUpdatingLocation];
}

- (bool) startAreaTracking {
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    if (![CLLocationManager significantLocationChangeMonitoringAvailable]) {
        return false;
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    
    [self.locationManager startMonitoringSignificantLocationChanges];
    return TRUE;
}

- (void) stopAreaTracking {
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void) setUpdateCallback:(HALocationServiceLocationUpdate)updated {
    self.update = updated;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    self.location = [locations lastObject];
    // If the event is recent, do something with it.
    DLog(@"latitude %+.6f, longitude %+.6f, accuracy %+.6f\n",
          self.location.coordinate.latitude,
          self.location.coordinate.longitude,
          self.location.horizontalAccuracy);
    if (self.update != nil) {
        self.update(self.location);
    }
}

- (double) currentLongitude {
    return self.location.coordinate.longitude;
}

- (double) currentLatitude {
    return self.location.coordinate.latitude;
}

@end
