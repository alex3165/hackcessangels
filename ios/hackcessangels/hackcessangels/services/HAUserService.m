//
//  HAUserService.m
//  hackcessangels
//
//  Created by Etienne Membrives on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAUserService.h"
#import "DCRestRequests.h"

@implementation HAUserService

- (void)getUserWithEmail:(NSString*) email success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest GETrequest:@"user" withParameters:@{@"email" : email} success:success failure:failure];
}

@end
