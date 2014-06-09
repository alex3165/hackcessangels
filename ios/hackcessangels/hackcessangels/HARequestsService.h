//
//  HARequestsService.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 29/04/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HARestRequests.h"
#import "HAHelpRequest.h"

typedef void(^HAHelpRequestServiceListSuccess)(NSArray *helpRequestList);
typedef void(^HAHelpRequestServiceSuccess)(HAHelpRequest *helpRequest);
typedef void(^HAHelpRequestServiceFailure)(NSError *error);

@interface HARequestsService : NSObject

- (void)getRequests:(HAHelpRequestServiceListSuccess)success failure:(HAHelpRequestServiceFailure)failure;
- (void)updateRequest:(HAHelpRequest*) request success:(HAHelpRequestServiceSuccess)success failure:(HAHelpRequestServiceFailure)failure;
- (void)takeRequest:(HAHelpRequest*) request success:(HAHelpRequestServiceSuccess)success failure:(HAHelpRequestServiceFailure)failure;
- (void)finishRequest:(HAHelpRequest*) request success:(HAHelpRequestServiceSuccess)success failure:(HAHelpRequestServiceFailure)failure;

/* Renommage des constantes HAAgent + commentaire des failures du service, service utile ? --> pattern Factory*/
/* Pas compris le PUT */
/* HAAssistanceService Pk successCallback ? l.30 déclaration .h */
/* HAAssistanceService, pourquoi ne pas faire qu'un objet restRequest plutot que de le déclarer dans chaque méthodes ? */
/* voir ce que retourne le getRequest / Objet Requests ? juste un string id qu'on stock temporairement dans HARequestService ? */

@end
