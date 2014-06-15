

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
    
    
    //A METTRE A LA BONNE COULEUR
    //[self.topLabel setBackgroundColor:[UIColor:blue]];
    self.name.text = self.helpRequest.user.name;
    self.infos.text = self.helpRequest.user.description;
    UIImage *userPicture = [UIImage imageWithData:self.helpRequest.user.image];
    [self.image setImage:userPicture];
    
    switch (self.helpRequest.user.disabilityType) {
        case Physical_wheelchair:
            self.handicap.text=@"Handicap moteur. Je suis en chaise roulante";
            break;
        case    Physical_powerchair:
            self.handicap.text=@" Handicap moteur. Je suis en chaise électrique";
            break;
        case  Physical_walk:
            self.handicap.text=@"Handicap moteur. J'ai des problèmes de marche.";
            break;
        case   Vision_blind :
            self.handicap.text=@"Handicap visuel. Je suis aveugle.";
            break;
        case   Vision_lowvision:
            self.handicap.text=@"Handicap visuel. J'ai une mauvaise vue";
            break;
        case Hearing_call:
            self.handicap.text=@"Handicap auditif. Je répond aux appels.";
            break;
        case Hearing_SMS:
            self.handicap.text=@"Handicap auditif. Je répond aux sms.";
            break;
        case Mental:
            self.handicap.text=@"Handicap Mental";
            break;
        case Other:
            self.handicap.text=@"Handicap Autre";
            break;
        case Unknown:
            self.handicap.text=@"Handicap inconnu";
            break;
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) passHaRequest:(HAHelpRequest *)harequest{
    self.helpRequest = harequest;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
