//
//  HAUser.h
//  hackcessangels
//
//  Created by boris charp on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kServiceId;
extern NSString *const kPasswordKey;
extern NSString *const kEmailKey;
extern NSString *const kCookieKey;

@interface HAUser : NSObject

@property (nonatomic, assign) BOOL userstate; // 0 for User and 1 for agent
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userdescription;
@property (nonatomic, strong) NSString *handicap;
@property (nonatomic, strong) NSHTTPCookie *cookie;

- (id)initWithDictionary:(NSDictionary *)dico;

+ (HAUser*) userFromKeyChain;
- (void) saveUserToKeyChain;

@end
