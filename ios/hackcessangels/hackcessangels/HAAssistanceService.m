//
//  HAAssistanceService.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 17/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAAssistanceService.h"
#import "HALocationService.h"
#import "HAHelpRequest.h"

#import "Reachability.h"
#import "HASERVICES.h"

// TODO:
//  - Remonter regulierement la position
//  - Recuperer l'agent dans le retour, ou echec

@interface HAAssistanceService()
    @property(nonatomic, strong) Reachability* reach;
    @property(nonatomic, strong) NSTimer* timer;
    @property(nonatomic, strong) HALocationService* locationService;
    @property(nonatomic, strong) HAPeripheral* peripheralService;
    @property(nonatomic, strong) HACentralManager* managerService;
    @property(nonatomic, assign) BOOL requestInFlight;

    // The help request currently in flight; nil otherwise.
    @property(nonatomic, strong) HAHelpRequest* currentHelpRequest;

    @property(nonatomic, strong) HAAssistanceRequestAbort abortCallback;
    @property(nonatomic, strong) HAAssistanceRequestAgentContacted agentContactedCallback;
    @property(nonatomic, strong) HAAssistanceRequestSuccess successCallback;
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
        self.requestInFlight = false;
    }
    return self;
}

- (void) startHelpRequest:(HAAssistanceRequestAbort)abort agentContacted:(HAAssistanceRequestAgentContacted)agentContacted success:(HAAssistanceRequestSuccess)success {
    [self.locationService startLocation];

    self.timer = [[NSTimer alloc]
                  initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1]
                  interval:10
                  target:self
                  selector:@selector(timerFired)
                  userInfo:nil
                  repeats:YES];

    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void) timerFired {
    [self helpMe:[self.locationService currentLongitude] latitude:[self.locationService currentLatitude] success:^(id obj, NSHTTPURLResponse *response) {
        self.currentHelpRequest = [[HAHelpRequest alloc] initWithDictionary:obj];
    } failure:^(id obj, NSError *error) {
        DLog(@"failure");
    }];
}

- (void) stopHelpRequest {
    [self.timer invalidate];
    [self.locationService stopLocation];
    
    HARestRequests* restRequest = [[HARestRequests alloc] init];
    [restRequest DELETErequest:@"request" withParameters:@{} success:nil failure:nil];
    
    self.requestInFlight = false;
}

- (void)helpMe:(double)longitude latitude:(double)latitude success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure {
    //NSLog(@"%hhd attention le test de connection est faussé pour test bluetooth",self.reach.isReachable);
    if (self.reach.isReachable) {
        HARestRequests* restRequest = [[HARestRequests alloc] init];
    
        if (!self.requestInFlight) {
            [restRequest POSTrequest:@"help" withParameters:@{@"longitude" : [NSNumber numberWithDouble: longitude], @"latitude" : [NSNumber numberWithDouble:latitude]} success:success failure:failure];
            self.requestInFlight = true;
        } else {
            [restRequest PUTrequest:@"help" withParameters:@{@"id" : self.currentHelpRequest.Id,
                                                             @"longitude" : [NSNumber numberWithDouble: longitude],
                                                             @"latitude" : [NSNumber numberWithDouble:latitude]} success:success failure:failure];
        }
    } else {
        NSLog(@"désolé vous n'avez pas de connexion à internet, nous allons quand même essayer avec le bluetooth");
        self.peripheralService = [[HAPeripheral alloc]initWithLongAndLat:longitude latitude:latitude]; // envoi l'appel à l'aide bluetooth
    }
}

@end
