//
//  localisation.m
//  HackcessAngels
//
//  Created by RIEUX Alexandre on 17/01/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HALocalisation.h"

@implementation localisation

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        self.name = [name copy];
        self.address = [address copy];
        self.coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([self.name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return self.name;
}

- (NSString *)subtitle {
    return self.address;
}

@end