//
//  HARequestsService.h
//  hackcessangels
//
//  Created by RIEUX Alexandre on 29/04/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HARestRequests.h"


@interface HARequestsService : NSObject

- (void)savePosition:(double)longitude latitude:(double)latitude success:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure;
- (void)getRequests:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure;
- (void)takeRequest:(HARestRequestsSuccess)success failure:(HARestRequestsFailure)failure;

/* Renommage des constantes HAAgent + commentaire des failures du service, service utile ? --> pattern Factory*/
/* Pas compris le PUT */
/* HAAssistanceService Pk successCallback ? l.30 déclaration .h */
/* HAAssistanceService, pourquoi ne pas faire qu'un objet restRequest plutot que de le déclarer dans chaque méthodes ? */
/* voir ce que retourne le getRequest / Objet Requests ? juste un string id qu'on stock temporairement dans HARequestService ? */

@end
