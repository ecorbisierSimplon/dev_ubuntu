#!/bin/bash
# clear

start_directory=$(pwd)
home=~
echo ""
echo "======================================================"
echo "                  '$(basename "$0")'"
echo "======================================================"
echo ""
echo $home

# Rechercher le fichier de fonctions de manière récursive
echo "Recherche du fichier 'script-functions.sh'"
export FUNCTIONS_FILE=$(find "$start_directory" -type f -name "script-functions.sh" -print -quit)
functions_directory="."

# Vérifier si le fichier de fonctions a été trouvé
if [ -z "$FUNCTIONS_FILE" ]; then
    zenity --error \
        --text="Le fichier '$FUNCTIONS_FILE' n'a pas été trouvé."
    pause p stop
else
    functions_directory=$(dirname "$FUNCTIONS_FILE")
fi
export FUNCTIONS_DIRECTORY=$functions_directory

# Inclure le fichier de fonctions
source $FUNCTIONS_FILE

# INSTALLATION DE FONCTIONNALITÉS POUR UBUNTU
# ---------------------------------------------------
dial "INSTALLATION DE FONCTIONNALITÉS POUR UBUNTU" "-"

sudo chmod +x $FUNCTIONS_DIRECTORY/script-install.sh
sudo chmod +x $FUNCTIONS_DIRECTORY/script-key-github.sh
sudo chmod +x $FUNCTIONS_DIRECTORY/script-docker.sh
sudo chmod +x $FUNCTIONS_DIRECTORY/script-default.sh
sudo chmod +x $FUNCTIONS_DIRECTORY/script-install-complex.sh
sudo chmod +x $FUNCTIONS_DIRECTORY/script-visudo.sh
sudo chmod +x $FUNCTIONS_DIRECTORY/script-key-dock.sh
sudo chmod +x $FUNCTIONS_DIRECTORY/script-settings-system.sh
sudo chmod +x $FUNCTIONS_DIRECTORY/script-setting-ubuntu.sh

# clear

# ----------------------------------
# Mettre à jour la liste des paquets
# ----------------------------------
dial " # Mise à jours des paquets existants"
# ----------------------------------

pause s 2

sudo apt full-upgrade -y
return_code=$?
if [ $return_code -eq 0 ]; then
    dial " ** Mise à jour OK"
else
    dial " ** Erreur de mise à jour : $return_code" "-"
fi

source ~/.bashrc
source ~/.bash_aliases

pause c s 2
$FUNCTIONS_DIRECTORY/script-install.sh "1"

dial "Mise à jours des paquets existants TERMINÉES" "-"
pause c s 2

# -------------------------------------------------------------
# Echapper avec un '#' les éléments que vous ne voulez pas installer
# -------------------------------------------------------------
dial " # Installation des clés"
# -------------------------------------------------------------

# $FUNCTIONS_DIRECTORY/script-install.sh "2"

# pause c s 2
# $FUNCTIONS_DIRECTORY/script-key-github.sh

# pause c s 2
# $FUNCTIONS_DIRECTORY/script-docker.sh

# pause c s 2
# $FUNCTIONS_DIRECTORY/script-key-dock.sh

dial "Installation des clés TERMINÉE" "-"
pause c s 2
# --------------------------------
dial " # Installation des paquets" "-"
# --------------------------------

# $FUNCTIONS_DIRECTORY/script-default.sh

# pause c s 2
# $FUNCTIONS_DIRECTORY/script-install.sh "1000"

dial "Installation des paquets TERMINÉE" "-"
pause c s 2

# -------------------------------------------------
dial " # Installation du système d'environnements " "-"
# -------------------------------------------------

# pause c s 2
# $FUNCTIONS_DIRECTORY/script-visudo.sh

# pause c s 2
# $FUNCTIONS_DIRECTORY/script-settings-system.sh

pkill -f zenity
#  pause c s 1
dial "Installation du système d'environnements  TERMINÉE" "-"
pause s 2

# -------------------------------------------------------------
# -------------------------------------------------------------
folder_news_doc=~/Documents/$FOLDER_NEWS
if [ ! -d "$folder_news_doc" ]; then
    sudo mkdir $folder_news_doc
fi
pause s 1
sudo chown -R $user $folder_news_doc

dt=$(date +"%Y-%m-%d_%T")

sudo cp "$FUNCTIONS_DIRECTORY/$FOLDER_NEWS.txt" "$folder_news_doc/$FOLDER_NEWS-$dt.sh"
if zenity \
    --text-info \
    --title="Information" \
    --filename=$FOLDER_NEWS.txt \
    --ok-label="Ouvrir 'log'" \
    --cancel-label="Terminer" \
    --checkbox="Ouvrir le fichier 'log'" \
    --width=640 \
    --height=860 \
    --timeout=20; then
    xdg-open $folder_news_doc/$FOLDER_NEWS-$dt.sh
fi

folder_doc=~/Documents
cd $folder_doc/

if zenity --question --title=$title --text="Veux tu supprimer le dossier d'initialisation ?"; then
    if [[ -d "$FOLDER_INST" ]]; then
        resultat=$(echo "$FOLDER_INST" | sed 's/dev_ubuntu//')
        sudo mv $FOLDER_INST/install.sh $resultat
        pause s 2 m
        sudo rm -r $FOLDER_INST
        pause s 2 m

    fi

    sudo mv $folder_doc/dev_ubuntu/install.sh $folder_doc/
    sudo rm -r $folder_doc/dev_ubuntu/
fi

pause s 2 m
