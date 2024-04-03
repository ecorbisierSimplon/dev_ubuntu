#!/bin/bash
# Inclure le fichier de fonctions
source "$FUNCTIONS_FILE"

t1=" script-docker.sh"
t2=" --------------------"
dial $t1
dial $t2
if dpkg-query -l docker-compose >/dev/null 2>&1; then

    dial " * Docker-compose est déjà installé avec la version $(docker-compose -v)."
    sleep 3
else

    # Installer Docker Compose
    sudo apt install docker-compose -y
    clear

    echo $t1
    echo $t2
    # Supprimer les anciennes versions de Docker
    sudo apt install docker.io docker-compose -y
    clear

    echo $t1
    echo $t2
    # Mettre à jour à nouveau la liste des paquets
    sudo apt update -y
    clear

    echo $t1
    echo $t2
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    clear

    echo $t1
    echo $t2
    # Ajouter la clé GPG du site de Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    clear

    echo $t1
    echo $t2
    # Configurer le référentiel stable de Docker :
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    clear

    echo $t1
    echo $t2
    # Installer Docker Engine :
    sudo apt update -y
    clear

    echo $t1
    echo $t2
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    clear

    # Installer Docker Compose
    sudo apt install docker-compose -y
    clear

    echo $t1
    echo $t2
    sudo apt update -y
    clear

    dial " * Docker-compose  est installé avec la version $(docker-compose -v)."
fi
