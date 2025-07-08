## Insatllation server web + et reverse proxy

### 1. Prérequis

- 1 VM debian 12 par pont /dhcp + ssh pour le serveur
- 1 VM debian 12 par pont /dhcp + ssh pour le proxy
- un compte su rle site No-ip :https://my.noip.com/
- faire les mises à jours :
        apt update
        apt upgrade
- vérifier si ssh présent sinon installer
        apt install openssh-server

    Mofifier le fichier de configuration si besoin (permitt root login, clés, autoriser password etc...)

        nano /etc/apt/ssh/sshd_config


### 2. Installation apache

- Installer :

        apt install apache2 -y

- Vérifier :

        systemctl status  apache2

Ensuite se connecter via un navigateur http://ip_server

La page d'acceuil apache doit aparaitre.

### 3. Configuration de la page d'accueil

La page d'accueil est disponible ici pour en modifier le contenu :

        /var/www/html/index.html

### 4.  Configuration de la box internet

- Dans l'interface de la box, enregistrer une redirection :

        ip sources = toutes
        ipdestination = ip du serveur web
        protocole tcp
        port de destination 80


- Tester :

    Obtenir IP publique :

        curl -4 ifconfig.me

- Se connecter sur cette ip via un navigateur de puis un appareil non connecté au réseau --> la page internet s'affiche = ok

- Pour sécuriser modifier la réglage PAT (Port Adress Translation)

        ip destination = toujours ip_du_server_web
        port de début =  16000
        port de fin = 16000
        port de destination = 80

DOnc ici la connexion via l'adresse ip publique 88.XXX.XXX.XXX:16000
    

### 5. Enregistrer le nom de domaine

- Se connecter sur le site noip.com et réserver un nom de domaine et ensuite se connecter via un navigateur :

        bwild.ddns.net:160000

### 6 Mise en place d"un reverse proxy (pour sécuriser l'accès au serveur)

Sur la VM debian Proxy 
 - Installer Apache2
        apt install apache2 -y

 - Activer les modules diu reverse proxy

        a2enmod proxy
        a2enmod proxy_http
        a2enmod proxy_balancer
        a2enmod lbmethod_byrequests

- Explications

    apt install apache2 -y : Installe le serveur web Apache2 sur la machine (ici une VM proxy,  sous Debian).

    a2enmod proxy : Active le module de base pour le proxy dans Apache, qui permet à Apache de gérer les requêtes en tant que proxy.

    a2enmod proxy_http : Active le module pour le protocole HTTP, permettant au reverse proxy de rediriger les requêtes HTTP vers un serveur backend (celui qui héberge le site internet).
    
    a2enmod proxy_balancer : Active le module de répartition de charge (load balancing), utile si le reverse proxy doit répartir les requêtes entre plusieurs serveurs backend.

    a2enmod lbmethod_byrequests : Active une méthode de répartition basée sur le nombre de requêtes, pour équilibrer la charge entre les serveurs backend.

- copier le fichier /etc/apache2/sites-availables/000.conf vers un fichier nommé .bak (backup)

- modifier le fichier .conf

        #ici avec le port de redirection choisi sur le box
        <VirtualHost *:16000>   

            # Ici on doit trouver le nom de ton site avec le domaine
            ServerName bwild.ddns.net

            ProxyPreserveHost On
            # Les 2 paramètres ci-dessous doivent avoir l'adresse IP de la VM webserver avec le port par défaut pour le http, donc 80
            ProxyPass / http://192.168.1.30:80/
            ProxyPassReverse / http://192.168.1.30:80/

            <Location />
                Order allow,deny
                Allow from all
            </Location>
        </VirtualHost>

- il faut ensuite modifier le port d'écoute du serveur (reverse proxy) en éditant le fichier en ajoutant le port 16000 :
        /etc/apache2/ports.conf

    Ajouter la ligne :

        Listen 16000

- ensuite relancer la configuration du serveur :

        a2ensite 000-default.conf
        systemctl restart apache2

- Modifier la regle PAT sur la box 'supprimer l'ancienne)

    Rediriger le port 16000 externe vers le port 16000 interne
    Le tout est redirigé sur l'adresse IP du proxy, donc :

    IP DESTINATION  = ip du reverse proxy
    IP Sources      = toutes
    Protcole        = TCP
    Port de début   = 16000
    Port de fin     = 16000
    Port de destination = 16000

    Verifier qu'on peut se conecter avec 
    
        site.nom_de_domaine:port

- Ensuite pour se connecter sans préciser le port

    Modifier le fichier en mettant le virtual host = 80 :
        /etc/apache2/sites-available/000-default.conf 

    Relancer la configuration 

        a2ensite 000-default.conf
        systemctl restart apache2

    IL est maintenant possible de se conecter avec  :

        site.nom_de_domaine