//
//  HAEditUserService.h
//  hackcessangels
//
//  Created by Mac on 06/03/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DCRestRequests.h"



@interface HAEditUserService : NSObject

- (void)editUser:(NSString*)login password:(NSString*)password email:(NSString*)email description:(NSString*)description handicap:(NSString*)handicap  success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure;
@end



