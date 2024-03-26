#!/bin/bash
# Inclure le fichier de fonctions
functions_file="$1"
source script-functions.sh

version_nodejs=21
# Récupérer la version de Node.js
version=$(node -v)

# Extraire la partie numérique de la version (en supposant que la version est sous le format 'vX.Y.Z')
version_number=${version#v}           # Supprimer le préfixe 'v'
version_integer=${version_number//./} # Supprimer les points pour obtenir un nombre entier

# Vérifier si la version de Node.js est supérieure ou égale à 21
if [ "$version_integer" -ge "$version_nodejs" ]; then
    dial " * Node.js\n     est déjà installé avec la version $version_number."
else
    # Mise à jour des dépôts et installation de Node.js
    sudo apt update
    sudo apt install -y nodejs

    # Installation de npm
    sudo apt install -y npm

    # Installation de NVM (Node Version Manager)
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    source ~/.bashrc # Charger les modifications du fichier .bashrc dans l'environnement actuel

    # Installation de Node.js version 21
    nvm install $version_nodejs

    # Afficher la version actuelle de Node.js
    dial " * Node.js\n     est déjà installé avec la version $(node -v)"
fi
