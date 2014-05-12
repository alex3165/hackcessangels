//
//  HAHelpInProcess.m
//  hackcessangels
//
//  Created by RIEUX Alexandre on 09/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAHelpInProcess.h"

@interface HAHelpInProcess ()

@end

@implementation HAHelpInProcess

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the width of the line
    CGContextSetLineWidth(context, 2.0);
    
    //Make the circle
    // 150 = x coordinate
    // 150 = y coordinate
    // 100 = radius of circle
    // 0   = starting angle
    // 2*M_PI = end angle
    // YES = draw clockwise
    CGContextBeginPath(context);
    CGContextAddArc(context, 150, 150, 100, 0, 2*M_PI, YES);
    CGContextClosePath(context);
    
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0); //blue
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0); //red
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
