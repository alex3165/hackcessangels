# Serveur pour l'application HackcessAngels

## Instructions de compilation

* Prérequis:
    * Go
    * mgo
    * La suite gorilla
* Avoir le dossier hackcessangels dans son GOPATH

## Endpoints
/user
    Content-Type: text/html
  - GET: Retourne un formulaire web pour créer un nouvel utilisateur
/api/user/login
    Content-Type: application/json
  - POST: Authentifie un utilisateur
        Paramètres: email; password
        Codes retour:
            - 200: OK; Retourne un cookie dans l'en-tête "Set-Cookie"
            - 400: Paramètre manquant
            - 403: Utilisateur inconnu ou mot de passe invalide
/api/user
    Content-type: application/json
  - POST: Crée un nouvel utilisateur
        Paramètres: email; password
        Codes retour:
            - 200: OK, utilisateur créé
            - 400: Paramètre manquant
            - 403: Utilisateur existe déjà
  - GET: Retourne un utilisateur
        Paramètres: email
        Authentification par cookie requise
        Codes retour:
            - 200: OK, utilisateur retourné
            - 30x: Login requis
            - 400: Paramètre manquant
            - 403: Login et email demandé ne correspondent pas
            - 404: Utilisateur inconnu
  - PUT: Modifie un utilisateur
        Paramètres: email; user (sérialisation JSON d'un utilisateur)
        Authentification par cookie requise
        Codes retour:
            - 200: OK, utilisateur modifié
            - 30x: Login requis
            - 400: Paramètre manquant
            - 403: Login et email demandé ne correspondent pas
            - 404: Utilisateur inconnu
  - DELETE: Supprime un utilisateur
        Paramètre: email
        Authentification par cookie requise
        Codes retour:
            - 200: OK, utilisateur supprimé
            - 30x: Login requis
            - 400: Paramètre manquant
            - 403: Login et email demandé ne correspondent pas
/api/request
    Content-type: application/json
  - POST: Crée une nouvelle demande d'aide
        Paramètres: lat (latitude); lng (longitude)
        Authentification par cookie requise
        Codes retour:
            - 200: OK, utilisateur créé
            - 400: Paramètre manquant
  - GET: Retourne la demande en cours
        Authentification par cookie requise
        Codes retour:
            - 200: OK, demande retournée
            - 400: Paramètre manquant
            - 404: Aucune requête en cours
  - PUT: Modifie une requête
        Paramètres: lat (latitude); lng (longitude)
        Authentification par cookie requise
        Codes retour:
            - 200: OK, utilisateur créé
            - 400: Paramètre manquant
            - 404: Aucune requête en cours
  - DELETE: Supprime la demande en cours
        Authentification par cookie requise
        Codes retour:
            - 200: OK, utilisateur supprimé
            - 400: Paramètre manquant
