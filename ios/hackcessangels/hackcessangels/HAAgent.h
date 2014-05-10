//
//  HAAgent.h
//  hackcessangels
//
//  Created by Mac on 24/04/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kServiceId;
extern NSString *const kCookieKey;
extern NSString *const kImageKey;
extern NSString *const kNameKey;
extern NSString *const kNumeroKey;
extern NSString *const kPasswordKey;
//extern NSString *const kGareKey;

@interface HAAgent : NSObject


@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSData *image;
@property (nonatomic, strong) NSHTTPCookie *cookie;
//@property (nonatomic, strong) NSString *gare;

- (id)initWithDictionary:(NSDictionary *)dico;

+ (HAAgent*) agentFromKeyChain;
- (void) saveAgentToKeyChain;

@end
