//
//  ViewController.h
//  HackcessAngels
//
//  Created by RIEUX Alexandre on 15/01/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TileOverlay.h"

@interface ViewController : UIViewController <MKMapViewDelegate> {

    //IBOutlet MKMapView *map;
}

@property (nonatomic , retain) TileOverlay *overlay;
@property (weak, nonatomic) IBOutlet MKMapView *map;

@end