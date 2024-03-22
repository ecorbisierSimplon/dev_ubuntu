# https://doc.ubuntu-fr.org/wine

sudo dpkg --add-architecture i386 

sudo mkdir -pm755 /etc/apt/keyrings

sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -sc)/winehq-$(lsb_release -sc).sources

sudo apt update

sudo apt install --install-recommends winehq-stable

# Configuration de wine
winecfg