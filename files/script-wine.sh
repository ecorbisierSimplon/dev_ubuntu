#!/bin/bash
# Inclure le fichier de fonctions
source "$FUNCTIONS_FILE"

# https://doc.ubuntu-fr.org/wine
if dpkg-query -l winehq-stable >/dev/null 2>&1; then
    dial " * Wine est déjà installé avec la version $(wine --version)."
else

    sudo dpkg --add-architecture i386

    folder=/etc/apt/keyrings
    if [[ ! -d "$folder" ]]; then
        sudo mkdir -pm755 $folder
    fi
    sudo wget -O $folder/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -sc)/winehq-$(lsb_release -sc).sources
    sudo apt update
    sudo apt -y install --install-recommends winehq-stable
    dial " * Wine\n     est installé avec la version $(wine --version)."
    sleep 3

    if zenity --question \
        --text="Voulez-vous ouvrir les paramètres de Wine ?"; then
        winecfg
        sleep 3
    else
        dial "Vous pourrez configurer Wine avec la commande > winecfg"
        sleep 3
    fi

fi

# Configuration de wine
