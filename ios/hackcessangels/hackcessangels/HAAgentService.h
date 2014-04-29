//
//  HAAgentService.h
//  hackcessangels
//
//  Created by Mac on 24/04/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import "HARestRequests.h"
#import "HAAgent.h"

typedef void(^HAAgentServiceSuccess)(HAAgent *agent);
typedef void(^HAAgentServiceFailure)(NSError *error);

@interface HAAgentService : NSObject

+ (id)sharedInstance;

- (void)getCurrentAgent:(HAAgentServiceSuccess) success failure:(HAAgentServiceFailure) failure;

- (void)updateAgent:(HAAgent*) agent success:(HAAgentServiceSuccess)success failure:(HAAgentServiceFailure)failure;

- (void)createAgentWithNameAndPassword:(NSString*) name password:(NSString*) password
                               success:(HARestRequestsSuccess)success
                               failure:(HARestRequestsFailure)failure;


- (void)loginWithNameAndPassword:(NSString*) name password:(NSString*) password
                          success:(HARestRequestsSuccess)success
                          failure:(HARestRequestsFailure)failure;


- (void)deleteAgentWithName:(NSString*) name success:(HARestRequestsSuccess)success
                    failure:(HARestRequestsFailure)failure;

@end

