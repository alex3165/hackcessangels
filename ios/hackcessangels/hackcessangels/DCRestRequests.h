//
//  DCRestRequests.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 11/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface DCRestRequests : NSObject
    @property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@end