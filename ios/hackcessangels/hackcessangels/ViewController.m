//
//  ViewController.m
//  HackcessAngels
//
//  Created by RIEUX Alexandre on 15/01/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "ViewController.h"
#import "TileOverlay.h"
#import "TileOverlayView.h"
#import "localisation.h"


@interface ViewController ()

@end


@implementation ViewController

@synthesize map;
@synthesize overlay;
//localisation *userLoc;
//NSString * userPosition;
CLLocationCoordinate2D coordinate;

// Localisation de test
NSString * latitude = @"48.8566140";
NSString * longitude = @"2.3522219";
NSString * crimeDescription =@"Marc Fogel";
NSString * address = @"10 adresse des jonquilles";

- (void)viewDidLoad
{
    [super viewDidLoad];
    overlay = [[TileOverlay alloc] initOverlay];
    [map addOverlay:overlay];
    MKMapRect visibleRect = [map mapRectThatFits:overlay.boundingMapRect];
    visibleRect.size.width /= 2;
    visibleRect.size.height /= 2;
    visibleRect.origin.x += visibleRect.size.width / 2;
    visibleRect.origin.y += visibleRect.size.height / 2;
    map.visibleMapRect = visibleRect;
    [map setUserTrackingMode:true];
    
    // Ajoute d'un marqueur de test
    
    coordinate.latitude = latitude.doubleValue;;
    coordinate.longitude = longitude.doubleValue;
    localisation *annotation = [[localisation alloc] initWithName:crimeDescription address:address coordinate:coordinate];
    //MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    //MyPin.image = [UIImage imageNamed:@"pin.png"];
    [map addAnnotation:annotation];
//    NSURL *url = [NSURL URLWithString:@"http://www.32133.com/test?name=xx"];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"ret=%@", ret);
    NSString *serverAddress = @"http://polaris.membrives.fr:5000/user?id=63550";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverAddress]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    //NSError *test;
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *ret = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    //NSString *ret2 = [[NSString alloc] initWithContentsOfURL:urlResponse encoding:NSUTF8StringEncoding error:test ];
    //NSLog(@"ret=%@", ret);
    //NSLog(@"%p", &ret);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)ovl
{
    TileOverlayView *view = [[TileOverlayView alloc] initWithOverlay:ovl];
    view.tileAlpha = 1.0;
    return view ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end