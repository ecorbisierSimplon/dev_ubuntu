#!/bin/bash

start_directory="/"

# Rechercher le fichier de fonctions de manière récursive
functions_file=$(find "$start_directory" -type f -name "script-functions.sh" -print -quit)
clear
# Vérifier si le fichier de fonctions a été trouvé
if [ -z "$functions_file" ]; then
    echo "Le fichier de fonctions n'a pas été trouvé."
    exit 1
fi

# Inclure le fichier de fonctions
echo "$functions_file"

# Utiliser les fonctions définies dans functions.sh

chmod +x ./script-default.sh
chmod +x ./script-install.sh
chmod +x ./script-docker.sh
chmod +x ./script-jdk.sh
chmod +x ./script-nodejs.sh
chmod +x ./script-wine.sh
chmod +x ./script-copy.sh
chmod +x ./script-visudo.sh
chmod +x ./script-key-dock.sh
chmod +x ./script-key-github.sh

# clear
# Mettre à jour la liste des paquets
echo "__________________"
echo
echo " # Mise à jours des paquets existants :"
echo "   ----------------------------------"
echo
# sudo apt update

# Echapper avec un '#' les éléments que vous ne voulez pas installer
echo "__________________"
echo
sudo ./script-default.sh $functions_file
echo "__________________"
echo
sudo ./script-install.sh $functions_file
# echo "__________________"
# echo
# sudo ./script-docker.sh $functions_file
# echo "__________________"
# echo
# sudo ./script-jdk.sh $functions_file
# echo "__________________"
# echo
# sudo ./script-nodejs.sh $functions_file
# echo "__________________"
# echo
# sudo ./script-wine.sh $functions_file
# echo "__________________"
# echo
# sudo ./script-copy.sh $functions_file
# echo "__________________"
# echo
# sudo ./script-visudo.sh $functions_file
# echo "__________________"
# echo
# sudo ./script-key-dock.sh $functions_file
# echo "__________________"
# echo
# sudo ./script-key-github.sh $functions_file
# echo "__________________"
# echo
