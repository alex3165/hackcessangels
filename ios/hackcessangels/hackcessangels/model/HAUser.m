//
//  HAUser.m
//  hackcessangels
//
//  Created by boris charp on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAUser.h"

@implementation HAUser

- (id)initWithDictionary:(NSDictionary *)dico
{
    self = [super init];
    
    if (self) {
        
        _email = [dico objectForKey:@"email"];
        self.password = [dico objectForKey:@"password"];
        self.name = [dico objectForKey:@"name"];
        self.userdescription = [dico objectForKey:@"description"];
        self.handicap = [dico objectForKey:@"handicap"];
    }
    
    return self;
}

@end
