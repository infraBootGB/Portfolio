#!/bin/bash


#Le script demande quel dossier l'utilisateur souhaite sauvegarder 
read -p "Merci d'indiquer le dossier que vous souhaitez sauvegarder :"  nom_du_dossier 
 

#si le dossier n'existe pas
if ![ -e $nom_du_dossier ]

#renvoyer message erreur
then
    echo "ce dossier n'existe pas"

fi
#demande ou sauvegarder le fichier
read -p "ou souhaitez-vous sauvegarder le fichier" emplacement

#demande confirmation emplacment
read -p "confirmez-vous enregistrer $nom_du_dossier à cet emplacement? : $emplacement ? o/n" reponse

# si non sortie du script
if [ $reponse="n" ]

then
    exit 0

fi

#si oui creer le dossier à l'emplacement
if [ $reponse="o" ]

then
    cd $emplacement
    mkdir $nom_du_dossier 


fi

#confirmer la sauvegarde
if [ -e $nom_du_dossier]

then
    echo " la sauvegarde est correctement effectuée"

fi

#nouvelle demande
read -p "voulez-vous saugarder un nouveau dossier?" demande



 

