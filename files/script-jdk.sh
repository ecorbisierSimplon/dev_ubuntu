#!/bin/bash
# Inclure le fichier de fonctions
source "$FUNCTIONS_FILE"

java_version=17

# Exécuter la commande java --version et stocker la sortie dans la variable "java_version"
version_java=$(java --version 2>&1 | head -n 1)

# Extraire uniquement le numéro de version
version_number=$(echo "$version_java" | grep -oP '\d+\.\d+\.\d+')

# Supprimer les points de la version et la stocker comme entier
version_integer=$(echo "$version_number" | cut -d '.' -f 1)

# Vérifier si la version de Node.js est supérieure ou égale à 21
if [ "$version_integer" -ge "$java_version" ]; then
    dial " * Java\n     est déjà installé avec la version $version_number."
else
    sudo apt update
    sudo apt-get install openjdk-17-jdk
    dial " * Java\n     est installé avec la version  $(java --version 2>&1 | head -n 1)"
fi
