### 1 - Ajoute un nouveau disque à la machine et ajoute le au groupe de volume debian-vg pour au moins doubler l'espace du groupe de volume

- Vérifier VG (volume Group)

        vgdisplay <machine-vg>

- créer le PV (Phisical volume)

        pvcreate /dev/sdb

- Vérifier le PV 

        pvdisplay /dev/sdb

- Extension du volume en ajoutant un disque (ici sdb)

        vgextend machine-vg /dev/sdb

- vérifier le VG

        vgdisplay

### 2 - Créer un snapshot de LV home

- Créer le snapshot

        lvcreate -L 2G -s -n home-snap /dev/machine-vg/home

Explication : Cette commande crée un snapshot nommé home-snap du volume logique home avec une taille allouée de 2 Go.

Détail des options :

    -L 2G : Alloue 2 Go pour le snapshot. Cette taille est utilisée pour stocker les différences entre le volume original et le snapshot (pas une copie complète).

    -s : Indique que c'est un snapshot (copie à un instant donné).
    
    -n home-snap : Donne le nom home-snap au snapshot.
    /dev/debian-vg/home : Spécifie le volume logique source (home) dans le groupe machine-vg.


Vérifier la création du snapshot

    lvdisplay /dev/vbox-vg/home-snap


### 3 - Monte le snapshot créé sur /home-snap

IL faut créer un point de montage home-snap (dossier)

        mkdir home-snap

et ensuite monter le snapshot sur le dossier

        root@vbox:~# mount /dev/vbox-vg/home-snap /home-snap

Pour vérfier

    df -h 


### 4 - Constate que /home-snap est bien une copie de /home

        ls -l /home
        ls -l /home-snap

### 5 - On peut alors travailler sur /home-snap et y faire des modifications. En supposant qu'on a maintenant plus besoin de la copie, démonte /home-snap
testé avec une création de fichier et ajout de texte à l'intérieur

### 6 - Détruit le snapshot

        lvremove /dev/debian-vg/home-snap 