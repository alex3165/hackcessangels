//
//  HAAgent.m
//  hackcessangels
//
//  Created by Mac on 24/04/2014.
//  Copyright (c) 2014 hackcessangels. All rights reserved.
//

#import "HAAgent.h"
#import "UICKeyChainStore.h"

NSString *const kServiceId = @"HAAgent";
NSString *const kPasswordKey = @"password";
NSString *const kImageKey = @"image";
NSString *const kNameKey = @"name";
NSString *const kNumeroKey = @"phone";
NSString *const kCookieKey = @"cookie";
NSString *const kGareKey = @"gare";

@implementation HAAgent

- (id)initWithDictionary:(NSDictionary *)dico
{
    self = [super init];
    
    if (self) {
        self.password = [dico objectForKey:@"password"];
        self.name = [dico objectForKey:@"name"];
        self.phone = [dico objectForKey:@"phone"];
        self.gare = [dico objectForKey:@"gare"];
        if ([dico objectForKey:@"image"] != nil) {
            self.image = [[NSData alloc] initWithBase64EncodedString:[dico objectForKey:@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        }
    }
    
    return self;
}

+ (HAAgent*) agentFromKeyChain {
    NSString *name = [UICKeyChainStore stringForKey:kNameKey service:kServiceId];
    NSData *cookieData = [UICKeyChainStore dataForKey:kCookieKey service:kServiceId];
    if (!name || !cookieData) {
        return nil;
    }
    
    HAAgent * = [[HAAgent alloc] initWithDictionary:@{@"name": name}];
    NSError *error;
    agent.cookie = [[NSHTTPCookie alloc] initWithProperties: [NSPropertyListSerialization propertyListWithData:cookieData options:NSPropertyListImmutable format:NULL error:&error]];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    return agent;
}

- (void) saveAgentToKeyChain
{
    [UICKeyChainStore setString:self.name forKey:kNameKey service:kServiceId];
    
    NSError *error;
    NSData *cookieData = [NSPropertyListSerialization dataWithPropertyList:[self.cookie properties] format:NSPropertyListXMLFormat_v1_0 options:(NSPropertyListWriteOptions)nil error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    [UICKeyChainStore setData:cookieData forKey:kCookieKey service:kServiceId];
    return;
}


@end
