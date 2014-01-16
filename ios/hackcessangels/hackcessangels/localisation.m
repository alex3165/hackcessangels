//
//  localisation.m
//  HackcessAngels
//
//  Created by RIEUX Alexandre on 16/01/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "localisation.h"

@interface localisation ()

@end

@implementation localisation

@synthesize maPosition;
//NSString * maPosition;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled])
    {
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 100.0f;
        [locationManager startUpdatingLocation];
        
    }
}




-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    maPosition = [newLocation description];
    //NSLog(@"%@",maPosition);
    
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    maPosition = [error description];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end