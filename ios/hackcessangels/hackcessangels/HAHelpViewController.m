//
//  HAHelpViewController.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 23/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAHelpViewController.h"
#import "HALogViewController.h"
#import "HAHelpSuccessViewController.h"
#import "HAUserService.h"
#import "HAUserViewController.h"
#import "UIColor+HackcessAngels.h"

@interface HAHelpViewController ()
    @property (nonatomic, strong) HAUser *user;
    @property (nonatomic, strong) NSMutableString *helloUser;
    @property (nonatomic, strong) HAHelpRequest* helpRequest;
@end

@implementation HAHelpViewController

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
    [self checkUser];
    [[self.cancelHelp layer] setBorderWidth:1.0f];
    [[self.cancelHelp layer] setCornerRadius:5.0f];
    [[self.cancelHelp layer] setBorderColor:[UIColor HA_red].CGColor];
    self.titleLabel.textColor = [UIColor HA_purple];
    self.whoStatus.textColor = [UIColor HA_purple];
    self.whatStatus.textColor = [UIColor HA_green];
    self.view.backgroundColor = [UIColor HA_graybg];
    self.timeNotification.backgroundColor = [UIColor HA_purple];
    self.timeNotification.textColor = [UIColor HA_graybg];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)helpme:(id)sender {
    self.assistanceService = [[HAAssistanceService alloc] init];
    HAHelpSuccessViewController *helpSuccessViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"helpSuccess"];
    [helpSuccessViewController getHAHelpRequest:self.helpRequest];
    [self presentViewController:helpSuccessViewController animated:YES completion:nil];
    
//    [self.assistanceService startHelpRequest:^(HAHelpRequest *helpRequest) {
//        self.helpRequest = helpRequest;
//        HAHelpSuccessViewController *helpSuccessViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"helpSuccess"];
//
//        switch (self.helpRequest.status) {
//            case kAgentsContacted:
//                [self requestAgentContactedStatus];
//            case kRetry:
//                [self requestAgentContactedStatus];
//            case kCancelled:
//                [self requestAgentCancelStatus];
//            case kTimeout:
//                [self requestAgentTryAgainStatus];
//            case kAbandonned:
//                [self requestAgentFailedAgainStatus];
//            case kAgentAnswered:
//                [helpSuccessViewController getHAHelpRequest:self.helpRequest];
//                [self presentViewController:helpSuccessViewController animated:YES completion:nil];
//            case kNotInStation:
//                // Faire la vue vous n'êtes pas dans la station
//            default:
//                [self defaultRequestAgentStatus];
//                break;
//        }
//    } failure:^(id obj, NSError *error) {
//        DLog("Erreur dans la demande d'assistance: %@", error);
//    }];
}

-(IBAction)cancelHelp:(id)sender{
    self.assistanceService = [[HAAssistanceService alloc] init];
    [self.assistanceService stopHelpRequest];
}

- (void)requestAgentContactedStatus {
    self.titleLabel.hidden = true;
    self.whatStatus.hidden = false;
    self.whoStatus.hidden = false;
    self.cancelHelp.hidden = false;
    self.urgencyNumber.hidden = true;
    self.timeNotification.hidden = false;
    self.helpme.userInteractionEnabled = NO;
    UIImage *imageHelpInFlight = [UIImage imageNamed:@"EnCours.png"];
    [self.helpme setBackgroundImage:imageHelpInFlight forState:UIControlStateNormal];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 290);
    spinner.tag = 12;
    spinner.color = [UIColor whiteColor];
    spinner.transform = CGAffineTransformMakeScale(2.4,2.4);
    [self.view addSubview:spinner];
    [spinner startAnimating];
}

-(void)requestAgentTryAgainStatus {
    self.titleLabel.hidden = true;
    self.timeNotification.hidden = true;
    self.urgencyNumber.hidden = true;
    self.helpme.userInteractionEnabled = YES;
    NSString *agentStatus = [NSString stringWithFormat:@"Les agents sont occupés."];
    self.whoStatus.hidden = false;
    self.whoStatus.text = agentStatus;
    NSString *whatStatus = [NSString stringWithFormat:@"Votre demande n'a pas pu aboutir."];
    self.whatStatus.hidden = false;
    self.whatStatus.text = whatStatus;
    self.whatStatus.textColor = [UIColor HA_red];
    UIImage *imageHelpFailed = [UIImage imageNamed:@"NonAboutie.png"];
    [self.helpme setBackgroundImage:imageHelpFailed forState:UIControlStateNormal];
}
-(void) requestAgentFailedAgainStatus{
    self.titleLabel.hidden = true;
    self.timeNotification.hidden = true;
    self.urgencyNumber.hidden = false;
    NSString *agentStatus = [NSString stringWithFormat:@"Les agents sont occupés."];
    self.whoStatus.hidden = false;
    self.whoStatus.text = agentStatus;
    NSString *whatStatus = [NSString stringWithFormat:@"En cas de danger ou malaise,"];
    self.whatStatus.hidden = false;
    self.whatStatus.text = whatStatus;
    self.whatStatus.textColor = [UIColor HA_red];
    UIImage *imageHelpFailed = [UIImage imageNamed:@"NonAboutie.png"];
    [self.helpme setBackgroundImage:imageHelpFailed forState:UIControlStateNormal];
}
-(void)defaultRequestAgentStatus {
    self.whatStatus.hidden = true;
    self.whoStatus.hidden = true;
    self.timeNotification.hidden = true;
    self.titleLabel.hidden = false;
    self.urgencyNumber.hidden = true;
    UIImage *imageHelp = [UIImage imageNamed:@"help.png"];
    self.helpme.userInteractionEnabled = YES;
    [self.helpme setBackgroundImage:imageHelp forState:UIControlStateNormal];
}

-(void)requestAgentCancelStatus{
    self.whoStatus.hidden = false;
    NSString *whoStatus = [NSString stringWithFormat:@"Demande d'aide annulée"];
    self.whoStatus.text = whoStatus;
    self.whatStatus.hidden = true;
    self.timeNotification.hidden = true;
    self.titleLabel.hidden = true;
    UIImage *imageHelp = [UIImage imageNamed:@"help.png"];
    [self.helpme setBackgroundImage:imageHelp forState:UIControlStateNormal];
}
/******************************************************************************************************************************
 *
 *
 * Service
 *
 *
 *****************************************************************************************************************************/


#pragma mark - Service

- (void)checkUser
{
    self.userService = [HAUserService sharedInstance];
    
    [self.userService getCurrentUser:^(HAUser *user) {
        DLog(@"Success");
        NSString *helloName = [NSString stringWithFormat:@"Bonjour %@", user.name];
        self.titleLabel.text = helloName;
    } failure:^(NSError *error) {
        if (error.code == 401 || error.code == 404) {
            [self showModalLoginWithAnimation:NO];
        }
    }];
}


/******************************************************************************************************************************
 *
 *
 * Utils
 *
 *
 *****************************************************************************************************************************/


#pragma mark - Utils

- (void)showModalLoginWithAnimation:(BOOL)animated
{
    HALogViewController *logViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
    [logViewController setCheckCredentialsBlock:[[HAUserService sharedInstance] getCheckCredentialsBlock]];
    [self presentViewController:logViewController animated:animated completion:nil];
}



-(void) showProfil: (id)sender
{
    HAUserViewController *userViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"userProfilController"];
   // [logViewController setCheckCredentialsBlock:[[HAUserService sharedInstance] getCheckCredentialsBlock]];
    [self presentViewController:userViewController animated:NO completion:nil];
}


@end
