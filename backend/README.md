# Serveur pour l'application HackcessAngels

## Instructions de compilation

* Dépendances:
 * Go
 * mgo
 * La suite gorilla
 * github.com/nfnt/resize
* Avoir le dossier hackcessangels dans son $GOPATH

Allez dans le dossier `main/` et lancez `go build .`. Le serveur est le fichier `main` nouvellement créé.

Le serveur a besoin du gestionnaire de base de données MongoDB.

## Dossiers

### main/

`main.go` contient le point d'entrée du serveur. Il contient également les clefs du CookieStore, nécessaires à l'authentification. Un changement de ces clefs force tous les utilisateurs à se ré-enregistrer. Elles devraient rester secrètes.

### model/

Le dossier `model` contient les définitions du modèle de données utilisé par l'application (voir http://fr.wikipedia.org/wiki/Mod%C3%A8le-vue-contr%C3%B4leur).

* Les fichiers dont les noms finissent en `_test.go` contiennent les tests unitaires
* `model.go` contient la définition principale du modèle. Il gère la connexion avec la base de données MongoDB.
* `user.go` contient la définition d'un utilisateur du système. Agent et Usagers utilisent la même représentation; la différence se situant dans le champ `User.IsAgent` permettant de différencier les deux. `User` dérive de `LoggedAccount` pour la gestion des mots de passe. `User.Email` correspond à l'identifiant de connexion de l'utilisateur et n'est pas forcément une adresse de courriel. Aucune vérification n'est effectuée sur la validité des numéros de téléphone (`User.Phone` et `User.EmergencyPhone`). `User.PushToken` n'est pas utilisé.
* `logged_account.go` gère les mots de passe. Ceux-ci sont salés et hashés. Il n'est donc pas possible de retrouver un mot de passe à partir d'un compte, juste de vérifier si un mot de passe est le bon.
* `help_request.go` gère les demandes d'aide. Une demande d'aide a toujours:
 * un demandeur: `RequesterEmail`)
 * une date de création: `RequestCreationTime`
 * la dernière position du demandeur, `RequestPosition`, avec sa précision en mètres, `RequestPosPrecision`
 * la dernière mise à jour de la position du demandeur, `RequesterLastUpdate`
 * une liste des états successifs de la demande d'aide, `Status`, contenant l'état et l'heure à laquelle la demande est rentrée dans l'état en question
 * le dernier état connu de la demande, `CurrentState`
* `station.go` contient la définition d'une gare. Il contient le code nécessaire pour charger les définitions des gares Transilien depuis un fichier CSV dans le dossier `data/`
* `debug.go` contient des méthodes utilitaires utiles pour le débogage par `server/debug.go`

### server/

Le dossier `server` contient le code pour l'API HTTP. Cette API est utilisée par les applications iOS.

### service/

Le dossier `service` contient le code gérant les connexions TCP brutes vers les applications Agent, permettant de distribuer les demandes d'aide rapidement (sans polling).

### data/

Le dossier `data` contient les données des gares, au format CSV tel que fourni sur le site SNCF. Toutes les gares listées seront activées (donc, pour n'activer le systeme que dans un nombre réduit de gares, il faut en enlever).

### scripts/

Le dossier `scripts` contient des programmes de maintenance (par exemple, création de profils en masse).
