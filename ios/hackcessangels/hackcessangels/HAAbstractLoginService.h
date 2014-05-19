//
//  HAAbstractLoginService.h
//  hackcessangels
//
//  Created by Etienne Membrives on 19/05/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HALoginSuccess)();
typedef void(^HALoginFailure)(NSError* error);
typedef void(^HACheckCredentials)(NSString* login, NSString* password,
                                  HALoginSuccess success,
                                  HALoginFailure failure);

@protocol HAAbstractLoginService

- (HACheckCredentials) getCheckCredentialsBlock;

@end
