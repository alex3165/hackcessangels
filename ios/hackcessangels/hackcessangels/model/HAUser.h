//
//  HAUser.h
//  hackcessangels
//
//  Created by boris charp on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HAUser : NSObject

@property (nonatomic, strong, readonly) NSString *email;
@property (nonatomic, strong) NSString *password;

- (id)initWithDictionary:(NSDictionary *)dico;

@end
