//
//  HAAssistanceService.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 17/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HARestRequests.h"
#import "HAPeripheral.h"

// Block called when the request is aborted (typically, no response from any agent within X minutes).
typedef void(^HAAssistanceRequestAbort)();

// Block called when an agent answered the request, but it is still not completed.
typedef void(^HAAssistanceRequestAgentContacted)(NSString* agentName);

// Block called when the assistance request finished successfully (end of request after agent contacted).
typedef void(^HAAssistanceRequestSuccess)();

@interface HAAssistanceService : NSObject
- (void)startHelpRequest:(HAAssistanceRequestAbort) abort agentContacted:(HAAssistanceRequestAgentContacted) agentContacted success:(HAAssistanceRequestSuccess) success;
- (void)stopHelpRequest;

- (void)helpMe:(double)longitude latitude:(double)latitude success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure;
@end