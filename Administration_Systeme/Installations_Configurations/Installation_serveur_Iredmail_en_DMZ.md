## Installation d'un serveur Iredmail en DMZ

Préquis : Un domaine configuré dans Active Directory, une DMZ


### 1. Installation en DMZ

- Préparer un serveur Debian ave une IP fixe dans le réseau de la DMZ.

- Mettre le système à jour

            sudo apt update && sudo apt upgrade -y

- Renommer le serveur (par exemple : mail)

            sudo hostnamectl set-hostname mail

- Editer le fichier /etc/hosts en choisissant le FQDN du serveur mail :

            127.0.0.1   localhosts
            172.20.10.10 mail.billu.lan mail

 - Mettre le système à jour

            sudo apt update && sudo apt upgrade -y


### 2. Paramétrage DNS dans Active DIrectory

- Dans la console DNS Manager :
    
    - Créer un enregistrement A dans la zone DMZ avec le nom et l'adresse IP du serveur Debian

    - Créer un enregistrement MX dans la zone DMZ avec le nom et l"adresse IP du serveru Debian
          Entrer le FQDN indiqué dans la configuration Debian, par exemple: mail.billu.lan



### 3. Installation du serveur mail sur le serveur Debian

- Vérifier la dernière version disponible (https://www.iredmail.org/download.html) puis installer :

            wget https://github.com/iredmail/iRedMail/archive/refs/tags/1.7.4.tar.gz

- Décompresser l'archive :

            tar xvf 1.7.4.tar.gz

- Se placer dans le répertoire contenant le fichier d'installation :

            cd iRedmail-1.7.4

- Lancer le script d'installation

            bash iRedmail.sh


### 4. Paramétrage de l'installation

Suivre le menu d"installation

- Choisir l'emplacement de stockage des emails
- Serveur web: Nginx .
- Backend: OpenLDAP.
- LDAP Suffix, par exemple : dc=mail,dc=billu,dc=lan
- Premier domaine, par exemple: mail
- Mot de passe administrateur de la base de donnée:
- Nom de domaine du premier mail, par exemple: billu.lan
- Mot de passe administrateur du premier mail:
- Composant optionnel cocher toutes les options
- Confirmation: Vérifiez les options et confirmer.

### Accès aux interfaces web

- Accès à l'interface de gestion web : https://ip_debian/iredadmin

- Pour accéder à l'interface web :  http://ip_debian/mail






