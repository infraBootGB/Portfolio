# Quête DHCP Windows

## Configurer la carte réseau de ta machine virtuelle en Réseau Interne :

Cette configuration n'est pas intégrée à Active directory et comprend un Windows server 2022 et un client sous Windows 10

- La vm et le serveur doivent être éteinds.

- Dans Virtual Box séléctionnez le serveur et allez dans --> Configuration -->  Réseau --> séléctionnez un adaptateur

    - Cochez "activer l'interface réseau"
    - Mode d'accès réseau : Réseau interne
    - Name intnet
    - vérifiez que la case "cable branché est bien cochée sinon cochez là
    - Laissez les autres champs par défaut

Ensuite faite la même opération pour le client windows.
Le nom du réseau interne doit être le même pour toutes les machines.

La configuration en réseau interne est terminée.


## Configure le service DHCP pour qu'il fournisse des adresses IP de la plage 172.20.0.100 - 172.20.0.200 sur le réseau 172.20.0.0/24.

### - 1 - Changer le nom du serveur 

- Connectez-vous sur le serveur en session administrateur

- Dans le server manager cliquez sur "local server" --> "Computer name" --> "Change" --> Entrez le nouveau du serveur : SRV-DHCP. Redémarrez le serveur pour aplliquer la modification.

### - 2 - Configurez un adresse IP statique pour le server.

- Dans le server manager cliquez sur l'interface réseau ethernet configuré précédemment

    --> clique droit sur l'icone de l'interface réseau --> properties --> clic droit sur "Internet Protocol Version 4 (Tcp /IPv4) --> properties --> cohcez la case "Use the following IP adress".

L'adresse réseau donnée ici  est 172.20.0.0/24

- Entrez l'adresse IP de votre choix, ici : 172.20.0.1 
- Entrez un subnetmask, ici : 255.255.255.0
- Ne pas remplir passerelle par défaut en réseau interne, ni DNS.
- Cochez "Validate settings upon exit" , cliquez sur OK et fermez la fenêtre des paramètres


### - 3 - Installer le rôle DCHP sur le serveur : 

- Dans le server manager cliquez sur "Manage" --> "Add roles and features"
- L'assistant s'ouvre -> next --> cochez "Role-based or feature-based installation"--> next
- Sélectionnez le serveur --> next
- Cochez "DHCP" server dans le menu des rôles --> next --> add features --> next--> ne rien cocher dans le menu "Features"--> next --> next --> Install : l'installation démarre, vous pouvez fermer la fenêtre.

- Une fois l'installation terminée, un drapeau jaune de notification apparait en haut à droite du server manager--> cliquez dessus --> cliquez sur "complete DHCP configuration "--> un nouvel assistant s'ouvre --> cliquez sur "commit" et ensuite sur close.


### - 4 - Configuration 

- Dans le server manager cliquez sur "Tools" en haut à droite --> sélectionnez "DCHP" une nouvelle fenêtre s'ouvre en arrière plan. 
- Déroulez l'arborescence du serveur --> clic droit sur IPV4--> New Scope --> un assisant de configuration s'ouvre --> next
    - Name : entrez le nom à donner pour cette nouvelle étendue (New Scope) ici :   Réseau Interne 172.20.0.0 -> next
    - Start IP adress : entrez le début de la plage d'adresses choisie, ici : 172.20.0.100
    - End IP adress : entre la fin de la plage d'adresses, ici : 172.20.0.200
    - modifiez le champ "Length" en fonction de votre masque de sous réseau, ici : 24
    - Subnet mask : le masque de sous réseau devrait se modifier automatiquement sinon entrez votre masque de sous réseau; ici : 255.255.255.0 --> next 
    - Ne rien modifier dans le menu "add exclusions and delay" --> next
    - vous pouvez modifer ou laisser par défaut "lease duration" qui détermine la durée du bail DHCP --> next
    - laissé coché "yes i want to configure these options now" --> next
    - "Router (defaut gateway)" en réseau interne pas besoin de configurer la passerelle par défaut --> next
    - idem  pour "Domain name and DNS servers" --> next
    - idem pour WINS Servers --> next
    - "Activate scope" laissez "yes i want to activate this scope now" --> next --> finish
    
