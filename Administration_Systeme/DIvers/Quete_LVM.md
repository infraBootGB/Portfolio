1) commandes 

            pvs --> voir les disques physiques et a quel groupe ils appartiennent pv =physical volume
 
            vgs --> voir les volumes groupes

            lvs --> détail de logical volumes

            lsblk qui affiche la liste des périphériques bloc et leur type donc aussi la liste des LV

            pvs, vgs et lvs qui affichent la liste courte des PV, VG et LV

            pvdisplay, vgdisplay et lvdisplay qui affichent le détail des PV, VG et LV




2) installation des outils

    sudo apt install lvm2