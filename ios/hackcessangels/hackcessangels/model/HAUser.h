//
//  HAUser.h
//  hackcessangels
//
//  Created by boris charp on 13/02/2014.
//  Copyright (c) 2014 RIEUX Alexandre. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 - Alex : Login : Ecran, stocker user au login et pas au get, checker si on a un user, si on la ne pas faire d'écran de login.
 
 - Ecran help + lien vers carte : rajouter des tests sur le service d'aide, créer des objets help, récuperer les eventuels infos.
 
 - Etienne : Carte, service de localisation, afficher sur la carte.
 
 - Julia : Voir et Editer son profil => get du user, afficher les infos et faire l'interface pour éditer et faire un put.
 
 */


extern NSString *const kPasswordKey;
extern NSString *const kEmailKey;

@interface HAUser : NSObject

@property (nonatomic, strong) NSString *nom;
@property (nonatomic, strong) NSString *prenom;
@property (nonatomic, strong, readonly) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userdescription;
@property (nonatomic, strong) NSString *handicap;

- (id)initWithDictionary:(NSDictionary *)dico;

+ (HAUser*) userFromKeyChain;
- (void) saveUserToKeyChain;

@end
