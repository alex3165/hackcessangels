//
//  localisation.m
//  HackcessAngels
//
//  Created by RIEUX Alexandre on 17/01/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "localisation.h"

@implementation localisation
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

//- (id)initWithName:(CLLocationCoordinate2D)coordinate {
- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}

@end
