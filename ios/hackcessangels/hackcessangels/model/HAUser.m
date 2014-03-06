//
//  HAUser.m
//  hackcessangels
//
//  Created by boris charp on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAUser.h"
#import "UICKeyChainStore.h"

NSString *const kPasswordKey = @"password";
NSString *const kEmailKey = @"email";

@implementation HAUser

- (id)initWithDictionary:(NSDictionary *)dico
{
    self = [super init];
    
    if (self) {
        self.email = [dico objectForKey:@"email"];
        self.password = [dico objectForKey:@"password"];
        self.name = [dico objectForKey:@"name"];
        self.userdescription = [dico objectForKey:@"description"];
        self.handicap = [dico objectForKey:@"handicap"];
    }
    
    return self;
}

+ (id)savedUser
{
    //NSUSerdefault - pas du tout secure
    //[[NSUserDefaults standardUserDefaults] setObject:@"toto" forKey:@"name"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    
    //CoreData
    //SQLite - XML - File
    //NSManagedObjectContext;
    
    //SQLite - SQL
    
    //Keychain - Sécurisé
    //[UICKeyChainStore setString:@"password1234" forKey:@"password"];
    
    //Ecrire des fichiers (plist)
    
    //NSURLCache
    
    //TouchDB - Experimental
    
    // Actual code
    return nil;
}

+ (HAUser*) userFromKeyChain {
    NSString *email = [UICKeyChainStore stringForKey:@"email" service:@"HAUser"];
    NSString *password = [UICKeyChainStore stringForKey:kPasswordKey service:@"HAUser"];
    if (!email || !password) {
        
        return nil;
        
    }
    HAUser *user = [[HAUser alloc] initWithDictionary:@{@"email": email, kPasswordKey: password}];
    return user;
}

- (void) saveUserToKeyChain
{
    [UICKeyChainStore setString:self.email forKey:kEmailKey service:@"HAUser"];
    [UICKeyChainStore setString:self.password forKey:kPasswordKey service:@"HAUser"];
    return;
}
@end
