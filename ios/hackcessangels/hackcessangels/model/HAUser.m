//
//  HAUser.m
//  hackcessangels
//
//  Created by boris charp on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAUser.h"
#import "UICKeyChainStore.h"

NSString *const kServiceId = @"HAUser";
NSString *const kPasswordKey = @"password";
NSString *const kEmailKey = @"email";
//NSString *const kLoginKey = @"login";
//NSString *const kDescriptionKey = @"userdescription";
NSString *const kCookieKey = @"cookie";

@implementation HAUser

- (id)initWithDictionary:(NSDictionary *)dico
{
    self = [super init];
    
    if (self) {
        self.email = [dico objectForKey:@"email"];
        self.password = [dico objectForKey:@"password"];
        self.login = [dico objectForKey:@"name"];
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
    /* NSString *login = [UICKeyChainStore stringForKey:kLoginKey service:kServiceId];
    NSString *userdescription = [UICKeyChainStore stringForKey:kDescriptionKey service:kServiceId];*/
    NSString *email = [UICKeyChainStore stringForKey:kEmailKey service:kServiceId];
    NSString *password = [UICKeyChainStore stringForKey:kPasswordKey service:kServiceId];
    NSData *cookieData = [UICKeyChainStore dataForKey:kCookieKey service:kServiceId];
    if (!email || !password || !cookieData) {
        return nil;
    }
    HAUser *user = [[HAUser alloc] initWithDictionary:@{@"email": email, kPasswordKey: password}];
    NSError *error;
    user.cookie = [[NSHTTPCookie alloc] initWithProperties: [NSPropertyListSerialization propertyListWithData:cookieData options:NSPropertyListImmutable format:NULL error:&error]];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    return user;
}

- (void) saveUserToKeyChain
{
    [UICKeyChainStore setString:self.email forKey:kEmailKey service:kServiceId];
    [UICKeyChainStore setString:self.password forKey:kPasswordKey service:kServiceId];
    if (self.cookie) {
        NSError *error;
        NSData *cookieData = [NSPropertyListSerialization dataWithPropertyList:[self.cookie properties] format:NSPropertyListXMLFormat_v1_0 options:(NSPropertyListWriteOptions)nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        [UICKeyChainStore setData:cookieData forKey:kCookieKey service:kServiceId];
    }
    return;
}
@end
