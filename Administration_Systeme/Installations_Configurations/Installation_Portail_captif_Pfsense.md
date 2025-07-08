# Installer un portail captif dans Pfsense

## 1. Création d'un utilisateur et d'un groupe de gestion

### 1.1 Création du groupe :

- Aller dans System --> User manager --> onglet Groups --> Cliquer sur +Add.
- Créer le groupe suivant :
    - Nom du groupe : PortalManagers
    - Scope : Local
    - Description : Utilisateurs gestionnaires du portail
    - Group membership : admin

    --> save

Une fois le groupe sauvegardé, on revient à la fenêtre précédente.

### 1.2 Ajouter les privilèges au groupe

- Cliquer sur l'icône du stylo sur la ligne du groupe crée

- Dans la partie Assigned Privileges, cliquer sur +Add et ajouter les privilèges suivants :
    - WebCfg – Status: Captive Portal (Voir le Status des utilisateurs connectés ») --> save
    - WebCfg – System: User Manager (Accès à la page de gestion des utilisateurs « User Manager ») --> save

__Sauvegarder la configuration__

### 1.3 Création et ajout d'un utilisateur au groupe de gestion (Attention, la casse est importante.)

- Dans la fenêtre, aller sur l'onglet Users et cliquer sur +Add

- Créer le compte suivant :
    - Username : PortalManager
    - Password : Donner un mot de passe
    - Full name : "Utilisateur autorisé a créer des utilisateurs du Portail Captif"
    - Group membership : Sélectionner le groupe crée précédemment (PortalManagers) et cliquer sur Move to "Member of" list et __sauvegarder la configuration__.

--> L'Utilisateur PortalManager est autorisé à céer des utilisateurs pour la connexion et l’utilisation du Portail Captif.

## 2. Création d'un utilisateur autorisé à se connecter

### 2.1 Création du groupe 

- Aller dans l'onglet Groups et cliquer sur +Add
- Créer le groupe suivant :
    - Nom du groupe : PortalUsers
    - Scope : Local
    - Description : Utilisateurs du portail
    - Group membership : Ne rien sélectionner

--> Save 

Une fois le groupe sauvegardé, on revient à la fenêtre précédente.


### 2.2 Ajout des privilèges au groupe 

- Cliquer sur l'icône du stylo sur la ligne du groupe crée.
- Dans la partie Assigned Privileges, cliquer sur +Add et ajouter les privilèges suivants :
    - User – Services: Captive Portal login (Autorisé seulement à se connecter au Portail Captif) --> save

--> Sauvegarder la configuration


### 2.3 Création et ajout d'un utilisateur au groupe des utilisateurs autorisés à se connecter au portail captif (Attention, la casse est importante)


- Dans la fenêtre, Aller sur l'onglet Users et cliquer sur +Add
- Créer le compte suivant :
    - sername : UserTest
    - Password : Donner un mot de passe
    - Full name : Utilisateur test du portail captif
    - Group membersUhip : Sélectionner le groupe crée précédemment (PortalUsers) et cliquer sur Move to "Member of" list et __sauvegarder la configuration.__

- Quitter la console d'administration.

L'utilisateur UserTest est autorisé à se connecter au portail captif.


__--> Les autres nouveaux utilisateurs seront maintenant créeà r avec la compte PortalManager__

## 3. Création et configuration du portail captif

- Se connecter à la web console avec le compte admin.

- Aller dans Services --> Captive portal et dans la fenêtre qui s'ouvre cliquer sur +Add
- Configurer le portail captif de la manière suivante :
    - Zone name : LabPortal
    - Zone description : Portail captif
    - Enable Captive Portal : à activer
    - Interfaces : selectionner LAN
    - Maximum concurrent connections : 1 (Limite le nombre de connexions simultanées d’un même utilisateur)
    - Idle timeout (Minutes) : 1 ou 2 (Les clients seront déconnectés après cette période d’inactivité)
    - Logout popup window : activer la case (une fenêtre popup permet aux clients de se déconnecter)
    - Pre-authentication Redirect URL : par exemple http://www.google.fr/ (URL HTTP de redirection par défaut. Les visiteurs ne seront redirigés vers cette URL après authentification que si le portail captif ne sait pas où les rediriger)
    - After authentication Redirection URL : par exemple http://www.google.fr/ (URL HTTP de redirection forcée. Les clients seront redirigés vers cette URL au lieu de celle à laquelle ils ont initialement tenté d’accéder après s’être authentifiés)
    - Disable Concurrent user logins : selectionner Disabled (seule la connexion la plus récente par nom d’utilisateur sera active)
    - Disable MAC filtering : à activer (nécessaire lorsque l’adresse MAC du client ne peut pas être déterminée)
    - Authentication Method : sélectionner Use an Authentication backend
    - Authentication Server : Sélectionner Local Database
    - Secondary Authentication Server : ne rien sélectionner !
    - Local Authentication Privileges : cocher la case (Autoriser uniquement les utilisateurs avec les droits de « Connexion au portail captif »)

__Sauvegarder la configuration__ et quitter la console d'administration.


