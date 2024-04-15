#!/bin/bash
source $FUNCTIONS_FILE
source ~/.bashrc
source ~/.bash_aliases

echo ""
echo "======================================================"
echo "                  '$(basename "$0")'"
echo "======================================================"
echo ""
t1=" script-docker.sh"
t2=" --------------------"
dial $t1
dial $t2
if dpkg-query -l docker-compose >/dev/null 2>&1; then

    dial " * Docker-compose est déjà installé avec la version $(docker-compose -v)."
    pause s 3
else

    # Installer Docker Compose
    sudo apt install docker-compose -y
    pause c s 1

    echo $t1
    echo $t2
    # Supprimer les anciennes versions de Docker
    sudo apt install docker.io docker-compose -y
    pause c s 1

    echo $t1
    echo $t2
    # Mettre à jour à nouveau la liste des paquets
    sudo apt update -y
    pause c s 1

    echo $t1
    echo $t2
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    pause c s 1

    echo $t1
    echo $t2
    # Ajouter la clé GPG du site de Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    pause c s 1

    echo $t1
    echo $t2
    # Configurer le référentiel stable de Docker :
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    pause c s 1

    echo $t1
    echo $t2
    # Installer Docker Engine :
    sudo apt update -y
    pause c s 1

    echo $t1
    echo $t2
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    pause c s 1

    # Installer Docker Compose
    sudo apt install docker-compose -y
    pause c s 1

    echo $t1
    echo $t2
    sudo apt update -y
    pause c s 1

    dial " * Docker-compose  est installé avec la version $(docker-compose -v)."
fi
