//
//  HAHelpRequest.m
//  hackcessangels
//
//  Created by Etienne Membrives on 12/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAHelpRequest.h"

NSString *const kIdKey = @"Id";
NSString *const kLatitudeKey = @"Latitude";
NSString *const kLongitudeKey = @"Longitude";
NSString *const kPrecisionKey = @"Precision";
NSString *const kAgentKey = @"agent";
NSString *const kUserKey = @"user";
NSString *const kStatusKey = @"CurrentState";

@implementation HAHelpRequest

- (id)initWithDictionary:(NSDictionary *)data {
    self = [super init];
    
    if (self) {
        self.Id = [data objectForKey:kIdKey];
        self.latitude = [[data objectForKey:kLatitudeKey] doubleValue];
        self.longitude = [[data objectForKey:kLongitudeKey] doubleValue];
        self.precision = [[data objectForKey:kPrecisionKey] doubleValue];
        if ([data objectForKey:kAgentKey] != nil) {
            self.agent = [[HAAgent alloc] initWithDictionary:[data objectForKey:kAgentKey]];
        }
        if ([data objectForKey:kUserKey] != nil) {
            self.user = [[HAUser alloc] initWithDictionary:[data objectForKey:kUserKey]];
        }
        self.status = [[data objectForKey:kStatusKey] integerValue];
    }
    return self;
}

- (NSDictionary*) toPropertyList {
    NSMutableDictionary* dico = [[NSMutableDictionary alloc] init];
    [dico setValue:self.Id forKey:kIdKey];
    [dico setValue:[NSNumber numberWithDouble:self.latitude] forKey:kLatitudeKey];
    [dico setValue:[NSNumber numberWithDouble:self.longitude] forKey:kLongitudeKey];
    [dico setValue:[NSNumber numberWithDouble:self.precision] forKey:kPrecisionKey];
    [dico setValue:[self.agent toPropertyList] forKey:kAgentKey];
    [dico setValue:[self.user toPropertyList] forKey:kUserKey];
    [dico setValue:[NSNumber numberWithInt:self.status] forKey:kStatusKey];
    return dico;
}

@end
