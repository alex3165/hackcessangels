//
//  HAHelpRequest.h
//  hackcessangels
//
//  Created by Etienne Membrives on 12/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HAUser.h"
#import "HAAgent.h"

typedef enum HAHelpRequestStatus : NSUInteger {
    kNew,
    kAgentsContacted,
    kNoAgents,
    kRetry,
    kCancelled,
    kAbandonned,
    kAgentAnswered,
    kRequestCompleted,
    kReportFilled
} HAHelpRequestStatus;

@interface HAHelpRequest : NSObject

@property(nonatomic, strong) NSString* Id;
@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) double longitude;
@property(nonatomic, assign) double precision;
@property(nonatomic, assign) HAHelpRequestStatus status;

@property(nonatomic, strong) HAUser* user;
@property(nonatomic, strong) HAAgent* agent;

- (id)initWithDictionary:(NSDictionary *)data;

- (NSDictionary*) toPropertyList;

@end
