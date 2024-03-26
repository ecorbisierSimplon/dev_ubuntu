#!/bin/bash
clear
start_directory="/"

# Rechercher le fichier de fonctions de manière récursive
echo "Recherche du fichier 'script-functions.sh'"
functions_file=$(find "$start_directory" -type f -name "script-functions.sh" -print -quit)

functions_directory="."
clear
# Vérifier si le fichier de fonctions a été trouvé
if [ -z "$functions_file" ]; then
    zenity --error \
        --text="Le fichier de fonctions n'a pas été trouvé."

    exit 1
else
    functions_directory=$(dirname "$functions_file")
fi
echo "INSTALLATION UBUNTU" >$functions_directory/zenity_text.txt
echo "-------------------" >>$functions_directory/zenity_text.txt

# Inclure le fichier de fonctions
source $functions_file
# Utiliser les fonctions définies dans functions.sh

dial "Chargement des scripts"
sleep 2
chmod +x $functions_directory/script-default.sh
chmod +x $functions_directory/script-install.sh
chmod +x $functions_directory/script-docker.sh
chmod +x $functions_directory/script-jdk.sh
chmod +x $functions_directory/script-nodejs.sh
chmod +x $functions_directory/script-wine.sh
chmod +x $functions_directory/script-copy.sh
chmod +x $functions_directory/script-visudo.sh
chmod +x $functions_directory/script-key-dock.sh
chmod +x $functions_directory/script-key-github.sh

dial "Chargement des scripts TERMINÉ" "-"

clear
# Mettre à jour la liste des paquets

dial " # Mise à jours des paquets existants"

sudo apt full-upgrade -y
return_code=$?
if [ $return_code -eq 0 ]; then
    dial " ** Mise à jour OK"
else
    dial " ** Erreur de mise à jour : $return_code" "-"
fi
clear

# Echapper avec un '#' les éléments que vous ne voulez pas installer
dial "Mise à jours des paquets existants TERMINÉ" "-"
dial " # Installation des paquets"
# sudo $functions_directory/script-default.sh $functions_file

# sudo $functions_directory/script-install.sh $functions_file

# dial "Installations des paquets TERMINÉ" "-"
# sleep 5
# dial " # Installation du système d'environnements "

# sudo $functions_directory/script-docker.sh $functions_file

# sudo $functions_directory/script-jdk.sh $functions_file

# sudo $functions_directory/script-nodejs.sh $functions_file

# sudo $functions_directory/script-wine.sh $functions_file

sudo $functions_directory/script-copy.sh $functions_file

# sudo $functions_directory/script-visudo.sh $functions_file

# sudo $functions_directory/script-key-dock.sh $functions_file

# sudo $functions_directory/script-key-github.sh $functions_file
# pkill -f zenity
# sleep 1

# dial "Installations du système d'environnements  TERMINÉ" "-"
# sleep 5

cp "$functions_directory/zenity_text.txt" "$functions_directory/zenity_text.sh"
if zenity \
    --text-info \
    --title="Information" \
    --filename=zenity_text.txt \
    --ok-label="Oui" \
    --checkbox="Ouvrir le fichier 'log'" \
    --width=640 \
    --height=860; then
    xdg-open ./zenity_text.sh
fi
