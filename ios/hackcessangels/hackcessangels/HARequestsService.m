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
    @property(nonatomic, strong) HARestRequests* restRequest;
@end

@implementation HARequestsService

- (HARequestsService*)init {
    self = [super init];
    if (self) {
        self.restRequest = [[HARestRequests alloc]init];
    }
    return self;
}

/* GET : récupérer les requêtes en cours */
- (void)getRequests:(HAHelpRequestServiceListSuccess)success failure:(HAHelpRequestServiceFailure)failure{
    [self.restRequest GETrequest:@"agent/requests" withParameters:nil success:^(id obj, NSHTTPURLResponse *response){
        // obj is a list of dictionnaries, each one representing a single help request.
        NSMutableArray* rawHelpRequests = [[NSMutableArray alloc] initWithArray: obj];
        NSMutableArray* helpRequests;

        for (id rawRequest in rawHelpRequests) {
            [helpRequests addObject: [[HAHelpRequest alloc] initWithDictionary:rawRequest]];
        }

        success(helpRequests);
    } failure:^(id obj, NSError* error) {
        failure(error);
    }];
}

- (void)takeRequest:(NSString*) requestId success:(HAHelpRequestServiceSuccess)success failure:(HAHelpRequestServiceFailure)failure{
    [self.restRequest POSTrequest:@"agent/requests" withParameters:@{@"Id":requestId, @"TakeRequest": @true} success:^(id obj, NSHTTPURLResponse *response){
        success([[HAHelpRequest alloc] initWithDictionary:obj]);
    } failure:^(id obj, NSError* error) {
        failure(error);
    }];
}

- (void)finishRequest:(NSString*) requestId success:(HAHelpRequestServiceSuccess)success failure:(HAHelpRequestServiceFailure)failure{
    [self.restRequest POSTrequest:@"agent/requests" withParameters:@{@"Id":requestId, @"FinishRequest": @true} success:^(id obj, NSHTTPURLResponse *response){
        success([[HAHelpRequest alloc] initWithDictionary:obj]);
    } failure:^(id obj, NSError* error) {
        failure(error);
    }];
}

@end
