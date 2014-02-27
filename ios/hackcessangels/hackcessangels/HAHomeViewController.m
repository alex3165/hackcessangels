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
#import "HAUser.h"

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
    self.restRequests = [[DCRestRequests alloc] init];
    
    
    /**********************************/

    /*[self.userService createUserWithEmailAndPassword:

>>>>>>> 5508f3f600c7c437568ebdca392f4c3d183ef23b
     @"user@domain.tld" password:@"password" success:^(NSDictionary *dico){
         NSLog(@"Create success");
         [self.userService loginWithEmailAndPassword:
          @"user@domain.tld" password:@"password" success:^(NSDictionary *dico){
              NSLog(@"Login success");
              [self.userService getUserWithEmail:
               @"user@domain.tld" success:^(NSDictionary *dico){
                   NSLog(@"Get success");
                   [self.userService deleteUserWithEmail:
                    @"user@domain.tld" success:^(NSDictionary *dico){
                        NSLog(@"Delete success");
                    } failure:^(NSError *error){
                        NSLog(@"Delete failure: %@", error);
                    }];
               } failure:^(NSError *error){
                   NSLog(@"Get failure: %@", error);
               }];
          } failure:^(NSError *error){
              NSLog(@"Login failure: %@", error);
          }];
     } failure:^(NSError *error){
         NSLog(@"Create failure: %@", error);
     }];*/



    /*[self.restRequests POSTrequest:@"user" withParameters:@{@"email":@"julia.dirand@gmail.com",@"password":@"motdepasse"} success:^(NSDictionary *dico){

        NSLog(@"Success post");
        
    } failure:^(NSError *error){
        
        NSLog(@"Failure");
    }];*/
    
//        [self.userService loginWithEmailAndPassword:
//     @"julia@gmail.com" password:@"mdp" success:^(NSDictionary *dico){
//         [self.userService update:@"julia@gmail.com" :@"julia131290@hotmail.com" success:^(NSDictionary *dico){
//             NSLog(@"Success update");
//         } failure:^(NSError *error){
//             NSLog(@"Failure");
//         }];
//         NSLog(@"Login success");
//     }failure:^(NSError *error){
//         NSLog(@"Failure");
//     }];
    

    [self.userService loginWithEmailAndPassword:@"julia.dirand@gmail.com" password:@"motdepasse" success:^(id obj){
        
        [self.userService updateUser:@"julia.dirand@gmail.com" withUpdatedEmail:@"julia131290@hotmail.com" success:^(NSDictionary *dico){
            NSLog(@"Success");
        } failure:^(NSError *error){
            NSLog(@"Failure");
        }];

    } failure:^(NSError *error) {
        
    }];


    
//    [self.restRequests DELETErequest:@"user" withParameters:@{@"email":@"julia.dirand@gmail.com",@"password":@"motdepasse"} success:^(NSDictionary *dico){
//        
//        NSLog(@"Delete Success");
//        
//    } failure:^(NSError *error){
//        
//        NSLog(@"Delete Failure");
//    }];
    
    
    //self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL: [NSURL URLWithString:@"http://terra.membrives.fr/app/api/"]];
    
  // self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
   
  //  self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
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