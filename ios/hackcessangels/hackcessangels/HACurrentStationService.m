//
//  HACurrentStationService.m
//  hackcessangels
//
//  Created by Etienne Membrives on 19/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HACurrentStationService.h"
#import "HALocationService.h"
#import "HARestRequests.h"

@interface HACurrentStationService()

@property (nonatomic, strong) HALocationService* locationService;
@property (nonatomic, strong) HARestRequests* restRequest;

@end

@implementation HACurrentStationService

- (HACurrentStationService*) init {
    self = [super init];
    if (self) {
        self.locationService = [[HALocationService alloc] init];
        self.restRequest = [[HARestRequests alloc] init];
    }
    return self;
}

- (void) startReportingLocation {
    [self.locationService setUpdateCallback:^(CLLocation *newLocation) {
        // It should be OK to have a circular reference here because we are breaking the cycle in HALocationService::stopAreaTracking.
        [self reportLocation];
    }];
    [self.locationService startAreaTracking];
}

- (void) reportLocation {
    [self.restRequest POSTrequest:@"agent/position" withParameters:
  @{@"latitude": [NSNumber numberWithDouble: self.locationService.location.coordinate.latitude],
    @"longitude": [NSNumber numberWithDouble: self.locationService.location.coordinate.longitude],
    @"precision": [NSNumber numberWithDouble:self.locationService.location.horizontalAccuracy]}
                          success:^(id obj, NSHTTPURLResponse *response) {
    }
                          failure:^(id obj, NSError *error) {
    }];
}

- (void) stopReportingLocation {
    [self.locationService stopAreaTracking];
}

@end
