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
extern NSString *const kDescriptionKey;
extern NSString *const kImageKey;
extern NSString *const kNameKey;
extern NSString *const kNumeroKey;
@interface HAUser : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *disability;
@property (nonatomic, strong) NSData *image;
@property (nonatomic, strong) NSHTTPCookie *cookie;

- (id)initWithDictionary:(NSDictionary *)dico;

+ (HAUser*) userFromKeyChain;
- (void) saveUserToKeyChain;

@end
