### 1 - Installer le role de serveur de fichiers

Dans le server manager --> Add roles and features --> next-->next--> 
cocher Files and Iscsi Services et Storage Services --> dans l'arborescence sélectioner  File Server -->  finir l'installation avec l'assistant.

### 2 - Créer un dossier "Documents_Entreprise" à la racine du disque C:

        New-Item -Path "C:\Documents_Entreprise" -ItemType Directory

### 3 - Configurer un partage nommé "Docs" pour ce dossier

        New-SmbShare -Name "Docs" -Path "C:\Documents_Entreprise" -FullAccess "Everyone"

### 4 - Créer trois sous-dossiers : "RH", "Comptabilité" et "Direction"

        New-Item -Path "C:\Documents_Entreprise\RH" -ItemType Directory
        New-Item -Path "C:\Documents_Entreprise\Comptabilité" -ItemType Directory
        New-Item -Path "C:\Documents_Entreprise\Direction" -ItemType Directory


### 5 - Configurer les permissions NTFS


- Ajouter le serveur comme DNS dans la configuration réseau du client
- Ajouter le client au domaine (paramètres avancés du système ) et redémarrer.
- activer la découverte réseau sur le client et le serveur
- Créer les groupes RH, Comptabilité et directions --> server manager --> Tools -->
Active Directory Users and Computers --> clic droit sur le nom de domaine --> New --> group --> entrer le nom du groupe --> global --> valider et les ajouter au OU respectives. Faire pour les 2 groupes.
- créer un utilisateur pour chaque groupe et l'ajouter comme mabmbre du groupe (clic droit --> properties--> members --> add)


- Pour les permissions du dossier RH :

  - désactiver l'héritage des permissions : pour le dossier RH --> clic droit --> security --> advanced --> remove all inheritance for this object--> (choisir "convert etc..) apply--> ok
  - Revenir dans l'onglet security et supprimer Users(ENTREPRISE\Users) : ajouter les groupes RH et Direction en lecture et écriture.

- Faire la même chose pour le dossier Comptabilité.

- Pour le dossier direction idem et ajouter le groupe Direction en lecture et écriture.

- Pour que tous les utilisateurs du domaine aient un accès en lecture seule au dossier "Documents_Entreprise" désactiver l'héritage (onglet sécurity--> advanced) pour le groupe Users(ENTREPRISE\Users) et ensuite dans l'onglet sécurity --> edit pour attirubuer les permission lecture et écriture uniquement pour le groupe Users(ENTREPRISE\Users).
    - Toujours sur le dossier "Document-entreprises" clic droit --> sharing --> advanced sharing --> permissions --> ajouter les 3 groupes RH,Comptabilitéet DIrection + allow read pour autoriser l'accès.






### 6 - Utiliser PowerShell pour lister tous les partages sur le serveur

         C:\Users\Administrator> Get-SmbShare

        Name     ScopeName Path                                              Description
        ----     --------- ----                                              -----------
        ADMIN$   *         C:\Windows                                        Remote Admin
        C$       *         C:\                                               Default share
        Docs     *         C:\Documents_Entreprise
        IPC$     *                                                           Remote IPC
        NETLOGON *         C:\Windows\SYSVOL\sysvol\entreprise.local\SCRIPTS Logon server share
        SYSVOL   *         C:\Windows\SYSVOL\sysvol                          Logon server share

### 7 - Sur un poste client Windows 10, configure un lecteur réseau pointant vers ce partage via PowerShell

    
- ouvrir une session sur le client avec un des nouveaux utilisateurs créés

- configurer le lecteur réseau sur le client

        New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\IP_Serveur\Docs" -Persist
        ou
        New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\Nom_du_Domaine\Docs" -Persist

        ici : 

        New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\entreprise.local\Docs" -Persist



- Vérifier la création du lecteur "Z" sur le client dans "ce PC" --> l'accès est possible en fonction de l'utilisateur utilisé, tester avec tous les utilisateurs --> ok.






8



