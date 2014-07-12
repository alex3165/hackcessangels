//
//  HALocationService.h
//  hackcessangels
//
//  Created by Etienne Membrives on 27/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^HALocationServiceLocationUpdate)(CLLocation* newLocation);

@interface HALocationService : NSObject <CLLocationManagerDelegate>
@property(nonatomic, readonly) CLLocation* location;

// Subscribe to the most precise location updates.
- (bool) startLocation;
- (void) stopLocation;

// Subscribe to low-precision location updates.
- (bool) startAreaTracking;
- (void) stopAreaTracking;

- (void) setUpdateCallback:(HALocationServiceLocationUpdate) updated;

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
@end
