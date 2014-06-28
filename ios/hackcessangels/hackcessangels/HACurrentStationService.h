//
//  HACurrentStationService.h
//  hackcessangels
//
//  Created by Etienne Membrives on 19/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HACurrentStationService : NSObject<NSStreamDelegate>

+ (id)sharedInstance;
- (void) connectToServer;

@end
