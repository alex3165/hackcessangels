//
//  HAAgent.m
//  hackcessangels
//
//  Created by Mac on 24/04/2014.
//  Copyright (c) 2014 hackcessangels. All rights reserved.
//

#import "HAAgent.h"
#import "UICKeyChainStore.h"

NSString *const pServiceId = @"HAAgent";
NSString *const pPasswordKey = @"password";
NSString *const pImageKey = @"image";
NSString *const pEmailKey = @"email";
NSString *const pNameKey = @"name";
NSString *const pNumeroKey = @"agentId";
NSString *const pCookieKey = @"cookie";
NSString *const pGareKey = @"gare";

@implementation HAAgent

- (id)initWithDictionary:(NSDictionary *)dico
{
    self = [super init];
    
    if (self) {
        self.email = [dico objectForKey:pEmailKey];
        self.password = [dico objectForKey:pPasswordKey];
        self.name = [dico objectForKey:pNameKey];
        self.sncfId = [dico objectForKey:pNumeroKey];
        //self.gare = [dico objectForKey:@"gare"];
        if ([dico objectForKey:@"image"] != nil) {
            self.image = [[NSData alloc] initWithBase64EncodedString:[dico objectForKey:@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        }
    }
    
    return self;
}

+ (HAAgent*) agentFromKeyChain {
    NSString *email = [UICKeyChainStore stringForKey:pEmailKey service:pServiceId];
    NSData *cookieData = [UICKeyChainStore dataForKey:pCookieKey service:pServiceId];
    if (!email || !cookieData) {
        return nil;
    }
    
    HAAgent *agent = [[HAAgent alloc] initWithDictionary:@{@"email": email}];
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
    [UICKeyChainStore setString:self.email forKey:pEmailKey service:pServiceId];
    
    NSError *error;
    NSData *cookieData = [NSPropertyListSerialization dataWithPropertyList:[self.cookie properties] format:NSPropertyListXMLFormat_v1_0 options:(NSPropertyListWriteOptions)nil error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    [UICKeyChainStore setData:cookieData forKey:pCookieKey service:pServiceId];
    return;
}

- (NSDictionary*) toPropertyList {
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] init];
    if (self.email) {
        [parameters setObject:self.email forKey:pEmailKey];
    }
    if (self.name) {
        [parameters setObject:self.name forKey:pNameKey];
    }
    if (self.sncfId) {
        [parameters setObject:self.sncfId forKey:pNumeroKey];
    }
    // Set a new password only if it changed by the user
    if (self.password != nil && self.password.length != 0) {
        [parameters setObject:self.password forKey:pPasswordKey];
    }
    if (self.image != nil) {
        [parameters setObject:[self.image base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] forKey:pImageKey];
    }
    return parameters;
}

- (void) deleteAgentFromKeyChain {
    [UICKeyChainStore removeAllItemsForService:pServiceId];
}

@end
