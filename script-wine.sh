# https://doc.ubuntu-fr.org/wine
if dpkg-query -l winehq-stable >/dev/null 2>&1; then
    echo " * Wine"
    echo "     est déjà installé avec la version $(wine --version)."
else

    sudo dpkg --add-architecture i386
    sudo mkdir -pm755 /etc/apt/keyrings
    sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -sc)/winehq-$(lsb_release -sc).sources
    sudo apt update
    sudo apt -y install --install-recommends winehq-stable
    winecfg
fi

# Configuration de wine
