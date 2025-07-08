## Installation de serveur DNS sur Windows

Cette procédure suppose que le serveur Windows et le client Windows sont paramétrés pour communiquer et ont chacun 1 interface lan + 1 interface réseau interne sur le même réseau. Le serveur a une adresse IP statique et une IP statique a été configutée sur le client également (adaptateur réseau interne ici).

### 1) Ajouter le role le role DNS 

Dans le Server Manager cliquer sur Manager en haut à droite--> "Add Roles and Features"--> next --> "Role based or feature based installation"--> next --> "Select server from the pool" séléectionné votre serveur --> next --> cochez DNS server dans le menu des roles --> Add features --> next --> next --> next--> install : lance l'installation du role--> Close.v

### 2) Configurer la zone DNS wilder.lan

Dans le Server manager clisuer sur sur "Tools" enhaut à droite --> DNS --> Clic droit sur le nom du serveur dans la rubrique DNS --> New Zone--> l'assistance s'ouvre --> Primary zone --> next --> Forward look up zone --> 
 name: entrez le nom de la zone, ici :     wilders.lan --> "Create a new file with this file name" : acceptez le nom proposé : wilders.lan.dns--> next --> Sélectionnez "Do not allow dynamic update" --> next --> Finish.
La zone est configurée. 

### 3) Configurer la zone de recherche inverse

Restez dans le DNS manager (sinon "Tools").
CLic droit sur le serveur --> New Zone--> Primary zone --> Reverse lookup zone --> Ipv4 reverse lookup zone --> Network ID : entrez l'adresse du réseau  --> next --> "Create a new file with file name" : acceptez le nom par défaut --> next --> validez "Do not allow dynamic updates" --> next--> finish


### 4) Ajouter les enregistrements A

- Pour le serveur :
Restez dans le DNS manager (sinon "Tools").
Déroulez l'arborescence du serveur--> Forward look up zones --> "wilders.lan". Faites un clic droit sur "wilder.lans" --> New Host (A or AAAA--> )--> 
Name : ajoutez le nom du serveur
IP address : ajouter l'adresse ip du serveur (adaptateur réseau LAN) -->cochez "update associeted pointer (PTR) record
 --> Add host
Ajout terminé pour le serveur


- Pour le client (ip fixe)
Restez dans le DNS manager (sinon "Tools").
Déroulez l'arborescence du serveur--> Forward look up zones --> "wilders.lan". Faites un clic droit sur "wilders.lan" --> New Host (A or AAAA--> )--> 
Name : ajoutez le nom du client
IP address : ajouter l'adresse ip du client (adaptateur réseau interne) -->cochez "update associeted pointer (PTR) record
 --> Add host
Ajout terminé pour le client

### 5) Ajout d'un enregistrement CNAME pour le serveur
Restez dans le DNS manager (sinon "Tools").
Déroulez l'arborescence du serveur--> Forward look up zones --> "wilders.lan". Faites un clic droit sur "wilder.lan" --> New Alias CNAME--> 
Alias name : dns
Fully Qualified Domain Name (FQDN) : entrez le nom de votre server.wilder.lan 


### 6) Configurer un forwarder pour les requêtes externes

Dans le DNS manager--> clic droit sur le nom du serveur--> properties --> Forwarders --> edit -->ajouter 8.8.8.8 --> ok--> apply-->ok

### 7) Vérifier l'interface DNS

Dans le DNS manager --> clic droit sur le serveur -->Interfaces --> sélectionnez uniquement l'ip du client --> apply --> ok. 
Redémarrer le serveur (o le service dns)

### 8) configurer le dns sur le serveur
Modifiez les réglages de l'adaptateur réseau (interne): DNS = mettre l'IP du serveur


### 9) Configurer le DNS sur le client

Modifiez les réglages de l'adaptateur réseau (interne) : DNS = mettre l'IP du serveur--> cliquer sur "avancé" --> "suffixe DNS pour cette connexion" ajouter wilder.lan.

### 10) Paramétrer interfaces LAN

AJouter l'adresse du serveur DNS sur les interfaces LAN du client et du serveur

### 11) Tester la configuration

- Avec les 2 noms sur le serveur:

                        PS C:\Users\Administrator> nslookup dns.wilders.lan
                        Server:  serveurwin.wilders.lan
                        Address:  172.20.0.1

                        Name:    serveurwin.wilders.lan
                        Address:  172.20.0.1
                        Aliases:  dns.wilders.lan

                        PS C:\Users\Administrator> nslookup serveurwin.wilders.lan
                        Server:  serveurwin.wilders.lan
                        Address:  172.20.0.1

                        Name:    serveurwin.wilders.lan
                        Address:  172.20.0.1

- résolution inverse pour le serveur:
                        PS C:\Users\Administrator> nslookup 172.20.0.1
                        Server:  serveurwin.wilders.lan
                        Address:  172.20.0.1

                        Name:    serveurwin.wilders.lan
                        Address:  172.20.0.1

- pour le client

                        PS C:\Users\b> nslookup 172.20.0.2
                        Serveur :   serveurwin.wilders.lan
                        Address:  172.20.0.1

                        Nom :    DESKTOP-4GUMAN0.wilders.lan
                        Address:  172.20.0.2     

- ping avec les  2 noms
                        PS C:\Users\b> ping serveurwin.wilders.lan

                        Envoi d’une requête 'ping' sur serveurwin.wilders.lan [172.20.0.1] avec 32 octets de données :
                        Réponse de 172.20.0.1 : octets=32 temps<1ms TTL=128
                        Réponse de 172.20.0.1 : octets=32 temps<1ms TTL=128
                        Réponse de 172.20.0.1 : octets=32 temps<1ms TTL=128
                        Réponse de 172.20.0.1 : octets=32 temps<1ms TTL=128

                        Statistiques Ping pour 172.20.0.1:
                        Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
                        Durée approximative des boucles en millisecondes :
                        Minimum = 0ms, Maximum = 0ms, Moyenne = 0ms
                        PS C:\Users\b>
                        PS C:\Users\b> ping serveurwin.wilders.lan

                        Envoi d’une requête 'ping' sur serveurwin.wilders.lan [172.20.0.1] avec 32 octets de données :
                        Réponse de 172.20.0.1 : octets=32 temps<1ms TTL=128
                        Réponse de 172.20.0.1 : octets=32 temps<1ms TTL=128
                        Réponse de 172.20.0.1 : octets=32 temps<1ms TTL=128
                        Réponse de 172.20.0.1 : octets=32 temps<1ms TTL=128

                        Statistiques Ping pour 172.20.0.1:
                        Paquets : envoyés = 4, reçus = 4, perdus = 0 (perte 0%),
                        Durée approximative des boucles en millisecondes :
                        Minimum = 0ms, Maximum = 0ms, Moyenne = 0ms
                        PS C:\Users\b>
