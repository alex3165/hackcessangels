//
//  HAUserService.h
//  hackcessangels
//
//  Created by Etienne Membrives on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCRestRequests.h"

@interface HAUserService : NSObject
    - (void)getUserWithEmail:(NSString*) email success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure;
@end
