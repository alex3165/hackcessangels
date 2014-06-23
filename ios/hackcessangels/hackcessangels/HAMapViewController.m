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
#import "HACallUserView.h"
#import "HARequestsService.h"
#import "HAAgentUserProfileViewerViewController.h"
#import "HAAgentHomeViewController.h"


@interface HAMapViewController () <HACentralManagerDelegate>
    @property (nonatomic, weak) IBOutlet HACallUserView *callUserView;
    @property (nonatomic, weak) IBOutlet UIPanGestureRecognizer *gestureRecognizer;
    @property (nonatomic, strong) NSUUID *uuid;

    @property (nonatomic, strong) HARequestsService* requestService;
    @property (nonatomic, weak) NSTimer* timer;
@end

NSTimeInterval const kRequestUpdateTimeInterval = 5;// * 60.0;

@implementation HAMapViewController

CLLocationCoordinate2D coordinate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.requestService = [HARequestsService sharedInstance];
    
    self.userPicture.layer.cornerRadius = self.userPicture.frame.size.height /2;
    self.userPicture.layer.masksToBounds = YES;
    self.userPicture.layer.borderWidth = 0;
    
    [self.gestureRecognizer setDelegate:self];
    
    self.bluetoothmanager = [[HACentralManager alloc] init];
    
    self.bluetoothmanager.delegate = self;
    
    self.overlay = [[HATileOverlay alloc] initOverlay];
    [self.map addOverlay:self.overlay];
    [self.map setUserTrackingMode:MKUserTrackingModeFollow];
    if (self.helpRequest) {
        [self.map addAnnotation:self.helpRequest];
        self.timer = [NSTimer timerWithTimeInterval:kRequestUpdateTimeInterval target:self selector:@selector(updateHelpRequest) userInfo:nil repeats:@YES];
    }
    [self updateDisplay];
}

- (void) updateTimerFired:(NSTimer*) timer {
    [self updateHelpRequest];
}

- (void) updateHelpRequest {
    [self.requestService updateRequest:self.helpRequest success:^(HAHelpRequest *helpRequest) {
        self.helpRequest = helpRequest;
        [self updateDisplay];
    } failure:^(NSError *error) {
        DLog(@"Error while updating help request: %@", error);
    }];
}

// This method should be used for all code that takes self.helpRequest and updates the content of the screen (profile, map, etc...) with it
- (void) updateDisplay {
    if (self.helpRequest == nil) {
        // No help request: it comes from Bluetooth
        // TODO(etienne): add a field in HAHelpRequest to know the provenance of the request (bluetooth/server)
        [self.helpok setHidden:!self.bluetoothmanager.needHelp];
    } else {
        if ([self.helpRequest finished]) {
            [self.timer invalidate];
            UITabBarController *tabBarController = (UITabBarController*)[[[UIApplication sharedApplication] keyWindow] rootViewController];
            [tabBarController setSelectedIndex:0];
            return;
        }
        // Display user infos
        self.userDisability.hidden = FALSE;
        self.completeProfil.hidden = FALSE;
        self.userPicture.hidden = FALSE;
        self.userName.hidden = FALSE;
        
        self.userName.text = self.helpRequest.user.name;
        self.userPicture.image = [UIImage imageWithData:self.helpRequest.user.image];

        switch (self.helpRequest.user.disabilityType) {
            case Physical_wheelchair:
                self.userDisability.text=@"Handicap moteur. Je suis en chaise roulante";
                break;
            case    Physical_powerchair:
                self.userDisability.text=@" Handicap moteur. Je suis en chaise électrique";
                break;
            case  Physical_walk:
                self.userDisability.text=@"Handicap moteur. J'ai des problèmes de marche.";
                break;
            case   Vision_blind :
                self.userDisability.text=@"Handicap visuel. Je suis aveugle.";
                break;
            case   Vision_lowvision:
                self.userDisability.text=@"Handicap visuel. J'ai une mauvaise vue";
                break;
            case Hearing_call:
                self.userDisability.text=@"Handicap auditif. Je répond aux appels.";
                break;
            case Hearing_SMS:
                self.userDisability.text=@"Handicap auditif. Je répond aux sms.";
                break;
            case Mental:
                self.userDisability.text=@"Handicap Mental";
                break;
            case Other:
                self.userDisability.text=@"Handicap Autre";
                break;
            case Unknown:
                self.userDisability.text=@"Handicap inconnu";
                break;
        }
        bool needsHelp = [self.helpRequest needsHelp];
        [self.helpok setHidden:!needsHelp];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[HAHelpRequest class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView* pinView = (MKPinAnnotationView*)[self.map dequeueReusableAnnotationViewWithIdentifier:@"HAHelpRequestAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            MKPinAnnotationView* pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"HAHelpRequestAnnotationView"];
            pinView.pinColor = MKPinAnnotationColorPurple;
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
        } else {
            pinView.annotation = annotation;
        }
        
        return pinView;
    }
    
    return nil;
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
            if (newFrame.origin.y > -20) {
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

-(IBAction)showCompleteProfil:(id)sender{
   HAAgentUserProfileViewerViewController * completeProfilController = [[UIStoryboard storyboardWithName:@"Agent" bundle:nil] instantiateViewControllerWithIdentifier:@"completeProfil"];
    [completeProfilController passHaRequest:self.helpRequest];
    [self.navigationController pushViewController:completeProfilController animated:YES];

}

- (IBAction)PositiveAnswerForHelp:(id)sender {
    [self.bluetoothmanager takeRequest:self.uuid];
    [self.requestService takeRequest:self.helpRequest success:^(HAHelpRequest *helpRequest) {
        self.helpRequest = helpRequest;
        [self updateDisplay];
    } failure:^(NSError *error) {
        DLog(@"Failure taking the request: %@", error);
    }];
}

/******************************************************************************************************************************
 *
 *
 * Delegate
 *
 *
 *****************************************************************************************************************************/

#pragma mark - Delegate

- (void)helpValueChanged:(BOOL)newValue user:(NSDictionary *)user uuid:(NSUUID *)uuid
{
    [self.helpok setHidden:!newValue];
    self.uuid = uuid;
    /* notification d'appel à l'aide */
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.alertBody = @"quelqu'un a besoin de votre aide";
    localNotif.alertAction = @"Appel à l'aide";
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end