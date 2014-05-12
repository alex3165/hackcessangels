//
//  HAAgent.h
//  hackcessangels
//
//  Created by Mac on 24/04/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const pServiceId;
extern NSString *const pCookieKey;
extern NSString *const pImageKey;
extern NSString *const pEmailKey;
extern NSString *const pNameKey;
extern NSString *const pNumeroKey;
extern NSString *const pPasswordKey;
extern NSString *const pGareKey;

@interface HAAgent : NSObject


@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSData *image;
@property (nonatomic, strong) NSHTTPCookie *cookie;
@property (nonatomic, strong) NSString *gare;

- (id)initWithDictionary:(NSDictionary *)dico;

+ (HAAgent*) agentFromKeyChain;
- (void) saveAgentToKeyChain;

@end
