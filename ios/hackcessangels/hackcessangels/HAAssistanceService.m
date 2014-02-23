//
//  HAAssistanceService.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 17/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAAssistanceService.h"

@implementation HAAssistanceService

- (void)helpMe:(NSString*)longitude latitude:(NSString*)latitude success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    
    DCRestRequests* helpRequest = [[DCRestRequests alloc] init];
    
    [helpRequest POSTrequest:@"request" withParameters:@{@"lng" : longitude, @"lat" : latitude} success:success failure:failure];
    
}


@end
