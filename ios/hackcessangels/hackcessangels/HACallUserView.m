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

- (void) hideProfile {
    CGRect frame = self.frame;
    frame.origin.y = -200;
    [UIView animateWithDuration:1.0 animations:^{
        [self setFrame:frame];
    }];
}

- (void) showProfile {
    CGRect frame = self.frame;
    frame.origin.y = 0.0;
    
    [UIView animateWithDuration:1.0 animations:^{
        [self setFrame:frame];
    }];
}

@end
