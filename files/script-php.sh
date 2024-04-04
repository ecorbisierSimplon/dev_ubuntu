#!/bin/bash
# Inclure le fichier de fonctions
source "$FUNCTIONS_FILE"

version_new=8.3
version_old=8.1

dial " * Installation de php avec la version ${version_new}." "-"

php_version=$(php --version | head -n 1 | cut -d " " -f 2)

if [[ $php_version == "$version_new"* ]]; then
    dial "La version de PHP est $php_version. Elle est à jour."
else

    ## Save existing php package list to packages.txt file
    sudo dpkg -l | grep php | tee packages.txt

    # Add Ondrej's PPA
    sudo add-apt-repository ppa:ondrej/php # Press enter when prompted.
    sudo apt update -y

    # Install new PHP ${version_new} packages
    sudo apt install php${version_new} php${version_new}-cli php${version_new}-{bz2,curl,mbstring,intl} -y

    # Install FPM OR Apache module
    sudo apt install php${version_new}-fpm -y
    # OR
    # sudo apt install libapache2-mod-php${version_old}

    # On Apache: Enable PHP ${version_new} FPM
    sudo a2enconf php${version_new}-fpm -y
    # When upgrading from an older PHP version:
    sudo a2disconf php${version_old}-fpm -y

    ## Remove old packages
    sudo apt purge php${version_old}*

fi
pause s 5
