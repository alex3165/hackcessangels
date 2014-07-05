//
//  HAWebViewController.h
//  HackcessAngels
//
//  Created by Etienne Membrives on 05/07/2014.
//  Copyright (c) 2014 Hackcess Angels. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HAWebViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIWebView webView;
@property (nonatomic, strong) NSString* url;
@end