La configuration est terminée une cocher verte apparait sous le nom du serveur sur IPv4.


## Un client qui rejoint le réseau obtient une adresse IP dans la plage donnée par le DHCP.


Sur le client Windows 10 ouvrez le panneau de configuraiton --> Centre de réeau et partage --> modifier les paramètres de la carte --> clique droit sur l'interface réseau --> propriétés --> cliquez sur Protocl Internet Version 4 (Tcp/IPv4) --> propriétés --> laissé coché "Obtenir une adresse IP automatiquement" --> OK --> fermez la fenêtre.

- Ouvrez une invite de commande :

- Pour effacer une configuration précédente entrez la commande:

    >ipconfig / release

- Pour demander un nouvelle addresse IP au serveur DHCP:

    >ipconfig / renew

Ici nous obtenons ce résultat :

Adresse IPv6 de liaison locale. . . . .: fe80::7b0c:af00:c214:bb03%4

   Adresse IPv4. . . . . . . . . . . . . .: 172.20.0.100

   Masque de sous-réseau. . . . . . . . . : 255.255.255.0

   Passerelle par défaut. . . . . . . . . :

## Le client qui possède la réservation n'obtient pas une autre IPv4, même si il demande un renouvellement.

Répétez la procédure précédente dans l'invite de commande du client windows:

Ici nous obtenons le même résultat :

    Adresse IPv6 de liaison locale. . . . .: fe80::7b0c:af00:c214:bb03%4

    Adresse IPv4. . . . . . . . . . . . . .: 172.20.0.100

    Masque de sous-réseau. . . . . . . . . : 255.255.255.0

    Passerelle par défaut. . . . . . . . . :




## Mettre en place une attribution statique pour une machine cliente particulière dont l'adresse MAC permet d'obtenir l'adresse 172.20.0.10

### - 1 - Nous avons besoin de l'adresse MAC du client windows 10.

- Ouvrez un invite de commande :

    >ipconfig /all

L'adresse MAC correspond à l'adresse physique, ici : 08-00-27-B1-E8-AE

Conservez cette adresse.


### - 2 - Configuration du serveur DHCP pour les attributions d'adresses statiques (réservations)

- Dans le server manager cliquez sur "Tools" en haut à droite --> sélectionnez "DCHP" une nouvelle fenêtre s'ouvre en arrière plan. 

- Déroulez l'arborescence du serveur --> IPV4--> "Scope [172.20.0.0] avec le nom de votre réseau --> Faites un clic droit sur "Reservations" --> New Reservation

- Reservation name : entrez un nom de réservation , ici Client Windows 1 Statique
- IP adresse :  Entrez l'IP que vous souhiatez attribuer à ce client, ici : 172.20.0.10
- MAC Adress :  Entrez l'adresse MAC du client trouvée précédemment (sans les tirets)
- Description : entrez un description; ici : attribution IP statique
- Supported types : laissez sur "Both" --> add

Le client apparait dans les réservation avec l'adresse IP que vous venez de lui attribuer.


 ### - 3 - Vérification sur le client :

- Ouvrez une invite de commande :

-  Pour effacer une configuration précédente entrez la commande:

        >ipconfig / release

- Pour demander un nouvelle addresse IP au serveur DHCP:

    >ipconfig / renew

Le serveur doit vous attribuer l'adresse enregistrée dans les reservations, ici :

  Adresse IPv6 de liaison locale. . . . .: fe80::7b0c:af00:c214:bb03%4

   Adresse IPv4. . . . . . . . . . . . . .: 172.20.0.10

   Masque de sous-réseau. . . . . . . . . : 255.255.255.0

   Passerelle par défaut. . . . . . . . . :



La configuration et les tests sont terminés.   



