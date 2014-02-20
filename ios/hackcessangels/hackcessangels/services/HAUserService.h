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
<<<<<<< HEAD

- (void)update:(NSString*)  updateEmail :(NSString*)  email  success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure;
=======
- (void)createUserWithEmailAndPassword:(NSString*) email password:(NSString*) password
                    success:(DCRestRequestsSuccess)success
                    failure:(DCRestRequestsFailure)failure;
- (void)loginWithEmailAndPassword:(NSString*) email password:(NSString*) password
                    success:(DCRestRequestsSuccess)success
                    failure:(DCRestRequestsFailure)failure;
- (void)deleteUserWithEmail:(NSString*) email success:(DCRestRequestsSuccess)success
                          failure:(DCRestRequestsFailure)failure;
>>>>>>> 2992776db231109fc2339db5ade5d7619615ccd5
@end
