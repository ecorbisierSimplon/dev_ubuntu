#!/bin/bash

if dpkg-query -l docker-compose >/dev/null 2>&1; then

    echo " * Docker-compose"
    echo "     est déjà installé avec la version $(docker-compose -v)."
else

    # Installer Docker Compose
    sudo apt install docker-compose

    # Supprimer les anciennes versions de Docker
    sudo apt install docker.io docker-compose

    # Mettre à jour à nouveau la liste des paquets
    sudo apt update

    # Installer les dépendances nécessaires
    sudo apt update

    sudo apt install apt-transport-https ca-certificates curl software-properties-common

    # Ajouter la clé GPG du site de Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Configurer le référentiel stable de Docker :
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    # Installer Docker Engine :
    sudo apt update

    sudo apt install docker-ce docker-ce-cli containerd.io

    # Installer Docker Compose
    sudo apt install docker-compose

    sudo apt update
fi
