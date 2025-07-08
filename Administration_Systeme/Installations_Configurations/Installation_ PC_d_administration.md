

### Installation du PC d'administration

#### Pour l'Administration  des serveurs Windows

#### 1. Installer RSAT

Non disponible en version graphique sur notre version windows 10 PRO --> installation avec Powershell

            Get-WindowsCapability -Name "RSAT*" -Online | Add-WindowsCapability -Online

#### 2. Activation de RDP

        Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0

### 3. Remote powershell

- le pare-feu doit être désactivé

- activer winRM

        Enable-PSRemoting   
        
        ( ou  Enable-PSRemoting -f )


- Redémarrer le service :

        Restart-Service winrm

- Tester la connection :

        Enter-PSSession -ComputerName WINSRVGUI01 -credential (Get-Credential)

  Entrer ID + mdp


#### 4. Serveur RDP

- Ajouter le rôle : Remote Desktop Service

- Dans "Select Role Service" cocher : Remote Desktop Gateway

- Redémarrer le serveur après l'installation

- Ouvrir la console Remote Gateway Manager (dispo dans Tools--> Remote Desktop Services )

- Configurer les règles de RD Gateway: 

- Cliquer sur Create New Authorization Policy 
     --> Create New --> donner un nom (RD-ADMIN) --> ajouter le groupe qui aura accès --> DSI --> Ressources authorisation policy = RD-ADMIN --> Dans Network ressources = cocher allow all users... -->  Terminer

- Création d'un certifcat autosigné

  - Sélectionner le serveur en haut à gauche
  - clic droit --> properties --> SSL Certificate --> Create a self-signed certificate
  - choisir le chemin ou sera stocké le certificat


- Vérifier la création dans la console "Services"
- Double clic sur le certificat : startup type = Automatic
 
- Connexion depuis le pc d admninistration

   Récupérer le certificat via un dossier partager et l'importer
   Cliquer sur installer le certificat --> cliquer ordinateur local
   --> placer tous les certificats dans le magasin de confiance --> terminer

- Se connecter avec RDP

   - Onglet "Avancé" --> Paramètres --> Nom du serveur passerelle (Serveur AD) --> cocher les 2 cases--> terminer

   - Dans l'onglet "Général" rentrer les infos de connexion :  ip du serveur cible + nom d"'utilisateur (BIllu\Administrator)





#### 5. Suite Sysinternals

- Télécharger la suite  ici : https://download.sysinternals.com/files/SysinternalsSuite.zip

- Faire l'installation du fichier .exe

### Pour l'administration des PC Linux

#### 1. Installation de Gitbash : 

  https://git-scm.com/downloads  

#### 2. Installation de Putty

  www.chiark.greenend.org.uk/~sgtatham/putty/

#### 3.  Installation de Wincscp

https://winscp.net/eng/docs/guide_install

#### 4. Installation de WSL

- Entrer la ligne de commande

        wsl --install

- Redémarrer le serveur

#### 5. Installation de Rustdesk (prise en main à distance GUI)

- se rendre sur  :

https://github.com/rustdesk/rustdesk/releases/tag/1.4.0

- Choisir le paquet .msi et l'installer

- Faire une GPO ordinateurs dans AD pour l'installer sur les autres machine du domaine.

- Connecter les machines avec les identifiants affichés


