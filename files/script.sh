#!/bin/bash
clear

start_directory=$(pwd)
home=~

echo $home

# Rechercher le fichier de fonctions de manière récursive
echo "Recherche du fichier 'script-functions.sh'"
export FUNCTIONS_FILE=$(find "$start_directory" -type f -name "script-functions.sh" -print -quit)
functions_directory="."
clear

# Vérifier si le fichier de fonctions a été trouvé
if [ -z "$FUNCTIONS_FILE" ]; then
    zenity --error \
        --text="Le fichier '$FUNCTIONS_FILE' n'a pas été trouvé."
    exit 1
else
    functions_directory=$(dirname "$FUNCTIONS_FILE")
fi
export FUNCTIONS_DIRECTORY = $functions_directory

# INSTALLATION DE FONCTIONNALITÉS POUR UBUNTU
# ---------------------------------------------------
echo "INSTALLATION DE FONCTIONNALITÉS POUR UBUNTU" >$FUNCTIONS_DIRECTORY/$FOLDER_NEWS.txt
echo "-------------------------------------------" >>$FUNCTIONS_DIRECTORY/$FOLDER_NEWS.txt

# Inclure le fichier de fonctions
source $FUNCTIONS_FILE
# Utiliser les fonctions définies dans functions.sh

dial "Chargement des scripts"
sleep 2
chmod +x $FUNCTIONS_DIRECTORY/script-default.sh
chmod +x $FUNCTIONS_DIRECTORY/script-install.sh
chmod +x $FUNCTIONS_DIRECTORY/script-docker.sh
chmod +x $FUNCTIONS_DIRECTORY/script-jdk.sh
chmod +x $FUNCTIONS_DIRECTORY/script-nodejs.sh
chmod +x $FUNCTIONS_DIRECTORY/script-wine.sh
chmod +x $FUNCTIONS_DIRECTORY/script-copy.sh
chmod +x $FUNCTIONS_DIRECTORY/script-visudo.sh
chmod +x $FUNCTIONS_DIRECTORY/script-key-dock.sh
chmod +x $FUNCTIONS_DIRECTORY/script-key-github.sh

dial "Chargement des scripts TERMINÉ" "-"
clear

# ----------------------------------
# Mettre à jour la liste des paquets
# ----------------------------------
dial " # Mise à jours des paquets existants"
# ----------------------------------

sudo apt full-upgrade -y
return_code=$?
if [ $return_code -eq 0 ]; then
    dial " ** Mise à jour OK"
else
    dial " ** Erreur de mise à jour : $return_code" "-"
fi
clear

$FUNCTIONS_DIRECTORY/script-install.sh "1"

dial "Mise à jours des paquets existants TERMINÉES" "-"
sleep 1

# -------------------------------------------------------------
# Echapper avec un '#' les éléments que vous ne voulez pas installer
# -------------------------------------------------------------
dial " # Installation des clés"
# -------------------------------------------------------------

$FUNCTIONS_DIRECTORY/script-install.sh "2"

# $FUNCTIONS_DIRECTORY/script-copy.sh

$FUNCTIONS_DIRECTORY/script-key-github.sh

$FUNCTIONS_DIRECTORY/script-docker.sh

$FUNCTIONS_DIRECTORY/script-key-dock.sh

dial "Installation des clés TERMINÉE" "-"
sleep 1

# --------------------------------
dial " # Installation des paquets"
# --------------------------------

$FUNCTIONS_DIRECTORY/script-default.sh

$FUNCTIONS_DIRECTORY/script-install.sh

dial "Installation des paquets TERMINÉE" "-"
sleep 1

# -------------------------------------------------
dial " # Installation du système d'environnements "
# -------------------------------------------------

$FUNCTIONS_DIRECTORY/script-jdk.sh

$FUNCTIONS_DIRECTORY/script-nodejs.sh

$FUNCTIONS_DIRECTORY/script-wine.sh

$FUNCTIONS_DIRECTORY/script-visudo.sh

# pkill -f zenity
# sleep 1
dial "Installation du système d'environnements  TERMINÉE" "-"
# sleep 1

# -------------------------------------------------------------
# -------------------------------------------------------------
folder_news_doc = "~/Documents/$FOLDER_NEWS"
if [ ! -d "$folder_news_doc" ]; then
    sudo mkdir $folder_news_doc
fi
$dt = $(date +"%Y-%m-%d_%T")
cp "$FUNCTIONS_DIRECTORY/$FOLDER_NEWS.txt" "$folder_news_doc/$FOLDER_NEWS-$dt.sh"
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
    xdg-open $folder_news_doc/$FOLDER_NEW-$dt.sh
fi