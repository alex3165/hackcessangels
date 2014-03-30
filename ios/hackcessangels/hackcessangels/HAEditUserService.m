//
//  HAEditUserService.m
//  hackcessangels
//
//  Created by Mac on 06/03/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAEditUserService.h"


@implementation HAEditUserService

- (void)editUser:(NSString *)login password:(NSString *)password email:(NSString *)email description:(NSString *)description handicap:(NSString *)handicap success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    
    DCRestRequests* editUserRequest = [[DCRestRequests alloc] init];
    if (login && password && email && email.length !=0 && password.length !=0 && login.length !=0) {
        
        [editUserRequest POSTrequest:@"request" withParameters:@{@"login" : login, @"password" : password, @"email" : email, @"description" : description, @"disability" : handicap} success:success failure:failure];
    }
    
    else {
        [[[UIAlertView alloc] initWithTitle:@"Champs incomplets" message:@"Veuillez compléter tous les champs" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
}

@end
