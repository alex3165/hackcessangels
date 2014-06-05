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
NSString *const kDescriptionKey = @"description";
NSString *const kImageKey = @"image";
NSString *const kNameKey = @"name";
NSString *const kNumeroKey = @"phone";
NSString *const kEmergencyKey = @"phoneUrgence";
NSString *const kDisabilityKey = @"disability";
NSString *const kDisabilityTypeKey = @"disabilityType";
NSString *const kCookieKey = @"cookie";

@implementation HAUser

- (id)initWithDictionary:(NSDictionary *)dico
{
    self = [super init];
    
    if (self) {
        self.email = [dico objectForKey:kEmailKey];
        self.password = [dico objectForKey:kPasswordKey];
        self.name = [dico objectForKey:kNameKey];
        self.phone = [dico objectForKey:kNumeroKey];
        self.description = [dico objectForKey:kDescriptionKey];
        self.disability = [dico objectForKey:kDisabilityKey];
        self.disabilityType = [[dico objectForKey:kDisabilityTypeKey] integerValue];
        self.phoneUrgence = [dico objectForKey:kEmergencyKey];
        if ([dico objectForKey:kImageKey] != nil) {
            self.image = [[NSData alloc] initWithBase64EncodedString:[dico objectForKey:kImageKey] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        }
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

- (NSDictionary*) toPropertyList {
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    if (self.email) {
        [parameters setObject:self.email forKey:kEmailKey];
    }
    if (self.name) {
        [parameters setObject:self.name forKey:kNameKey];
    }
    if (self.phone) {
        [parameters setObject:self.phone forKey:kNumeroKey];
    }
    if (self.description) {
        [parameters setObject:self.description forKey:kDescriptionKey];
    }
    if (self.disability) {
        [parameters setObject:self.disability forKey:kDisabilityKey];
    }
    [parameters setObject:[NSNumber numberWithInt: self.disabilityType] forKey:kDisabilityTypeKey];
    
    // Set a new password only if it changed by the user
    if (self.password != nil && self.password.length != 0) {
        [parameters setObject:self.password forKey:kPasswordKey];
    }
    
    if (self.image != nil) {
        [parameters setObject:[self.image base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] forKey:kImageKey];
    }
    return parameters;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
}

@end
