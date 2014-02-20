//
//  HAAssistanceService.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 17/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAAssistanceService.h"

@implementation HAAssistanceService

- (void)helpMe:(NSString*)handicap success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    
    DCRestRequests* helpRequest = [[DCRestRequests alloc] init];
    
    [helpRequest POSTrequest:@"user" withParameters:@{@"handicap" : handicap} success:success failure:failure];
    
}


@end
