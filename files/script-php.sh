#!/bin/bash
# Inclure le fichier de fonctions
source "$FUNCTIONS_FILE"

version_new=8.3
version_old=8.1

dial " * Installation de  la version ${version_new}." "-"

## Save existing php package list to packages.txt file
sudo dpkg -l | grep php | tee packages.txt

# Add Ondrej's PPA
sudo add-apt-repository ppa:ondrej/php # Press enter when prompted.
sudo apt update

# Install new PHP ${version_new} packages
sudo apt install php${version_new} php${version_new}-cli php${version_new}-{bz2,curl,mbstring,intl}

# Install FPM OR Apache module
sudo apt install php${version_new}-fpm
# OR
# sudo apt install libapache2-mod-php${version_old}

# On Apache: Enable PHP ${version_new} FPM
sudo a2enconf php${version_new}-fpm
# When upgrading from an older PHP version:
sudo a2disconf php${version_old}-fpm

## Remove old packages
sudo apt purge php${version_old}*

pause s 5
