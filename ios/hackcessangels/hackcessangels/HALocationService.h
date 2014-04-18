//
//  HALocationService.h
//  hackcessangels
//
//  Created by Etienne Membrives on 27/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HALocationService : NSObject <CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocation* location;

- (bool) startLocation;
- (void) stopLocation;
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

- (double) currentLongitude;
- (double) currentLatitude;

@end
