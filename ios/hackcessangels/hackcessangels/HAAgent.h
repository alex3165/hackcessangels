//
//  HAAgent.h
//  hackcessangels
//
//  Created by Mac on 24/04/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>

<<<<<<< HEAD
extern NSString *const kServiceId;
extern NSString *const kCookieKey;
extern NSString *const kImageKey;
extern NSString *const kNameKey;
extern NSString *const kNumeroKey;
extern NSString *const kPasswordKey;
//extern NSString *const kGareKey;
=======
extern NSString *const pServiceId;
extern NSString *const pCookieKey;
extern NSString *const pImageKey;
extern NSString *const pEmailKey;
extern NSString *const pNameKey;
extern NSString *const pNumeroKey;
extern NSString *const pPasswordKey;
extern NSString *const pGareKey;
>>>>>>> f93dac870d1d71ae5bc39e72b49e6e5c406be4da

@interface HAAgent : NSObject


@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSData *image;
@property (nonatomic, strong) NSHTTPCookie *cookie;
//@property (nonatomic, strong) NSString *gare;

- (id)initWithDictionary:(NSDictionary *)dico;

+ (HAAgent*) agentFromKeyChain;
- (void) saveAgentToKeyChain;

@end
