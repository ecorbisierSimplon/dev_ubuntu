#!/bin/bash
source $FUNCTIONS_FILE
source ~/.bashrc
source ~/.bash_aliases
echo ""
echo "======================================================"
echo "                  '$(basename "$0")'"
echo "======================================================"
echo ""
echo ""
echo "======================================================"
echo "                 NUM : 'CHROME'"
echo "======================================================"
echo ""

if dpkg-query -l google-chrome-stable; then
    dial " * L'application 'Google Chrome' est déjà installé." "f"
else
    sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
    wget -O- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/linux_signing_key.pub
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 78BD65473CB3BD13
    sudo apt-get update
    sudo apt-key export D38B4796 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/chrome.gpg
    sudo apt-get install google-chrome-stable
    dial " * L'application 'Google Chrome' est installé." "f"

fi

echo ""
echo "======================================================"
echo "                 NUM : 'PHP'"
echo "======================================================"
echo ""

version_new=8.3
version_old=7.0
increment=0.1

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

    # Convertir la version en nombre à virgule flottante
    version_float=$(echo "$version_new" | awk -F '.' '{printf "%.1f\n", $1 + $2}')

    # Déterminer le nombre d'itérations nécessaires
    iterations=$(echo "($version_float - $version_old) / $increment" | bc)

    # Parcourir la boucle
    for ((i = 0; i <= iterations; i++)); do
        # Calculer la version actuelle
        current_version=$(echo "7.0 + $i * $increment" | bc)
        ## Remove old packages
        sudo apt purge php${current_version}*
    done

fi
pause s 2

echo ""
echo "======================================================"
echo "                 NUM : 'WINE'"
echo "======================================================"
echo ""

# https://doc.ubuntu-fr.org/wine
if dpkg-query -l wine; then
    dial " * Wine est déjà installé avec la version $(wine --version)."
else
    user=$USER
    sudo rm -r /home/$user/.wine
    # sudo dpkg --add-architecture i386

    # folder=/etc/apt/keyrings
    # sudo chown $user -R $folder
    # sudo rm -r $folder
    # sudo rm /etc/apt/sources.list.d/winehq-jammy.sources
    #if [[ ! -d "$folder" ]]; then
    # sudo mkdir -pm755 $folder
    #fi
    # sudo wget -O $folder/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    # sudo chown $user -R $folder
    # echo
    # echo "https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -sc)/winehq-$(lsb_release -sc).sources"
    # echo
    # sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -sc)/winehq-$(lsb_release -sc).sources
    pause s 1
    sudo apt update
    pause s 1

    #sudo apt -y install $FUNCTIONS_DIRECTORY/layout/libgd3_2.3.3-6+ubuntu22.04.1+deb.sury.org+1_i386.deb
    pause s 1
    # sudo apt install libgd3:i386=2.3.0-2ubuntu2
    # sudo apt install libgd3=2.3.0-2ubuntu2
    # sudo apt -y install --install-recommends winehq-stable
    sudo apt -y install wine
    pause s 1

    # sudo apt -y install --install-recommends wine64
    if dpkg-query -l wine; then

        dial " * Wine\n     est installé avec la version $(wine --version)."
        pause s 2

        if zenity --question \
            --text="Voulez-vous ouvrir les paramètres de Wine ?"; then
            winecfg
            pause s 2
        else
            dial "Vous pourrez configurer Wine avec la commande > winecfg"
            pause s 2
        fi
    else
        dial "WINE NE S'EST PAS INSTALLÉ !!!"
    fi
fi

# Configuration de wine

echo ""
echo "======================================================"
echo "                 NUM : 'NODE JS'"
echo "======================================================"
echo ""

version_nodejs=21
# Récupérer la version de Node.js

version=$(node -v)
echo $version
# Extraire la partie numérique de la version (en supposant que la version est sous le format 'vX.Y.Z')
# Supprimer le préfixe 'v'
version_number=${version#v}
echo $version_number

# Supprimer les points de la version et la stocker comme entier
version_integer=$(echo "$version_number" | cut -d '.' -f 1)
echo $version_integer

echo "$version_integer -ge $version_nodejs"
# Vérifier si la version de Node.js est supérieure ou égale à 21
if [ "$version_integer" -ge "$version_nodejs" ]; then
    dial " * Node.js  est déjà installé avec la version $version_number."
else
    # Mise à jour des dépôts et installation de Node.js
    sudo apt update
    # installs NVM (Node Version Manager)
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    file_b_m=~/.bashrc
    file_a_m=~/.bash_aliases
    source $file_b_m
    source $file_a_m
    
    # download and install Node.js
    nvm install 21
    # verifies the right Node.js version is in the environment
    node -v # should print `v21.7.3`
    # verifies the right NPM version is in the environment
    npm -v # should print `10.5.0`
    # Afficher la version actuelle de Node.js
    dial " * Node.js est déjà installé avec la version $(node -v)"
fi

echo ""
echo "======================================================"
echo "                 NUM : 'JAVA'"
echo "======================================================"
echo ""

java_version=17

# Exécuter la commande java --version et stocker la sortie dans la variable "java_version"
version_java=$(java --version 2>&1 | head -n 1)

# Extraire uniquement le numéro de version
version_number=$(echo "$version_java" | grep -oP '\d+\.\d+\.\d+')

# Supprimer les points de la version et la stocker comme entier
version_integer=$(echo "$version_number" | cut -d '.' -f 1)

# Vérifier si la version de Node.js est supérieure ou égale à 21
if [[ "$version_integer" -ge "$java_version" ]]; then
    dial " * Java\n     est déjà installé avec la version $version_number."
else
    sudo apt update
    sudo apt-get install openjdk-17-jdk -y
    dial " * Java\n     est installé avec la version  $(java --version 2>&1 | head -n 1)"
fi
