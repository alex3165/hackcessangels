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

    @property(nonatomic, strong) NSMutableDictionary* helpRequests;
@end

@implementation HARequestsService

+ (id)sharedInstance {
    static HARequestsService *sharedRequestService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRequestService = [[self alloc] init];
    });
    return sharedRequestService;
}

- (HARequestsService*)init {
    self = [super init];
    if (self) {
        self.restRequest = [[HARestRequests alloc]init];
        self.helpRequests = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/* GET : récupérer les requêtes en cours */
- (void)getRequests:(HAHelpRequestServiceListSuccess)success failure:(HAHelpRequestServiceFailure)failure{
    [self.restRequest GETrequest:@"agent/requests" withParameters:nil success:^(id obj, NSHTTPURLResponse *response){
        // obj is a list of dictionnaries, each one representing a single help request.
        NSMutableArray* rawHelpRequests = [[NSMutableArray alloc] initWithArray: obj];
        NSMutableArray* helpRequests = [[NSMutableArray alloc] init];

        // Convert all raw dictionaries into Objective-C objects.
        for (id rawRequest in rawHelpRequests) {
            [helpRequests addObject: [[HAHelpRequest alloc] initWithDictionary:rawRequest]];
        }

        // We find which requests are new and which we already know.
        NSMutableDictionary* newHelpRequestsDict = [[NSMutableDictionary alloc] init];
        for (HAHelpRequest* helpRequest in helpRequests) {
            [newHelpRequestsDict setObject:helpRequest forKey:helpRequest.Id];
            if ([self.helpRequests objectForKey:helpRequest.Id] == nil) {
                // This request is new; we have to create a local notification to alert the agent of the new request if the user still needs help.
                if ([helpRequest needsHelp]) {
                    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                    localNotif.alertBody = [NSString stringWithFormat:@"%@ a besoin de votre aide", helpRequest.user.name];
                    localNotif.alertAction = @"Aide'gare: Appel à l'aide";
                    localNotif.soundName = UILocalNotificationDefaultSoundName;
                    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[helpRequest toPropertyList], @"helpRequest", nil];
                    localNotif.userInfo = userInfo;
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
                    helpRequest.notification = localNotif;
                }
            } else {
                HAHelpRequest* storedHelpRequest = [self.helpRequests objectForKey:helpRequest.Id];
                // This is an update of an existing request.
                if (![storedHelpRequest needsHelp]) {
                    // The user does not need help. Cancel any pending local notification
                    if (storedHelpRequest.notification != nil) {
                        [[UIApplication sharedApplication] cancelLocalNotification:storedHelpRequest.notification];
                    }
                } else if (storedHelpRequest.status == kRetry) {
                    [[UIApplication sharedApplication] cancelLocalNotification:storedHelpRequest.notification];
                    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                    localNotif.alertBody = [NSString stringWithFormat:@"%@ a besoin de votre aide", helpRequest.user.name];
                    localNotif.alertAction = @"Aide'gare: Appel à l'aide";
                    localNotif.soundName = UILocalNotificationDefaultSoundName;
                    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[helpRequest toPropertyList], @"helpRequest", nil];
                    localNotif.userInfo = userInfo;
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
                    helpRequest.notification = localNotif;
                }
            }
        }
        if ([helpRequests count] == 0) {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
        self.helpRequests = newHelpRequestsDict;
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
    [self.restRequest POSTrequest:@"agent/requests" withParameters:@{@"requestid":request.Id, @"TakeRequest": @YES} success:^(id obj, NSHTTPURLResponse *response){
        success([[HAHelpRequest alloc] initWithDictionary:obj]);
    } failure:^(id obj, NSError* error) {
        failure(error);
    }];
}

- (void)finishRequest:(HAHelpRequest*) request success:(HAHelpRequestServiceSuccess)success failure:(HAHelpRequestServiceFailure)failure{
    [self.restRequest POSTrequest:@"agent/requests" withParameters:@{@"requestid":request.Id, @"FinishRequest": @YES} success:^(id obj, NSHTTPURLResponse *response){
        success([[HAHelpRequest alloc] initWithDictionary:obj]);
    } failure:^(id obj, NSError* error) {
        failure(error);
    }];
}

@end
