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

- (void)getUserWithEmail:(NSString*) email success:(HAUserServiceSuccess)success failure:(HAUserServiceFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest GETrequest:@"user" withParameters:@{@"email" : email} success:^(id obj){
        HAUser *user = [[HAUser alloc] initWithDictionary:obj];
        [user saveUserToKeyChain];
        if (success) {
            success(user);
        }
    } failure:failure];
}



// on recherche l'email entré, on le supprime, on envoit le nouvel email
- (void)updateUser:(NSString*) email withUpdatedEmail:(NSString*)updateEmail login:(NSString*)login withUpdatedLogin:(NSString*)updateLogin password:(NSString*)password withUpdatedPassword:(NSString*)updatePassword success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure
{
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];

    [dcRestRequest GETrequest:@"user" withParameters:@{@"email" : email, @"login" :login, @"password" : password} success:success failure:failure];

    [dcRestRequest DELETErequest:@"user" withParameters:@{@"email" : email , @"login" :login, @"password" : password} success:success failure:failure];
    [dcRestRequest POSTrequest:@"user" withParameters:@{@"email" : updateEmail , @"login" :updateLogin, @"password" : updatePassword} success:success failure:failure];

   [dcRestRequest GETrequest:@"user" withParameters:@{@"email" : email, @"login" : login, @"password" : password } success:^(NSDictionary *user){
       
       NSMutableDictionary *hash = [[NSMutableDictionary alloc] initWithDictionary:user];
       
       hash[@"email"] = updateEmail;
       hash[@"login"] = updateLogin;
       hash[@"password"] = updatePassword;
       
       [dcRestRequest PUTrequest:@"user" withParameters:@{@"email" : email, @"login" : login, @"password" : password, @"user":hash} success:success failure:failure];
       
   } failure:failure];
    
    
}


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

@end
