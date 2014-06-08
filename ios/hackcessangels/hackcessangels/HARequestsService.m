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
        NSMutableArray* helpRequests = [[NSMutableArray alloc] init];

        for (id rawRequest in rawHelpRequests) {
            [helpRequests addObject: [[HAHelpRequest alloc] initWithDictionary:rawRequest]];
        }

        success(helpRequests);
    } failure:^(id obj, NSError* error) {
        failure(error);
    }];
}

- (void)updateRequest:(HAHelpRequest *)request success:(HAHelpRequestServiceSuccess)success failure:(HAHelpRequestServiceFailure)failure {
    [self.restRequest GETrequest:@"agent/requests" withParameters:@{@"requestid": request.Id} success:^(id obj, NSHTTPURLResponse *response){
        // obj is a single help request, as we are requesting a request with a specific ID.
        HAHelpRequest *helpRequest = [[HAHelpRequest alloc] initWithDictionary:obj];
        success(helpRequest);
    } failure:^(id obj, NSError* error) {
        failure(error);
    }];
}

- (void)takeRequest:(HAHelpRequest *)request success:(HAHelpRequestServiceSuccess)success failure:(HAHelpRequestServiceFailure)failure {
    [self.restRequest POSTrequest:@"agent/requests" withParameters:@{@"Id":request.Id, @"TakeRequest": @true} success:^(id obj, NSHTTPURLResponse *response){
        success([[HAHelpRequest alloc] initWithDictionary:obj]);
    } failure:^(id obj, NSError* error) {
        failure(error);
    }];
}

- (void)finishRequest:(HAHelpRequest*) request success:(HAHelpRequestServiceSuccess)success failure:(HAHelpRequestServiceFailure)failure{
    [self.restRequest POSTrequest:@"agent/requests" withParameters:@{@"Id":request.Id, @"FinishRequest": @true} success:^(id obj, NSHTTPURLResponse *response){
        success([[HAHelpRequest alloc] initWithDictionary:obj]);
    } failure:^(id obj, NSError* error) {
        failure(error);
    }];
}

@end
