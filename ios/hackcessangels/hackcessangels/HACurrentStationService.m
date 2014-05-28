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
@property (nonatomic, weak) NSTimer* timer;

@end

NSTimeInterval const kTimeInterval = 15 * 60.0;

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
    [self performSelectorInBackground:@selector(reportingLocationInBackground) withObject:nil];
}

- (void) reportingLocationInBackground {
    [self.locationService setUpdateCallback:^(CLLocation *newLocation) {
        [self.locationService setUpdateCallback:nil];
        [self reportLocation];
    }];
    
    [self.locationService startAreaTracking];

    NSRunLoop* currentRunLoop = [NSRunLoop currentRunLoop];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(reportingTimerFired:) userInfo:nil repeats:YES];
    
    [currentRunLoop run];
}

- (void) reportingTimerFired:(NSTimer*) timer {
    [self reportLocation];
}

- (void) reportLocation {
    if (self.locationService.location == nil) {
        return;
    }
    
    DLog(@"Agent reporting location: latitude %+.6f, longitude %+.6f, accuracy %+.6f\n",
         self.locationService.location.coordinate.latitude,
         self.locationService.location.coordinate.longitude,
         self.locationService.location.horizontalAccuracy);
    
    [self.restRequest POSTrequest:@"agent/position" withParameters:
  @{@"latitude": [NSNumber numberWithDouble: self.locationService.location.coordinate.latitude],
    @"longitude": [NSNumber numberWithDouble: self.locationService.location.coordinate.longitude],
    @"precision": [NSNumber numberWithDouble:self.locationService.location.horizontalAccuracy]}
                          success:^(id obj, NSHTTPURLResponse *response) {
    }
                          failure:^(id obj, NSError *error) {
                              NSLog(@"%@",error);
    }];
}

- (void) stopReportingLocation {
    [self.locationService stopAreaTracking];
    [self.timer invalidate];
}

@end
