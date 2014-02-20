//
//  HAUserService.m
//  hackcessangels
//
//  Created by Etienne Membrives on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAUserService.h"
#import "DCRestRequests.h"

@implementation HAUserService

- (void)getUserWithEmail:(NSString*) email success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest GETrequest:@"user" withParameters:@{@"email" : email} success:success failure:failure];
}
<<<<<<< HEAD


// on recherche l'email entré, on le supprime, on envoit le nouvel email
- (void)update:(NSString*)  email :(NSString*)  updateEmail  success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure  {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];

   [dcRestRequest GETrequest:@"user" withParameters:@{@"email" : email} success:success failure:failure];
    if (email){
    [dcRestRequest DELETErequest:@"user" withParameters:@{@"email" : email} success:success failure:failure];
    [dcRestRequest POSTrequest:@"user" withParameters:@{@"email" : updateEmail} success:success failure:failure];
    
    }
}





=======
- (void)createUserWithEmailAndPassword:(NSString *)email password:(NSString *)password success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest POSTrequest:@"user" withParameters:@{@"email" : email, @"password":password} success:success failure:failure];
}
- (void)loginWithEmailAndPassword:(NSString *)email password:(NSString *)password success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest POSTrequest:@"user/login" withParameters:@{@"email" : email, @"password":password} success:success failure:failure];
}
- (void)deleteUserWithEmail:(NSString *)email success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest DELETErequest:@"user" withParameters:@{@"email" : email} success:success failure:failure];
}
>>>>>>> 2992776db231109fc2339db5ade5d7619615ccd5
@end
