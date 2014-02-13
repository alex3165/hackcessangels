//
//  ViewController.m
//  HackcessAngels
//
//  Created by RIEUX Alexandre on 15/01/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAHomeViewController.h"
#import "HATileOverlay.h"
#import "HATileOverlayView.h"
#import "HALocalisation.h"
#import "HAUserService.h"

//commentaire pour tester le git

@interface HAHomeViewController ()
//@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@end


@implementation HAHomeViewController

//@synthesize map;
//@synthesize overlay;
//localisation *userLoc;
//NSString * userPosition;
CLLocationCoordinate2D coordinate;

// Localisation de test
NSString * latitude = @"48.8566140";
NSString * longitude = @"2.3522219";
NSString * crimeDescription = @"Marc Fogel";
NSString * address = @"10 adresse des jonquilles";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* Initialisation de l'objet request ! */
    
    self.userService = [[HAUserService alloc] init];
    
    /**********************************/
    
    
    [self.userService getUserWithEmail:
     @"etienne@membrives.fr" success:^(NSDictionary *dico){
         NSLog(@"Success");
    } failure:^(NSError *error){
        NSLog(@"Failure");
    }];
    
    /*[self.userService POSTrequest:@"user" withParameters:@{@"email":@"julia.dirand@gmail.com",@"password":@"motdepasse"} success:^(NSDictionary *dico){
        
        NSLog(@"Success");
        
    } failure:^(NSError *error){
        
        NSLog(@"Failure");
    }];
    
    [self.userService DELETErequest:@"user" withParameters:@{@"email":@"julia.dirand@gmail.com",@"password":@"motdepasse"} success:^(NSDictionary *dico){
        
        NSLog(@"Delete Success");
        
    } failure:^(NSError *error){
        
        NSLog(@"Delete Failure");
    }];*/
    
    
//    self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL: [NSURL URLWithString:@"http://terra.membrives.fr/app/api/"]];
//    
//    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
//    //self.manager.baseURL = [NSURL URLWithString:@"http://terra.membrives.fr/app/api"];
//    [self.manager GET:@"user" parameters:@{@"email":@"etienne@membrives.fr"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([responseObject objectForKey:@"description"]== [NSNull null]) {
//            NSLog(@"hehe c'est nil");
//        }
//       // NSLog(@"%@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//       // NSLog(@"%@", error);
//    }];

    
   // NSArray *array = [[NSArray alloc] initWithObjects:@"1",@"2", nil];
   // NSArray *array = @[@"1",@"2"];
   // NSDictionary *dico = @{@"key",@"value"};
   // int test = 24;
   // NSNumber *number = @(test);
   // int integer = [number intValue];
    
    self.overlay = [[HATileOverlay alloc] initOverlay];
    [self.map addOverlay:self.overlay];
    MKMapRect visibleRect = [self.map mapRectThatFits:self.overlay.boundingMapRect];
    visibleRect.size.width /= 2;
    visibleRect.size.height /= 2;
    visibleRect.origin.x += visibleRect.size.width / 2;
    visibleRect.origin.y += visibleRect.size.height / 2;
    self.map.visibleMapRect = visibleRect;
    [self.map setUserTrackingMode:true];
    
    // Ajoute d'un marqueur de test
    
    coordinate.latitude = latitude.doubleValue;;
    coordinate.longitude = longitude.doubleValue;
    localisation *annotation = [[localisation alloc] initWithName:crimeDescription address:address coordinate:coordinate];
    [self.map addAnnotation:annotation];

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