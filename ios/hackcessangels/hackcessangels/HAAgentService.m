//
//  HAAgentService.m
//  hackcessangels
//
//  Created by Mac on 24/04/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAAgentService.h"
#import "HAAgent.h"
#import "HARestRequests.h"

@interface HAAgentService ()

@property (nonatomic, strong) HAAgent* currentAgent;

- (void)getAgentWithName:(NSString*) name success:(HAAgentServiceSuccess)success failure:(HAAgentServiceFailure)failure;

@end

@implementation HAAgentService

+ (id)sharedInstance {
    static HAAgentService *sharedAgentService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAgentService = [[self alloc] init];
        sharedAgentService.currentAgent = nil;
    });
    return sharedAgentService;
}

// Return the current user of this app asynchronously.
//  - If a user is already known and loaded, return it immediately
//  - If a user is known but its data not updated (e.g.: login successful but no contact with server),
//    make a call to the server to get the full user object. If the server contact fails, fails.
//  - Otherwise, fails.
- (void)getCurrentAgent:(HAAgentServiceSuccess)success failure:(HAAgentServiceFailure)failure {
    if (self.currentAgent != nil) {
        // We already have a user, just return it.
        success(self.currentAgent);
        return;
    }
    
    HAAgent* agent = [HAAgent agentFromKeyChain];
    if (!agent) {
        // No user logged in. How is this possible?
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"No known agent; login required" forKey:NSLocalizedDescriptionKey];
        //failure([[NSError alloc] initWithDomain:@"agent" code:401 agentInfo:details]);
        return;
    }
    
    [self getAgentWithName:agent.email success:^(HAAgent *agent) {
        self.currentAgent = agent;
        success(agent);
    } failure:failure];
    return;
}

- (void)getAgentWithName:(NSString*) name success:(HAAgentServiceSuccess)success failure:(HAAgentServiceFailure)failure {
    HARestRequests* haRestRequest = [[HARestRequests alloc] init];
    [haRestRequest GETrequest:@"agent" withParameters:@{@"name" : name} success:^(id obj, NSHTTPURLResponse* response){
        // TODO: Do a proper merge of the two objects
        HAAgent *agent = [[HAAgent alloc] initWithDictionary:obj];
        HAAgent *original = [HAAgent agentFromKeyChain];
        if (original) {
            agent.cookie = original.cookie;
        }
        if (success) {
            success(agent);
        }
    } failure:^(id obj, NSError *error) {
        //NSError* newError = [[NSError alloc] initWithDomain:@"server" code:[[(NSDictionary*) obj objectForKey:@"status"] intValue] agentInfo:error.agentInfo];
        //failure(newError);
    }];
}

// Verify that agent is a valid agent (locally), then send the update to the server.
- (void)updateAgent:(HAAgent *)agent success:(HAAgentServiceSuccess)success failure:(HAAgentServiceFailure)failure {
    HARestRequests* requestService = [[HARestRequests alloc] init];
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:agent.name forKey:pNameKey];
    
    // Set a new password only if it changed by the agent
    if (agent.password != nil && agent.password.length != 0) {
        [parameters setObject:agent.password forKey:pPasswordKey];
    }
    // Set a new numero only if it changed by the agent
    if (agent.phone != nil && agent.phone.length != 0) {
        [parameters setObject:agent.phone forKey:pNumeroKey];
    }
    
    // Name is a required property
    if (agent.name == nil || agent.name.length == 0) {
        // No user logged in. How is this possible?
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:@"Name must be set" forKey:NSLocalizedDescriptionKey];
        //failure([[NSError alloc] initWithDomain:@"update" code:400 agentInfo:details]);
    }
    
    [parameters setObject:agent.name forKey:pNameKey];
    [parameters setObject:agent.gare forKey:pGareKey];
    if (agent.image != nil) {
        [parameters setObject:[agent.image base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] forKey:pImageKey];
    }
    
    [requestService PUTrequest:@"agent" withParameters: [[NSDictionary alloc] initWithObjectsAndKeys:parameters, @"data", nil] success:^(id obj, NSHTTPURLResponse *response) {
        self.currentAgent = [[HAAgent alloc] initWithDictionary:obj];
        success(self.currentAgent);
    } failure:^(id obj, NSError *error) {
        failure(error);
    }];
}

- (void)createAgentWithEmailAndPassword:(NSString *)name password:(NSString *)password success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure {
    HARestRequests* dcRestRequest = [[HARestRequests alloc] init];
    [dcRestRequest POSTrequest:@"agent" withParameters:@{@"name" : name, @"password":password} success:success failure:failure];
}

- (void)loginWithEmailAndPassword:(NSString *)email password:(NSString *)password success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure {
    HARestRequests* dcRestRequest = [[HARestRequests alloc] init];
    [dcRestRequest POSTrequest:@"agent/login" withParameters:@{@"email" : email, @"password":password} success:^(id object, NSHTTPURLResponse* response){
        
        NSDictionary *agentSetting = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email", nil];
        
        /* On crée l'agent et on le sauve */
        HAAgent* agent = [[HAAgent alloc] initWithDictionary:agentSetting];
        NSArray* cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
        if ([cookies count] != 0) {
            agent.cookie = cookies[0];
        }
        [agent saveAgentToKeyChain];
        success(agent, response);
    } failure:failure];
}

- (HACheckCredentials)getCheckCredentialsBlock {
    return ^(NSString* login, NSString* password,
             HALoginSuccess success,
             HALoginFailure failure) {
        HAAgentService* service = [HAAgentService sharedInstance];
        [service loginWithEmailAndPassword:login password:password success:^(NSDictionary *dico, id obj){
            success();
        } failure:^(id obj, NSError *error) {
            failure(error);
        }];
    };
}

- (void)deleteAgentWithEmail:(NSString *)email success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure {
    HARestRequests* dcRestRequest = [[HARestRequests alloc] init];
    [dcRestRequest DELETErequest:@"agent" withParameters:@{@"email" : email} success:success failure:failure];
}

@end
