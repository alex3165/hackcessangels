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
#import "HAFirstProfilViewController.h"

static NSString* const hasRunAppOnceKey = @"hasRunAppOnceKey";

@interface HAHelpViewController ()
    @property (nonatomic, strong) HAUser *user;
    @property (nonatomic, strong) NSMutableString *helloUser;
    @property (nonatomic, strong) HAHelpRequest* helpRequest;

    @property (nonatomic, strong) HAAssistanceService *assistanceService;
    @property (nonatomic, strong) HAUserService *userService;
    @property (nonatomic, strong) UIActivityIndicatorView *spinner;
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
    [[self.cancelHelp layer] setBorderWidth:1.0f];
    [[self.cancelHelp layer] setCornerRadius:5.0f];
    [[self.cancelHelp layer] setBorderColor:[UIColor HA_red].CGColor];
    self.titleLabel.textColor = [UIColor HA_purple];
    self.whoStatus.textColor = [UIColor HA_purple];
    self.whatStatus.textColor = [UIColor HA_green];
    self.view.backgroundColor = [UIColor HA_graybg];
    self.timeNotification.backgroundColor = [UIColor HA_purple];
    self.timeNotification.textColor = [UIColor HA_graybg];
    
    self.assistanceService = [HAAssistanceService sharedInstance];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkUser];
}

- (IBAction)helpme:(id)sender {
    if (self.helpRequest != nil && self.helpRequest.status == kTimeout) {
        [self.assistanceService retryHelp];
        [self requestAgentContactedStatus];
    }
    [self.assistanceService startHelpRequest:^(HAHelpRequest *helpRequest) {
        self.helpRequest = helpRequest;
        HAHelpSuccessViewController *helpSuccessViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"helpSuccess"];
        
        switch (self.helpRequest.status) {
            case kNew:
            case kRetry:
            case kAgentsContacted:
                [self requestAgentContactedStatus];
                break;
            case kCancelled:
                [self requestAgentCancelStatus];
                break;
            case kTimeout:
                [self requestAgentTryAgainStatus];
                break;
            case kAbandonned:
                [self requestAgentFailedAgainStatus];
                break;
            case kAgentAnswered:
                helpSuccessViewController.helpRequest = self.helpRequest;
                [self presentViewController:helpSuccessViewController animated:YES completion:nil];
                break;
            case kNotInStation:
                // Faire la vue vous n'êtes pas dans la station
            default:
                [self defaultRequestAgentStatus];
                break;
        }
    } failure:^(id obj, NSError *error) {
        DLog("Erreur dans la demande d'assistance: %@", error);
    }];
}

-(IBAction)cancelHelp:(id)sender{
    [self.assistanceService stopHelpRequest];
    [self requestAgentCancelStatus];
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(defaultRequestAgentStatus) userInfo:nil repeats:NO];
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
    if (self.spinner == nil) {
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.spinner.center = self.helpme.center;
        self.spinner.tag = 12;
        self.spinner.color = [UIColor whiteColor];
        self.spinner.transform = CGAffineTransformMakeScale(2.4,2.4);
        [self.view addSubview: self.spinner];
        [self.spinner startAnimating];
    }
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
    [self.spinner removeFromSuperview];
    self.spinner = nil;
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
    [self.spinner removeFromSuperview];
    self.spinner = nil;
}

-(void)defaultRequestAgentStatus {
    self.whatStatus.hidden = true;
    self.whoStatus.hidden = true;
    self.timeNotification.hidden = true;
    self.titleLabel.hidden = false;
    self.urgencyNumber.hidden = true;
    self.cancelHelp.hidden = true;
    UIImage *imageHelp = [UIImage imageNamed:@"help.png"];
    self.helpme.userInteractionEnabled = YES;
    [self.helpme setBackgroundImage:imageHelp forState:UIControlStateNormal];
    [self.spinner removeFromSuperview];
    self.spinner = nil;
    self.helpRequest = nil;
}

-(void)requestAgentCancelStatus{
    self.whoStatus.hidden = false;
    NSString *whoStatus = [NSString stringWithFormat:@"Demande d'aide annulée"];
    self.whoStatus.text = whoStatus;
    self.whatStatus.hidden = true;
    self.timeNotification.hidden = true;
    self.titleLabel.hidden = true;
    self.cancelHelp.hidden = true;
    self.urgencyNumber.hidden = true;
    UIImage *imageHelp = [UIImage imageNamed:@"help.png"];
    [self.helpme setBackgroundImage:imageHelp forState:UIControlStateNormal];
    [self.spinner removeFromSuperview];
    self.spinner = nil;
    [self checkUser];
}

-(void) outOfGareStatus{
    self.whoStatus.hidden = false;
    NSString *whoStatus = [NSString stringWithFormat:@"Vous n'êtes pas dans une gare SNCF Transilien"];
    self.whoStatus.text = whoStatus;
    self.whatStatus.hidden = false;
    NSString *whatStatus = [NSString stringWithFormat:@"Si vous êtes en difficulté,"];
    self.whatStatus.text = whatStatus;
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
        [self defaultRequestAgentStatus];
    } failure:^(NSError *error) {
        if (error.code == 401 || error.code == 404) {
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    // test si c'est la première utilisation de l'app si oui on ouvre le registration controller sinon le login controller
            if ([defaults boolForKey:hasRunAppOnceKey] == NO)
            {
                [self showModalLoginWithAnimation:NO];
                [defaults setBool:YES forKey:hasRunAppOnceKey];
            }else{
                [self showModalLoginWithAnimation:NO];
            }
            
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
