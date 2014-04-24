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
#import "HAHelpProfileView.h"
#import "HACallUserView.h"


@interface HAMapViewController () <HACentralManagerDelegate>
@property (nonatomic, weak) IBOutlet HAHelpProfileView *helpProfileView;
@property (nonatomic, weak) IBOutlet HACallUserView *callUserView;
@property (nonatomic, weak) IBOutlet UIPanGestureRecognizer *gestureRecognizer;
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
    
    [self.gestureRecognizer setDelegate:self];
    
    self.bluetoothmanager = [[HACentralManager alloc] init];
    
    self.helpok.hidden = !self.bluetoothmanager.needHelp;
    
    self.bluetoothmanager.delegate = self;
}

- (IBAction)_panRecogPanned:(id)sender {
    switch ([(UIPanGestureRecognizer*)sender state]) {
        case UIGestureRecognizerStateBegan: { } break;
        case UIGestureRecognizerStateChanged: {
            
            /*if ( [((UIPanGestureRecognizer *)sender) locationInView:self.helpProfileView].y > dropDownButton.frame.height )
                return; // Only drag if the user's finger is on the button*/
            
            CGPoint translation = [self.gestureRecognizer translationInView:self.callUserView];
            
            //Note that we are omitting translation.x, otherwise the filterView will be able to move horizontally as well. Also note that that MIN and MAX were written for a subview which slides down from the top, they wont work on your subview.
            CGRect newFrame = self.gestureRecognizer.view.frame;
            //newFrame.origin.y = MIN (_panRecog.view.frame.origin.y + translation.y, FILTER_OPEN_ORIGIN_Y);
            //newFrame.origin.y = MAX (newFrame.origin.y, FILTER_INITIAL_ORIGIN_Y);
            newFrame.origin.y = self.gestureRecognizer.view.frame.origin.y + translation.y;
            if (newFrame.origin.y > 0) {
                return;
            }
            
            self.gestureRecognizer.view.frame = newFrame;
            
            [self.gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            
        } break;
            
            //Remember the optional step number 2? We will use hide/ show methods now:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            //CGPoint velocity = [_panRecog velocityInView:_panRecog.view];
            //Bonus points for using velocity when deciding what to do when if the user lifts his finger
            
            BOOL open;
            
            /*
             if (velocity.y < -600.0) {
             open = NO;
             }
             
             else if (velocity.y >= 600.0) {
             open = YES;
             } else
             */
            
            if (self.gestureRecognizer.view.frame.origin.y > -75 ) {
                open = YES;
            }
            
            else {
                open = NO;
            }
            
            if (open == YES) {
                [self.callUserView showProfile];
            }
            else {
                [self.callUserView hideProfile];
            }
        } break;
            
        default:
            break;
    }
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)ovl
{
    HATileOverlayView *view = [[HATileOverlayView alloc] initWithOverlay:ovl];
    view.tileAlpha = 1.0;
    return view ;
}


/******************************************************************************************************************************
 *
 *
 * Delegate
 *
 *
 *****************************************************************************************************************************/


#pragma mark - Delegate

-(void)helpValueChanged:(BOOL)newValue
{
    self.helpok.hidden = !newValue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end