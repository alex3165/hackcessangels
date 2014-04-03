//
//  ViewController.m
//  HackcessAngels
//
//  Created by RIEUX Alexandre on 15/01/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAMapViewController.h"
#import "HATileOverlay.h"
#import "HATileOverlayView.h"
#import "HAUser.h"


@interface HAMapViewController ()
@end


@implementation HAMapViewController

CLLocationCoordinate2D coordinate;

// Localisation de test
NSString * latitude = @"48.8566140";
NSString * longitude = @"2.3522219";
NSString * crimeDescription = @"Marc Fogel";
NSString * address = @"10 adresse des jonquilles";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.overlay = [[HATileOverlay alloc] initOverlay];
        [self.map addOverlay:self.overlay];
        MKMapRect visibleRect = [self.map mapRectThatFits:self.overlay.boundingMapRect];
        visibleRect.size.width /= 2;
        visibleRect.size.height /= 2;
        visibleRect.origin.x += visibleRect.size.width / 2;
        visibleRect.origin.y += visibleRect.size.height / 2;
        self.map.visibleMapRect = visibleRect;
        [self.map setUserTrackingMode:true];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    /* Ajoute d'un marqueur de test */
    
//    coordinate.latitude = latitude.doubleValue;;
//    coordinate.longitude = longitude.doubleValue;
//    localisation *annotation = [[localisation alloc] initWithName:crimeDescription address:address coordinate:coordinate];
//    [self.map addAnnotation:annotation];

}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)ovl
{
    HATileOverlayView *view = [[HATileOverlayView alloc] initWithOverlay:ovl];
    view.tileAlpha = 1.0;
    return view ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end