//
//  EIUserProfilViewController.m
//  hackcessangels
//
//  Created by Mac on 28/05/2014.
//
//

#import "HAAgentUserProfileViewerViewController.h"

@interface HAAgentUserProfileViewerViewController ()
    @property (strong, nonatomic) HAHelpRequest * helpRequest;
@end

@implementation HAAgentUserProfileViewerViewController

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
    NSArray *namesplite = [self.helpRequest.user.name componentsSeparatedByString:@" "];
    NSString *phoneButtonTitle = [NSString stringWithFormat:@" Appeler %@",[namesplite objectAtIndex:0]];
    [self.Phone setTitle:phoneButtonTitle forState:UIControlStateNormal];
    
    [[self.urgencePhone layer] setBorderWidth:2.0f];
    [[self.urgencePhone layer] setBorderColor:[UIColor HA_purple].CGColor];
    [[self.urgencePhone layer] setCornerRadius:8.0f];
    
    self.name.text = self.helpRequest.user.name;
    
    self.infos.text = self.helpRequest.user.description;
    
    UIImage *userPicture = [UIImage imageWithData:self.helpRequest.user.image];
    [self.image setImage:userPicture];
    self.image.layer.cornerRadius = self.image.frame.size.height /2;
    self.image.layer.masksToBounds = YES;
    self.image.layer.borderWidth = 0;
    self.infos.text = self.helpRequest.user.description;
    self.handicap.text = [self.helpRequest.user getDisabilityString];
    
    // TODO(etienne): when calling, we should add the prefix to hide the caller ID.
    if (self.helpRequest.user.disabilityType == Hearing_SMS) {
        [self.Phone setTitle:@"Envoyer un SMS" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) passHaRequest:(HAHelpRequest *)harequest{
    self.helpRequest = harequest;
}

-(IBAction)callUser:(id)sender {
    if (self.helpRequest.user.disabilityType == Hearing_SMS) {
        NSString *SmsNum = [NSString stringWithFormat:@"sms:%@", self.helpRequest.user.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SmsNum]];
    }else{
        NSString *CallNum = [NSString stringWithFormat:@"tel:#31#%@", self.helpRequest.user.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CallNum]];
    }
}

-(IBAction)callUserEmergency:(id)sender{
        NSString *CallNum = [NSString stringWithFormat:@"tel:#31#%@", self.helpRequest.user.phoneUrgence];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CallNum]];
}

@end
