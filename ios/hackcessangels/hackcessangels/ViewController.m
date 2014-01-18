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
localisation *userLoc;
NSString * userPosition;

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
    
    // récupération de la position utilisateur
    userLoc = [[localisation alloc] init];
    //NSLog(@"%@",maPosition);
    [userLoc viewDidLoad];
    userPosition = [userLoc maPosition];
    if (userPosition != Nil) {
       NSLog(@"%@",userPosition);
    }
    
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