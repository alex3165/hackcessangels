//
//  HAUser.m
//  hackcessangels
//
//  Created by boris charp on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import "HAUser.h"
#import "UICKeyChainStore.h"

@implementation HAUser

- (id)initWithDictionary:(NSDictionary *)dico
{
    self = [super init];
    
    if (self) {
        _nom = [dico objectForKey:@"nom"];
        _prenom = [dico objectForKey:@"prenom"];
        _email = [dico objectForKey:@"email"];
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
    
}
@end
