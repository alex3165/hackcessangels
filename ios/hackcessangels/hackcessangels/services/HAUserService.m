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

@property (nonatomic, strong) HAUser* currentUser;

- (void)getUserWithEmail:(NSString*) email success:(HAUserServiceSuccess)success failure:(HAUserServiceFailure)failure;

@end

@implementation HAUserService

+ (id)sharedInstance {
    static HAUserService *sharedUserService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserService = [[self alloc] init];
        sharedUserService.currentUser = nil;
    });
    return sharedUserService;
}

// Return the current user of this app asynchronously.
//  - If a user is already known and loaded, return it immediately
//  - If a user is known but its data not updated (e.g.: login successful but no contact with server),
//    make a call to the server to get the full user object. If the server contact fails, fails.
//  - Otherwise, fails.
- (void)getCurrentUser:(HAUserServiceSuccess)success failure:(HAUserServiceFailure)failure {
    if (self.currentUser != nil) {
        // We already have a user, just return it.
        success(self.currentUser);
        return;
    }
    
    HAUser* user = [HAUser userFromKeyChain];
    if (!user) {
        // No user logged in. How is this possible?
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"No known user" forKey:NSLocalizedDescriptionKey];
        failure([[NSError alloc] initWithDomain:@"user" code:404 userInfo:details]);
    }
    
    [self getUserWithEmail:user.email success:^(HAUser *user) {
        self.currentUser = user;
        success(user);
    } failure:failure];
    return;
}

- (void)getUserWithEmail:(NSString*) email success:(HAUserServiceSuccess)success failure:(HAUserServiceFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest GETrequest:@"user" withParameters:@{@"email" : email} success:^(id obj, NSHTTPURLResponse* response){
        HAUser *user = [[HAUser alloc] initWithDictionary:obj];
        [user saveUserToKeyChain];
        if (success) {
            success(user);
        }
    } failure:^(id obj, NSError *error) {
        failure(error);
    }];
}

// on recherche l'email entré, on le supprime, on envoit le nouvel email
- (void)updateUser:(HAUser *)user success:(HAUserServiceSuccess)success failure:(HAUserServiceFailure)failure {
    
}

- (void)createUserWithEmailAndPassword:(NSString *)email password:(NSString *)password success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest POSTrequest:@"user" withParameters:@{@"email" : email, @"password":password} success:success failure:failure];
}
    
- (void)loginWithEmailAndPassword:(NSString *)email password:(NSString *)password success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest POSTrequest:@"user/login" withParameters:@{@"email" : email, @"password":password} success:^(id object, NSHTTPURLResponse* response){
        
        NSDictionary *userSetting = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email", nil];
        
        /* On crée le User et on le sauve */
        HAUser* user = [[HAUser alloc] initWithDictionary:userSetting];
        NSArray* cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
        if ([cookies count] != 0) {
            user.cookie = cookies[0];
        }
        [user saveUserToKeyChain];
        success(user, response);
    } failure:failure];
}

- (void)deleteUserWithEmail:(NSString *)email success:(DCRestRequestsSuccess)success failure:(DCRestRequestsFailure)failure {
    DCRestRequests* dcRestRequest = [[DCRestRequests alloc] init];
    [dcRestRequest DELETErequest:@"user" withParameters:@{@"email" : email} success:success failure:failure];
}

@end
