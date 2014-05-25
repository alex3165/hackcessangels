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
#import "HAAbstractLoginService.h"

typedef void(^HAAgentServiceSuccess)(HAAgent *agent);
typedef void(^HAAgentServiceFailure)(NSError *error);

@interface HAAgentService : NSObject<HAAbstractLoginService>

+ (id)sharedInstance;

- (void)getCurrentAgent:(HAAgentServiceSuccess) success failure:(HAAgentServiceFailure) failure;

- (void)updateAgent:(HAAgent*) agent success:(HAAgentServiceSuccess)success failure:(HAAgentServiceFailure)failure;

- (void)createAgentWithEmailAndPassword:(NSString*) email password:(NSString*) password
                               success:(HARestRequestsSuccess)success
                               failure:(HARestRequestsFailure)failure;


- (void)loginWithEmailAndPassword:(NSString*) email password:(NSString*) password
                          success:(HARestRequestsSuccess)success
                          failure:(HARestRequestsFailure)failure;


- (void)deleteAgentWithEmail:(NSString*) email success:(HARestRequestsSuccess)success
                    failure:(HARestRequestsFailure)failure;

@end

