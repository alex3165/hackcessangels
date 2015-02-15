//
//  HAUser.h
//  hackcessangels
//
//  Created by boris charp on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum HAUserDisability : NSUInteger {
       Unknown,
       Physical_wheelchair,
       Physical_powerchair,
       Physical_walk,
       Vision_blind,
       Vision_lowvision,
       Hearing_call,
       Hearing_SMS,
       Mental,
       Other
} HAUSerDisability ;

extern NSString *const kServiceId;
extern NSString *const kPasswordKey;
extern NSString *const kEmailKey;
extern NSString *const kCookieKey;
extern NSString *const kDescriptionKey;
extern NSString *const kImageKey;
extern NSString *const kNameKey;
extern NSString *const kNumeroKey;
extern NSString *const kPhoneUrgenceKey;

@interface HAUser : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *disabilityDescription;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *phoneUrgence;
@property (nonatomic, strong) NSString *disability;
@property (nonatomic, assign) enum  HAUserDisability disabilityType;
@property (nonatomic, strong) NSData *image;
@property (nonatomic, strong) NSHTTPCookie *cookie;

- (id)initWithDictionary:(NSDictionary *)dico;

// Get the current user from the device keychain.
+ (HAUser*) userFromKeyChain;
// Save this user to the keychain, possibly erasing any previous saves
- (void) saveUserToKeyChain;
// Delete saved user from the keychain
- (void) deleteUserFromKeyChain;

// Convenience method that returns the description string associated with this user disability
- (NSString*) getDisabilityString;

// Return this user data in property list format, suitable for serialization
- (NSDictionary*) toPropertyList;

@end
