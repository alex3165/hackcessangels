//
//  DCRestRequests.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 11/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "DCRestRequests.h"



@implementation DCRestRequests

- (id)init
{
    self = [super init];
    

    if (self) {
        

        NSURL *urlrequests = [NSURL URLWithString:@"http://polaris.membrives.fr/app/api/"];
        
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:urlrequests];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    }
    
    return self;
}


-(void)GETrequest:(NSString *)getstring withParameters:(NSDictionary *)params success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure;
{
    
    [self.manager GET:getstring parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success)
        {
           success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure)
        {
           failure(error);
        }
    }];
}



-(void) POSTrequest:(NSString *)getstring withParameters:(NSDictionary *)params success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure;

{
    
    [self.manager POST:getstring parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success)
        {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure)
        {
            failure(error);
        }
    }];
}

-(void) DELETErequest:(NSString *)getstring withParameters:(NSDictionary *)params success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure;

{
    
    [self.manager DELETE:getstring parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success)
        {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure)
        {
            failure(error);
        }
    }];
}


-(void)PUTrequest:(NSString *)getstring withParameters:(NSDictionary *)params success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure
{

    [self.manager PUT:getstring parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success)
        {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure)
        {
            failure(error);
        }
    }];
}




@end