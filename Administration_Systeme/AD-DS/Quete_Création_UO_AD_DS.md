

### Création d"une UO, d"un groupe utilisateur  ajout d'un nouvel utilisateur 

Cette procédure suppose d'avoir une machine windows avec AD installé et le role controleur de domaine configuré
et l'accès à la session administrateur.

#### 1) Créer l'UO


Dans le server manager --> Tools--> Active Directory Users and Computers

Dans la partie gauche --> clique droit sur le nom de domaine --> New --> Organizational Unit--> Name entrer le nom de l'UO ici : Wilders_students --> ok--> l'UO apparait dans l'arborescence du domaine.


#### 2) Creer le groupe Students

Faire un clic droit sur Wilder_Students --> new--> group --> name : entrer le nom choisi : Students--> laisser les options par défaut--> ok --> le groupe apparait dans la partie droite dans Wilder_Student.

#### 3) Créer un utilisateur 

Dans la partie gauche --> clique droit sur le nom de domaine --> New -->user--> First name "toto"--> last name "titi--> user logon "toto"--> next--> choisir un mot de passe --> modifier les options si besoin -->next --> finish

#### 4) Ajouter l'utilisateur au groupe

DOuble-clic sur le group "Students"--> add--> entrer le nom --> chek names-->apply --> ok

Double clic sur l'utilisateur pour vérifier --> Member of : Students doit apparaitre.


