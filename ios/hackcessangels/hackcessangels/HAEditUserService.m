//
//  HAEditUserService.m
//  hackcessangels
//
//  Created by Mac on 06/03/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAEditUserService.h"


@implementation HAEditUserService

- (void)editUser:(NSString *)login password:(NSString *)password email:(NSString *)email success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    
    DCRestRequests* editUserRequest = [[DCRestRequests alloc] init];
    
    [editUserRequest POSTrequest:@"request" withParameters:@{@"login" : login, @"password" : password, @"email" : email} success:success failure:failure];
    
}

@end
