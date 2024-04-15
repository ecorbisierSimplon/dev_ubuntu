#!/bin/bash
source $FUNCTIONS_FILE
source ~/.bashrc 
source ~/.bash_aliases

echo ""
echo "======================================================"
echo "                 NUM : 'CHROME'"
echo "======================================================"
echo ""

if dpkg-query -l google-chrome-stable >/dev/null 2>&1; then
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
version_old=8.2

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

echo ""
echo "======================================================"
echo "                 NUM : 'WINE'"
echo "======================================================"
echo ""

# https://doc.ubuntu-fr.org/wine
if dpkg-query -l winehq-stable >/dev/null 2>&1; then
    dial " * Wine est déjà installé avec la version $(wine --version)."
else

    sudo dpkg --add-architecture i386

    folder=/etc/apt/keyrings
    sudo chown $user -R $folder
    sudo rm -r $folder
    sudo rm /etc/apt/sources.list.d/winehq-jammy.sources
    #if [[ ! -d "$folder" ]]; then
    sudo mkdir -pm755 $folder
    #fi
    user=$USER
    sudo wget -O $folder/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    sudo chown $user -R $folder
    echo
    echo "https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -sc)/winehq-$(lsb_release -sc).sources"
    echo
    sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -sc)/winehq-$(lsb_release -sc).sources
    pause s 1
    sudo apt update
    sudo apt -y install --install-recommends winehq-stable
    dial " * Wine\n     est installé avec la version $(wine --version)."
    pause s 5

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

echo ""
echo "======================================================"
echo "                 NUM : 'NODE JS'"
echo "======================================================"
echo ""

version_nodejs=21
# Récupérer la version de Node.js
version=$(node -v)

# Extraire la partie numérique de la version (en supposant que la version est sous le format 'vX.Y.Z')
 # Supprimer le préfixe 'v'
version_number=${version#v}          
# Supprimer les points de la version et la stocker comme entier
version_integer=$(echo "$version_number" | cut -d '.' -f 1)

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
    # Charger les modifications du fichier .bashrc dans l'environnement actuel
    pause s 1 
    source ~/.bashrc 
    source ~/.bash_aliases
    pause s 1
    # Installation de Node.js version 21
    nvm install $version_nodejs

    # Afficher la version actuelle de Node.js
    dial " * Node.js\n     est déjà installé avec la version $(node -v)"
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
