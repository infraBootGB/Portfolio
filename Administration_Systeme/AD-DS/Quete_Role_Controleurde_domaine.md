## Installer un controleur de domaine AD DS

### 1) Installer le rôle

Dans le server manager --> Add roles and features --> next-->next--> next--> Dans la fenêtre cocher "Active Directory Domaine Services" --> add features --> next--> next--> install --> close.

### 2) Promouvoir le serveur en controleur de domaine

Un drapeau jaune apparait dans le server manager en haut--> cliquer dessus puis "promote this server to a domain controller" --> "add a new forest" saisir wilders.lan (= la zone DNS déjà crée) --> next --> Domain controller options :  laisser les choix cochés par défaut et choisir un mot de passe --> next --> next --> le nom NETBIOS apparait (ici WILDERS) --> next --> next--> next--> install --> le serveur redémarre automatiquement.

### 3) Se connecter avec le compte administrateur de domaine

Une nouvelle session de connection apparait, ici "WILDER\--> se connecter avec le mot de passe choisi précédemment.

### 4) Vérifier 

dans le dns manager --> Tools --> Active Directory Users and Computers--> vérifier que "wilder.lan" apparait --> la fonction "create new user" est disponible.



