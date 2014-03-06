//
//  HALocationService.h
//  hackcessangels
//
//  Created by Etienne Membrives on 27/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HALocationService : NSObject
- (void) startLocation;
- (void) stopLocation;
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
@end
