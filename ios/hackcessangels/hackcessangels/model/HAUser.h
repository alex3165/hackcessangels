//
//  HAUser.h
//  hackcessangels
//
//  Created by boris charp on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAUser : NSObject

@property (nonatomic, strong) NSString *nom;
@property (nonatomic, strong) NSString *prenom;
@property (nonatomic, strong, readonly) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userdescription;
@property (nonatomic, strong) NSString *handicap;

- (id)initWithDictionary:(NSDictionary *)dico;

+ (HAUser*) userFromKeyChain;
- (void) saveUserToKeyChain;

@end
