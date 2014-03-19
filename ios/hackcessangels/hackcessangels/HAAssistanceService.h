//
//  HAAssistanceService.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 17/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCRestRequests.h"

@interface HAAssistanceService : NSObject
- (void)helpMe:(NSString*)longitude latitude:(NSString*)latitude success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure;
@end