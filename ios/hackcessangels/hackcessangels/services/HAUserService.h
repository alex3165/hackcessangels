//
//  HAUserService.h
//  hackcessangels
//
//  Created by Etienne Membrives on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCRestRequests.h"
#import "HAUser.h"

typedef void(^HAUserServiceSuccess)(HAUser *user);
typedef void(^HAUserServiceFailure)(NSError *error);

@interface HAUserService : NSObject

- (void)getUserWithEmail:(NSString*) email success:(HAUserServiceSuccess)success failure:(HAUserServiceFailure)failure;

-(void)updateUser:(NSString*) email withUpdatedEmail:(NSString*)updateEmail login:(NSString*)login withUpdatedLogin:(NSString*)updateLogin password:(NSString*)password withUpdatedPassword:(NSString*)updatePassword success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure;


- (void)createUserWithEmailAndPassword:(NSString*) email password:(NSString*) password
                    success:(DCRestRequestsSuccess)success
                    failure:(DCRestRequestsFailure)failure;


- (void)loginWithEmailAndPassword:(NSString*) email password:(NSString*) password
                    success:(DCRestRequestsSuccess)success
                    failure:(DCRestRequestsFailure)failure;


- (void)deleteUserWithEmail:(NSString*) email success:(DCRestRequestsSuccess)success
                          failure:(DCRestRequestsFailure)failure;

@end
