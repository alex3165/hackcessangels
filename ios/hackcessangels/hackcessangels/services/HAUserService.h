//
//  HAUserService.h
//  hackcessangels
//
//  Created by Etienne Membrives on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HARestRequests.h"
#import "HAUser.h"
#import "HAAbstractLoginService.h"

typedef void(^HAUserServiceSuccess)(HAUser *user);
typedef void(^HAUserServiceFailure)(NSError *error);

@interface HAUserService : NSObject<HAAbstractLoginService>

+ (id)sharedInstance;

- (void)getCurrentUser:(HAUserServiceSuccess) success failure:(HAUserServiceFailure) failure;

- (void)updateUser:(HAUser*) user success:(HAUserServiceSuccess)success failure:(HAUserServiceFailure)failure;

- (void)createUserWithEmailAndPassword:(NSString*) email password:(NSString*) password
                    success:(HARestRequestsSuccess)success
                    failure:(HARestRequestsFailure)failure;


- (void)loginWithEmailAndPassword:(NSString*) email password:(NSString*) password
                    success:(HARestRequestsSuccess)success
                    failure:(HARestRequestsFailure)failure;

- (void)disconnectUser;

- (void)deleteUserWithEmail:(NSString*) email success:(HARestRequestsSuccess)success
                          failure:(HARestRequestsFailure)failure;

@end
