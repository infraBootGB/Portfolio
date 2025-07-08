# Procédure d'installation d'un par feu Pfsense + installation et configuration d'open vpn

### A) Créer la VM pfsense (type BSD dans Virtual box)


- Allumer la vm
    - install
    - configurer les interfaces WAN et LAN (Laisser le mode DHCP)
    - Install CE
    - enlever le cd d 'installation
    - Reboot

- Se connecter à l'interface sur l'adresse (ici LAN) indiquée sur l'écran de Pfsense

- Modifier les identifiants par défaut (admin + pfsense)

### B) Commencer la configuration d'OpenVPN

#### - 1 Créer une autorité de certification:

- Menu system --> Certificates
-   Dans Authorities --> cliquer sur Add
- Remplir le formulaire pour la création de l'autorité de certification
- Descriptive Name : CA-TEST
- Pays, ville etc...
- Organisation --> save
    
Le certificat auto-signé est créé.



#### - 2 Créer un certificat "Server" pour les flux VPN

Toujours dans le menu Certificates
- Aller dans l'onglet Certificate
-  add
-  champ méthode : Create an internal Certificate
- champ descriptive name : certificat-Openvpn-Test
-  champ certificate authority :  vérifier qu'il apparait le bon nom pour l'autorité de certification
-  champ common name :  choisir un nom qui correspond au firewall
-  champs informations ville etc...
-  descendre bas de page : Certificat type = choisir Server Certificate
- SAVE pour créer le certificat

#### - 3 Créer un utilisateur local et son certificat pour qu il puisse se connecter en VPN et chiffrer les flux

- Menu sytem --> usermanager
- Add
- Username :  choisir le nom utilisateur icI uservpn
- Password : ici le mot de passe qui servira à se connecter au VPN
 ( Pour ajouter un annuaire LDAP se rendre dans Authentication Servers pour déclarer l'annuaire)
 - cocher la case "Certificate : click to create à user certificate"
 - remplir descriptive name pour ce certificat
 - SAVE
 - vérifier la création dans les certificats --> onglet "certificates" (il doit y avoir au moins un usercertificate)




#### - 4 Créer la configuration OpenVPN Server client to site via la fonctionnalité d'Openvpn intégrée à Pfsense

- Dans Opensense --> Onglet VPN --> OpenVPN
- Dans onglet "ServeRS on clique sur Add pour entrer la configuration
- "Server mode" --> Remote Access (SSL/TLS+ User auth) car on va utiliser un certificat + un compte utilisateur
- "Backend for authentication" --> Local Database (car comptre local dans pfsense)
- "protocol" --> UDP ON ipV4 only (default)
- "Interface" --> WAN
- "Port Local" --> modifier le 1194 pour un port personnalisé (ici 3000)

Ensuite descendre à la partie "Cryptographic Settings"
- "Server certificates" --> reprendre le certificat SERVER!
- "Encryption Algorithm" --> passer en AES 256 CBC (Le chiffrement est meilleur mais possible impact en terme de performance).

Ensuite descendre à la partie "Tunnel Settings" pour configurer le tunnel
-  "IPv4 Tunnel Network" : ici il faut entrer le réseau que l'on va utiliser pour le tunnel VPN ici  : 10.8.0.0/24 (choisir un réseau qui ne rentrra pas en conflit avec le réseau local). Les clients du VON se verront attribués des adresse de ce réseau.
- "Redirect IPv4 gateway --> cocher si besoin : Tous les flux du poste client vont transiter par le VPN.C'est un choix de politique d'entreprise. Si décochée --> split tunnelling : seul les flux définis dans "ipv4 localr network" (plus bas) passeront par le VPN. Le reste du traffic passera par l'interface réseau habituelle.
- configuration ipv6 on faite ici
- Cette option disparait quand je coche "Redirect IPv4 gateway"-> "IPv4 Local network : ici il s'agit des rédeau que l'on veut rendre accessible au travers du vpn, exemple : le réseau sur lequel sont disponible les ressources que l'on souhaite partager.
- concurrent connections : nombre d'accès simultanés que j'autorise
en fonction du nombre d utilistateurs
- CLients settings --> Dynamic IP conseillé pour les appareils mobiles
- topology : choisi--> net30 : chaque client connecté au von sera dans un sous réseau isolé en /30 et ne sera pas en mesure de communiquer avec les autres PC connectés en VPN.Inconvénient : consome 4 adresses ip our une seule machine:--> attention quand on fait les plages réseau il faut diviser par 4! Passer sur un masque plus large que /24.

- DNS Default Domain: mettre par exemple le nom du domaine active directory

- DNS server enable : on peut choisir plusieurs DNS ET eznsuite cocher "Block Outside DNS --> ca forcera l'utilisation du DNS du VPN.

- Dans advanced configuration ajouter : "auth-nocache" qui va permettre d'ajouter une sécurité supplémentaire car ça ne mettra pas en cache les identifiants et donc efficace contre le vol d'identifiants
- SAVE





#### - 5 Exporter la configuration OpenVPN pour l'intégrer à un poste client

Il est d'abord nécessaire d'ajouter un paquet au parfeu
- System--> package manager --> Available Packages
- chercher "openvpn" --> sélectionner "openvpn-client-export"--> confirm

Retourner dans l'onglet VPN de PFsense-> onglet openvpn : il y a un nouvel onglet "Client Export"
- dans "Host Name Resolution" : si on se connecte au VPN avec l'ip publique laisser "Interface IP adresse" sinon si un nom de domaine a été déclaré : choisir une installation de type hostname mais ca pas forcément conseiller sauf si portail ssl etc
- SAVE as default

EN bas de cette page il y a une rubrique Openvpn Clients avec les configurations à exporter
- sous "Bundled Cinfigurations cliquer sur archive--> c(est l'archive avec le fichier ovpn dont le client aura besoin pour se connecter au vpn.


#### - 6 Créer les reègles du Firewall OpenVPN : une regle pour autoriser les flux à rentrer et une autre pour autoriser les flux dans le  VPN en lui meme
dANS PfSENSE aller dans l'onglet Firewall--> rules -->Add pour ajouter une nouvelle règle.
- INterface : WAN pour autoriser le trafic
- protocol --> UDP
- Source : any : car on ne connait pas l'adresse IP des clients qui vont se connecter au VPN
- Destination : WAN (donc du firewall) et le port ce sera celui choisit précédement 3000.
- extra options : possibilité de logger les paquets associés à cette règle
- DESCRIPTION --> Choisir un libelé : ici "Accès distant VPN"
- SAVE
- apply change (en vert en haut à droite)

Maintenant il faut autoriser l'accès aux ressources de l'entreprise

- Dans PFsense --> onglet Firewall--> il y a un nouvel onglet "OPenvpn"

- créer la rège qui permet d'accéder exemple https, rdp etc...
- Choisir l'interface OPenvpn
- source : any
- Destination : mettre l'hote cible : par exemple un serveur web ou le serveur de l'entreprise avec son IP locae et le port d'acce destination. Créer autant de règles que nécessaire.

Maintenant on peut importer la configuration sur le client et se connecter.

#### - 7 Tester l'accès depuis un pc distant

- Récupérer l'archive de configuration
- Renommer  le dossiefichier ovpn
- Lancer openvpn --> entrer les informations de l'utilisateur local.
- Faire ipconfig pour voir adresse ip et passerelle et masque en  /30
- essayer de se connecter au service RDP etc...

