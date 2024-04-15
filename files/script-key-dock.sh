#!/bin/bash
source $FUNCTIONS_FILE
source ~/.bashrc 
source ~/.bash_aliases

echo ""
echo "======================================================"
echo "                 NUM : 'script key dock'"
echo "======================================================"
echo ""
# Récupération du dossier personnel
home="/home/$(echo "$FUNCTIONS_DIRECTORY" | awk -F'/' '{print $3}')"

dial " script-key-dock.sh"
dial " --------------------"

title="Connexion Docker"
if zenity --question --title $title --text "Veux tu générer le pass pour te connecter à Docker desktop ?"; then
    # Extraire le numéro de clé GPG de la sortie
    zenity --warning --text "Une phrase secrète va vous être demandée.\n<b>Conservez la bien</b> car c'est le mot de passe pour se connecter à Docker Desktop !!!"
    zenity --info --text "Veuillez remplir le formulaire sur le terminal ..."
    key_id=$(gpg --generate-key | grep -oE '[0-9A-F]{40}')

    # Afficher le numéro de clé GPG
    dial "Numéro de clé GPG : $key_id"
    dial 'Création du pass'

    pass init $key_id

    if zenity --question --title $title --text "Veux tu ouvrir docker desktop pour te connecter ?"; then
        /opt/docker-desktop/bin/docker-desktop
    else
        dial "Connection Docker non effectuée !"
    fi
else
    dial "Génération du pass Docker non effectuée !"
fi
