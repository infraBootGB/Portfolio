
## Configure la carte réseau de ta machine virtuelle en Réseau Interne

Les vm et le serveur doivent être éteinds.

- Dans Virtual Box séléctionnez le serveur et allez dans --> Configuration -->  Réseau --> séléctionnez l'adaptateur 1 :

    - Cochez "activer l'interface réseau"
    - Mode d'accès réseau : choississez NAT

Ensuite :

- Selectionnez l'adaptateur 2
- Cochez "activer l'interface réseau"
- Mode d'accès réseau : Réseau interne
- Name intnet
- vérifiez que la case "cable branché est bien cochée sinon cochez là
- Laissez les autres champs par défaut

Ensuite faites la même opération pour le client Ubuntu .

Le nom du réseau interne doit être le même pour toutes les machines.

La configuration réseau interne est terminée.

## Configure l'interface réseau du serveur

### Configurer une ip statique pour le serveur

- Aller dans les paramètres --> réseau --> sélectionnez les paramètres de l'interface réseau interne, ici enp0s8 --> IPv4

- Cochez "Manuel"
- Entrez l'adresse IP et les masque de sous réseau choisis, ici :

172.20.0.1 et 255.255.255.0 pour correspondre à l'adresse statique qui sera attribuée ensuite a un client (172.20.0.10).
Le réseau choisit est donc 172.20.0.0/24

Validez.


## Configure le service DHCP et met en place une adresse statique par adresse MAC pour un client particulier + adresses en dynamique

### 1) Installez le serveur DHCP :

Ouvrir un terminal et entrer la commande :

        sudo apt-get install isc-dhcp-server -y


### 2) Définir les interfaces utilisées par DHCPD pour traiter les requêtes

- Editez le fichier de configuration du serveur DHCP

        sudo nano /etc/default/isc-dhcp-server

Compléter le champ ci-dessous avec le nom de votre interface réseau:

        INTERFACESv4="enp0s8"

Enregistrez le fichier

3) Configuration du serveur DHCP pour IP dynamique et une adresse fixe 172.20.0.10

- Editez le fichier /etc/dhcp/dhcpd.conf:

        sudo nano /etc/dhcp/dhcpd.conf

-   vous pouvez modifier la durée de location par défaut et la durée de location maximum ici :

        default-lease-time 600;
        max-lease-time 7200;



- Décommentez le champs comme ci-dessous

        # If this DHCP server is the official DHCP server for the local
        # network, the authoritative directive should be uncommented.
        authoritative;

- Décommentez le champs comme ci-dessous

        # Use this to send dhcp log messages to a different log file (you also
        # have to hack syslog.conf to complete the redirection).
        log-facility local7;


- Décommentez le champ ci-dessous :

        #subnet 10.152.187.0 netmask 255.255.255.0 {
        #}
Et complétez avec vos informations réseau de la manière suivante (remplacer l'adresse par MAC par celle du client):

    #Déclaration d une etendue DHCP
    subnet 172.20.0.0 netmask 255.255.255.0 {
    range 172.20.0.100 172.20.0.200;
    }

    #attribution d'une adresse réservée
    host reserved-client {
    hardware ethernet 08:00:27:d1:f0:ff;
    fixed-address 172.20.0.10;
    }


- Relancez le service du serveur DHCP :

         sudo systemctl restart isc-dhcp-server.service

- Pour que le service démarre automatiquement au démarrage

        sudo systemctl enable isc-dhcp-server.service

- Faire les réglages dans le pare-feu

Démarrez le pare-feu avec cete commande :

        sudo ufw enable

- Autorisez le trafic entrant sur le port 67 UDP sur le réseau interne 

        sudo ufw allow in on enp0s8 to any port 67 proto udp    

- Rechargez le pare-feu

        sudo ufw reload

- Redémarrez le service DHCP 

        sudo systemctl restart isc-dhcp-server.service



La configuration est terminée.



## Test la bon fonctionnement du serveur avec un client classique et le client devant avoir une adresse statique

Test sur VM ubuntu avec adresse réservée :

- Configurez le client pour recevoir une IP via DHCP:

                sudo nano /etc/netplan/01-network.yaml


- Entre la configuration suivante :

            network:
                version: 2
                renderer: NetworkManager
                ethernets:
                enp0s8:
                dhcp4: yes    

- Appliquez la configuration

        sudo netplan apply



