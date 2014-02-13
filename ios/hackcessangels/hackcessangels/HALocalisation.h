//
//  localisation.h
//  HackcessAngels
//
//  Created by RIEUX Alexandre on 17/01/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface localisation : NSObject 

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

//- (id)initWithName:(CLLocationCoordinate2D)coordinate;
- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
