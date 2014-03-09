//
//  HAUserService.m
//  hackcessangels
//
//  Created by Etienne Membrives on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAUserService.h"
#import "HAUser.h"
#import "DCRestRequests.h"

@interface HAUserService ()

@property (nonatomic, strong) HAUser* actualUser;

@end

@implementation HAUserService

- (void)getUserWithEmail:(NSString*) email success:(HAUserServiceSuccess)success failure:(HAUserServiceFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest GETrequest:@"user" withParameters:@{@"email" : email} success:^(id obj, NSHTTPURLResponse* response){
        HAUser *user = [[HAUser alloc] initWithDictionary:obj];
        [user saveUserToKeyChain];
        if (success) {
            success(user);
        }
    } failure:failure];
}



// on recherche l'email entré, on le supprime, on envoit le nouvel email
- (void)updateUser:(NSString*) email withUpdatedEmail:(NSString*)updateEmail password:(NSString*)password withUpdatedPassword:(NSString*)updatePassword success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure
{
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];

    [dcRestRequest GETrequest:@"user" withParameters:@{@"email" : email, @"password" : password} success:success failure:failure];

    [dcRestRequest DELETErequest:@"user" withParameters:@{@"email" : email , @"password" : password} success:success failure:failure];
    [dcRestRequest POSTrequest:@"user" withParameters:@{@"email" : updateEmail , @"password" : updatePassword} success:success failure:failure];

   [dcRestRequest GETrequest:@"user" withParameters:@{@"email" : email, @"password" : password } success:^(NSDictionary *user, NSHTTPURLResponse* response){
       
       NSMutableDictionary *hash = [[NSMutableDictionary alloc] initWithDictionary:user];
       
       hash[@"email"] = updateEmail;
       hash[@"password"] = updatePassword;
       
       [dcRestRequest PUTrequest:@"user" withParameters:@{@"email" : email, @"password" : password, @"user":hash} success:success failure:failure];
       
   } failure:failure];
    
    
}


- (void)createUserWithEmailAndPassword:(NSString *)email password:(NSString *)password success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest POSTrequest:@"user" withParameters:@{@"email" : email, @"password":password} success:success failure:failure];
}
    
- (void)loginWithEmailAndPassword:(NSString *)email password:(NSString *)password success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest POSTrequest:@"user/login" withParameters:@{@"email" : email, @"password":password} success:^(id object, NSHTTPURLResponse* response){
        
        NSDictionary *userSetting = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email",password,@"password", nil];
        
        /* On crée le User et on le sauve */
        self.actualUser = [[HAUser alloc] initWithDictionary:userSetting];
        NSArray* cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
        if ([cookies count] != 0) {
            self.actualUser.cookie = cookies[0];
        }
        [self.actualUser saveUserToKeyChain];
        success(self.actualUser, response);
    } failure:failure];
}




- (void)deleteUserWithEmail:(NSString *)email success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest DELETErequest:@"user" withParameters:@{@"email" : email} success:success failure:failure];
}

@end
