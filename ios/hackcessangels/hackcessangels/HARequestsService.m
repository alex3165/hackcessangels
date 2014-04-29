//
//  HARequestsService.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 29/04/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HARequestsService.h"
#import "Reachability.h"
#import "HALocationService.h"
#import "HAAgent.h"

@interface HARequestsService()
    @property(nonatomic, strong) Reachability* reach;
    @property(nonatomic, strong) HALocationService* locationService;
    @property(nonatomic, strong) HARestRequests* restRequest;
    @property(nonatomic, strong) NSString* idRequest;
@end

@implementation HARequestsService

- (HARequestsService*)init {
    self = [super init];
    if (self) {
        // Allocate a reachability object
        self.reach = [Reachability reachabilityWithHostname:@"polaris.membrives.fr"];
        
        // Start the notifier, which will cause the reachability object to retain itself!
        [self.reach startNotifier];
        
        self.locationService = [[HALocationService alloc] init];
        self.restRequest = [[HARestRequests alloc]init];
    }
    return self;
}

/* PUT : Envoi de la position agent */
- (void)savePosition:(double)longitude latitude:(double)latitude success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure{
    [self.restRequest PUTrequest:@"agent/position" withParameters:@{@"longitude": [NSNumber numberWithDouble: longitude],@"latitude": [NSNumber numberWithDouble: latitude]} success:success failure:failure];
}
/* GET : récupérer les requêtes en cours */
- (void)getRequests:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure{
    [self.restRequest GETrequest:@"agent/requests" withParameters:@{@"": @""} success:^(id obj, NSHTTPURLResponse *response){
        
        self.idRequest = obj; // obj considéré comme un string
        
    } failure:failure];
}
/* POST : prendre une requête en cours avec l'id de la requête et le nom de l'agent */
- (void)takeRequest:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure{
    HAAgent *agent = [HAAgent agentFromKeyChain];
    [self.restRequest POSTrequest:@"agent/requests" withParameters:@{@"idReq":self.idRequest,@"nameAgent":agent.name} success:success failure:failure];
}

@end
