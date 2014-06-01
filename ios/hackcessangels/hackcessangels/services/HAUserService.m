//
//  HAUserService.m
//  hackcessangels
//
//  Created by Etienne Membrives on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAUserService.h"
#import "HAUser.h"
#import "HARestRequests.h"

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
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"No known user; login required" forKey:NSLocalizedDescriptionKey];
        failure([[NSError alloc] initWithDomain:@"user" code:401 userInfo:details]);
        return;
    }
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:user.cookie];
     
    [self getUserWithEmail:user.email success:^(HAUser *user) {
        self.currentUser = user;
        success(user);
    } failure:failure];
    return;
}

- (void)getUserWithEmail:(NSString*) email success:(HAUserServiceSuccess)success failure:(HAUserServiceFailure)failure {
    HARestRequests* haRestRequest = [[HARestRequests alloc] init];
    [haRestRequest GETrequest:@"user" withParameters:@{@"email" : email} success:^(id obj, NSHTTPURLResponse* response){
        // TODO: Do a proper merge of the two objects
        HAUser *user = [[HAUser alloc] initWithDictionary:obj];
        HAUser *original = [HAUser userFromKeyChain];
        if (original) {
            user.cookie = original.cookie;
        }
        if (success) {
            success(user);
        }
    } failure:^(id obj, NSError *error) {
        NSError* newError = [[NSError alloc] initWithDomain:@"server" code:[[(NSDictionary*) obj objectForKey:@"status"] intValue] userInfo:error.userInfo];
        failure(newError);
    }];
}

// Verify that user is a valid user (locally), then send the update to the server.
- (void)updateUser:(HAUser *)user success:(HAUserServiceSuccess)success failure:(HAUserServiceFailure)failure {
    HARestRequests* requestService = [[HARestRequests alloc] init];
    
    if (user.name == nil || user.name.length == 0) {
        // No user logged in. How is this possible?
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Name must be set" forKey:NSLocalizedDescriptionKey];
        failure([[NSError alloc] initWithDomain:@"update" code:400 userInfo:details]);
    }
    
    NSDictionary* parameters = [user toPropertyList];
    
    [requestService PUTrequest:@"user" withParameters: [[NSDictionary alloc] initWithObjectsAndKeys:parameters, @"data", nil] success:^(id obj, NSHTTPURLResponse *response) {
        self.currentUser = [[HAUser alloc] initWithDictionary:obj];
        success(self.currentUser);
    } failure:^(id obj, NSError *error) {
        failure(error);
    }];
}

- (void)createUserWithEmailAndPassword:(NSString *)email password:(NSString *)password success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure {
    HARestRequests* dcRestRequest = [[HARestRequests alloc] init];
    [dcRestRequest POSTrequest:@"user" withParameters:@{@"email" : email, @"password":password} success:success failure:failure];
}

- (void)loginWithEmailAndPassword:(NSString *)email password:(NSString *)password success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure {
    HARestRequests* dcRestRequest = [[HARestRequests alloc] init];
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

- (HACheckCredentials)getCheckCredentialsBlock {
    return ^(NSString* login, NSString* password,
             HALoginSuccess success,
             HALoginFailure failure) {
        HAUserService* service = [HAUserService sharedInstance];
        [service loginWithEmailAndPassword:login password:password success:^(NSDictionary *dico, id obj){
            success();
        } failure:^(id obj, NSError *error) {
            failure(error);
        }];
    };
}

- (void)deleteUserWithEmail:(NSString *)email success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure {
    HARestRequests* dcRestRequest = [[HARestRequests alloc] init];
    [dcRestRequest DELETErequest:@"user" withParameters:@{@"email" : email} success:success failure:failure];
}

@end
