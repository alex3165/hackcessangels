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
NSString *const kDescriptionKey = @"description";
NSString *const kImageKey = @"image";
NSString *const kNameKey = @"name";
NSString *const kNumeroKey = @"phone";
NSString *const kCookieKey = @"cookie";

@implementation HAUser

- (id)initWithDictionary:(NSDictionary *)dico
{
    self = [super init];
    
    if (self) {
        self.email = [dico objectForKey:@"email"];
        self.password = [dico objectForKey:@"password"];
        self.name = [dico objectForKey:@"name"];
        self.phone = [dico objectForKey:@"phone"];
        self.description = [dico objectForKey:@"description"];
        self.disability = [dico objectForKey:@"disability"];
        self.image = [dico objectForKey:@"image"];
    }
    
    return self;
}

+ (HAUser*) userFromKeyChain {
    NSString *email = [UICKeyChainStore stringForKey:kEmailKey service:kServiceId];
    NSData *cookieData = [UICKeyChainStore dataForKey:kCookieKey service:kServiceId];
    if (!email || !cookieData) {
        return nil;
    }
    
    HAUser *user = [[HAUser alloc] initWithDictionary:@{@"email": email}];
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

    NSError *error;
    NSData *cookieData = [NSPropertyListSerialization dataWithPropertyList:[self.cookie properties] format:NSPropertyListXMLFormat_v1_0 options:(NSPropertyListWriteOptions)nil error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    [UICKeyChainStore setData:cookieData forKey:kCookieKey service:kServiceId];
    return;
}
@end
