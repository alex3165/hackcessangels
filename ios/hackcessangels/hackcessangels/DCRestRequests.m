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
        
        NSURL *urlrequests = [NSURL URLWithString:@"http://terra.membrives.fr/app/api/"];
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:urlrequests];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //NSDictionary *response;
        
    }
    
    return self;
}


-(NSDictionary *)GETrequest: (NSString *)getstring : (NSDictionary *)parameters {
    
    NSDictionary *response;
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    [self.manager GET:getstring parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        __block response = data;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        __block response = [error localizedDescription];
    }];

    return response;
}


@end