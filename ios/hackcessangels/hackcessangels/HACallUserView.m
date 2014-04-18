//
//  HACallUserViewController.m
//  hackcessangels
//
//  Created by Mac on 14/04/2014.
//
//

#import "HACallUserView.h"

@interface HACallUserView ()
@end



@implementation HACallUserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(IBAction)callUser:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"0668004086"]];
};


@end
