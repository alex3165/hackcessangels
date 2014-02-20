//
//  DCRestRequests.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 11/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^DCRestRequestsSuccess)();
typedef void(^DCRestRequestsFailure)(NSError *error);

@interface DCRestRequests : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

-(void)GETrequest:(NSString *)getstring withParameters:(NSDictionary *)params success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure;

-(void)POSTrequest:(NSString *)getstring withParameters:(NSDictionary *)params success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure;

-(void)DELETErequest:(NSString *)getstring withParameters:(NSDictionary *)params success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure;

-(void)PUTrequest:(NSString *)getstring withParameters:(NSDictionary *)params success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure;

@end