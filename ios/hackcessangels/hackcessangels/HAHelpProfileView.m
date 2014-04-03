//
//  HAHelpProfileView.m
//  hackcessangels
//
//  Created by Etienne Membrives on 03/04/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAHelpProfileView.h"

@interface HAHelpProfileView()
@property (nonatomic, weak) IBOutlet UIButton *showHideButton;
@end

@implementation HAHelpProfileView

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
    frame.origin.y = self.showHideButton.frame.size.height - self.frame.size.height;
    [self setFrame:frame];
}

- (void) showProfile {
    CGRect frame = self.frame;
    frame.origin.y = 0.0;
    [self setFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
