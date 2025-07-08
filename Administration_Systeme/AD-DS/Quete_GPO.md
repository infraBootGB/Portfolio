#### 1) Créer la GPO "Wilders"

Lancer le Group Policy Management avec gpmc.msc.
Sélectionner le domaine et dérouler l'arborescence --> clic droit sur Wilder Students --> "Create a GPO in this domain, and link it there"--> Name : Wilders --> ok

#### 2) Modifier la GPO pour enlever l'accès au panneu de configuration

Dans Wilder_students faire un clic droit sur la GPO Wilders --> edit --> dérouler l'arborescence --> User Configuration--> POlicies --> Administrative templates --> COntrol Panel --> sur la partie droite de l'écran double-clic sur : "Prohibit acces to control panel and PC settings" --> enable --> apply --> ok

#### 3) appliquer la GPO au groupe Wilderstudents


Revenir dans la GPO Wilders --> onglet scope

Dans "Security filtering" supprimer "Authenticaded users" avec remove 

CLiquer sur Add en bas de l'écran --> advanced --> find now --> sélectionnier dans le menu déroulant : students --> ok : les réglage de la gpo s'appliquent uniquement à  : 

            Students  (WILDERS\Students)
               


Forcer la mise en place de la GPO --> ouvrir invite de commande avec cmd-->

        gpupdate /force

        Updating policy...

        Computer Policy update has completed successfully.
        User Policy update has completed successfully.

#### 4) Vérification

Retourner dans la GPO Wilders --> onglet settings --> ok --> en bas de l'écran dans la rubriuque "control panel" :

        Policy Setting Comment 
        Prohibit access to Control Panel and PC settings Enabled 
