
## Installation d'un serveur web Apache dans un conteneur Ubuntu
<span id="Apache"></span>


#### 1 -  Configurer le conteneur dans Proxmox pour etre dans la DMZ


Vérifier interface de la DMZ dans proxmox --> vmbr 110

Vérifier l'adresse de la DMZ dans pPfsense  : Firewall --> rules --> DMZ = 172.20.10.1

Mettre un ip incluse dans le réseau de la DMZ 172.20.10.0/24: --> 172.20.10.2

Gateway = ip de la DMZ --> 172.20.10.1

DNS -->  172.20.10.1 ou 8.8.8.8


- faire la mise à jours du conteneur :

        sudo apt update && sudo apt upgrade -y

#### 2 - Installation de apache

        sudo apt install apache2

        enable apache2

Vérifier le status :

        sudo systemctl status apache2


#### 3 - Test

- se connecter avec un navigateur via l'ip du conteneur.

#### 4 - Paramétrage apache 2


- créer un fichier de configuration

        touch /etc/apache2/sites-available/intranet.conf

- créer un répertoire pour les fichier du site :

        mkdir /var/www/html/intranet

- éditer le fichier :


    nano /etc/apache2/sites-available/intranet.conf

Ajouter dans le fichier

        <VirtualHost *:80>                                  --> hote virtuel, accepte les connexions venant de n'importe quelle ip sur port 80


            ServerName billu.intranet                       --> l'hote virtuel sera appelé à cette adresse
            DocumentRoot /var/www/html/intranet/            --> les fichiers du ite seront dans ce répertoire

        <Directory /var/www/html/intranet>
            Require IP 172.16.10.0/24                       --> Accès uniquement depuis le ce réseau
        </Directory>

            ErrorLog /var/log/apache2/intranet.log          --> fichier logs / journaux

            CustomLog /var/log/apache2/intranet_access.log combined  --> fichier logs / journaux

        </VirtualHost>




- Modifier les permissions pour l'utilisateur www-data
    
        chown -R www-data:www-data /var/www/html/intranet
        chmod -R 755 /var/www/html/intranet


- activer le site 

        a2ensite intranet.conf

Le system demande d'effectuer la commande suivante pour activer le site :

        systemctl reload apache2

et vérifier :

        systemctl status apache 2
        apache2ctl configtest


#### 5 - Création page web

- Intégrer le contenu html dans le fichier :

        nano /var/www/html/index.html

#### 6 - Tester sur un client du domaine

- se connecter  via un navigateur sur l'ip du conteneur --> la nouvelle page s'affiche.

- Tester aussi avec l'adresse : http://billu.intranet



