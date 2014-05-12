//
//  HARestRequests.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 11/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^HARestRequestsSuccess)(id obj, NSHTTPURLResponse* response);
typedef void(^HARestRequestsFailure)(id obj, NSError *error);

@interface HARestRequests : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

-(void) GETrequest:(NSString *)getstring withParameters:(NSDictionary *)params success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure;

-(void)POSTrequest:(NSString *)getstring withParameters:(NSDictionary *)params success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure;

-(void)DELETErequest:(NSString *)getstring withParameters:(NSDictionary *)params success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure;

-(void)PUTrequest:(NSString *)getstring withParameters:(NSDictionary *)params success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure;

@end