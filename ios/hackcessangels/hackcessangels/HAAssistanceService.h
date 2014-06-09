//
//  HAAssistanceService.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 17/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

#import "HARestRequests.h"
#import "HAPeripheral.h"
#import "HACentralManager.h"
#import "HAHelpRequest.h"

// Block called when the request is updated (after a call to the server).
typedef void(^HAAssistanceRequestUpdate)(HAHelpRequest* helpRequest);

@interface HAAssistanceService : NSObject

+ (id) sharedInstance;

- (void)startHelpRequest:(HAAssistanceRequestUpdate) update failure:(HARestRequestsFailure) failure;
- (void)stopHelpRequest;

// Call to register a block that will be called for every update of the underlying HAHelpRequest.
- (void)registerForUpdates:(HAAssistanceRequestUpdate) update failure:(HARestRequestsFailure) failure;

- (void)helpMe:(CLLocation*)location success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure;
- (void)cancelHelp;
@end