//
//  HAAssistanceService.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 17/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAAssistanceService.h"
#import "HALocationService.h"

#import "Reachability.h"

// TODO:
//  - Remonter regulierement la position
//  - Recuperer l'agent dans le retour, ou echec

@interface HAAssistanceService()

@property(nonatomic, strong) Reachability* reach;
@property(nonatomic, strong) NSTimer* timer;
@property(nonatomic, strong) HALocationService* locationService;

@end

@implementation HAAssistanceService

- (HAAssistanceService*)init {
    self = [super init];
    if (self) {
        // Allocate a reachability object
        self.reach = [Reachability reachabilityWithHostname:@"polaris.membrives.fr"];
        
        // Start the notifier, which will cause the reachability object to retain itself!
        [self.reach startNotifier];
        
        self.locationService = [[HALocationService alloc] init];
    }
    return self;
}

- (void) startHelpRequest {
    self.timer = [[NSTimer alloc]
                  initWithFireDate:[NSDate date]
                  interval:30
                  target:self
                  selector:@selector(timerFired)
                  userInfo:nil
                  repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    [self.locationService startLocation];
}

- (void) timerFired {
    [self helpMe:[self.locationService currentLongitude] latitude:[self.locationService currentLatitude] success:^(id obj, NSHTTPURLResponse *response) {
        DLog(@"success");
    } failure:^(NSError *error) {
        DLog(@"failure");
    }];
}

- (void) stopHelpRequest {
    [self.timer invalidate];
    [self.locationService stopLocation];
}

- (void)helpMe:(NSString*)longitude latitude:(NSString*)latitude success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    
    if (self.reach.isReachable) {
        DCRestRequests* helpRequest = [[DCRestRequests alloc] init];
    
        [helpRequest POSTrequest:@"request" withParameters:@{@"lng" : longitude, @"lat" : latitude} success:success failure:failure];
    } else {
        // TODO: Bluetooth
    }
}


@end
