#!/bin/bash
source $FUNCTIONS_FILE
source ~/.bashrc
source ~/.bash_aliases

title="Installation"
num_inst=0
echo ""
echo "======================================================"
echo "                  '$(basename "$0")'"
echo "======================================================"
echo ""
echo ""

# Fonction pour afficher une notification d'installation de paquet
install_notification() {
    local package_name="$1"
    local instal="${2:-true}"
    local underline="${3:-false}"
    if [[ "$instal" == "true" ]]; then
        dial "Installation du paquet '$package_name' en cours..." "$underline" "" ""
    else
        dial "$package_name" "$underline" "" ""
    fi
    pause p
}

echo ""
echo "======================================================"
echo "                 SNAP REFRESH"
echo "======================================================"
echo ""
applications=("")
# Installation des paquets avec notification
install_notification "refresh" "f"
sudo snap refresh

install_notification "refresh snap-store" "f"
sudo snap refresh snap-store
# Définir les applications à installer avec leur nom et la commande d'installation

applications=(
    "notepad-plus-plus notepad-plus-plus"
    "git-ubuntu git-ubuntu --classic"
    "docker docker"
    "code code --classic"
    "android-studio android-studio --classic"
    "eclipse eclipse --classic"
    "shotcut shotcut --classic"
    "office365webdesktop office365webdesktop --beta "
    "gimp gimp"
    "discord discord"
    "postman postman"
    "insomnia insomnia"
    "zoom-client zoom-client"
    "audacity audacity"
    "inkscape inkscape"
    "kcolorchooser kcolorchooser"
    "whatsapp-linux-app whatsapp-linux-app"
    "dbeaver dbeaver-ce"
    "notepad-plus-plus notepad-plus-plus"
    "termius-app termius-app"
    "gnome-calendar gnome-calendar"
    "wps-office-multilang wps-office-multilang"
    "notion-snap-reborn notion-snap-reborn"
)

# Parcourir la liste des applications et les installer
# -----------------------------
# SNAP
# -----------------------------
for app_cmd in "${applications[@]}"; do
    read -r app_name install_cmd <<<"$app_cmd"
    # install_notification "$app_name"
    if dpkg-query -l $install_cmd >/dev/null 2>&1; then
        install_notification " * L'application '$app_name' est déjà installé." "f"
    else
        num_inst=1
        sudo snap install $install_cmd

        # Récupérer le code de retour
        return_code=$?
        # echo $return_code
        # Vérifier le code de retour
        if [[ $return_code -eq 0 ]]; then
            install_notification "L'installation de '$app_name' s'est terminée avec succès." "f"
        # install_notification "'$app_name' est installé avec la version $($app_name --version)." "f" "-"
        elif [[ $return_code -eq 5 ]]; then
            install_notification " * L'application '$app_name' est déjà installé." "f"

        else
            install_notification "Une erreur s'est produite lors de l'installation de '$app_name'. Code de retour : $return_code" "f" "-"

        fi
    fi
done

# -----------------------------
# APT
# -----------------------------
applications=("")

applications=(
    "xclip xclip"
    "wget wget"
    "git git"
    "xmlstarlet xmlstarlet"
    "filezilla filezilla"
    "diodon diodon"
    "gparted gparted"
    "emoji-picker ibus-table-emoji"
    "net-tools net-tools"
    "composer composer"

)

for app_cmd in "${applications[@]}"; do
    read -r app_name install_cmd <<<"$app_cmd"
    # install_notification "$app_name"
    if dpkg-query -l $install_cmd >/dev/null 2>&1; then
        install_notification " * L'application '$app_name' est déjà installé." "f"
    else
        num_inst=1
        install_notification " * '$app_name' en cours d'installation" "f"
        sudo apt -y install $install_cmd

        # Récupérer le code de retour
        return_code=$?
        # echo $return_code
        # Vérifier le code de retour
        if [[ $return_code -eq 0 ]]; then
            install_notification "L'installation de '$app_name' s'est terminée avec succès." "f"
        # install_notification "'$app_name' est installé avec la version $($app_name --version)." "f" "-"
        elif [[ $return_code -eq 5 ]]; then
            install_notification " * L'application '$app_name' est déjà installé." "f"

        else
            install_notification "Une erreur s'est produite lors de l'installation de '$app_name'. Code de retour : $return_code" "f" "-"

        fi
    fi
done

# -----------------------------
# WGET
# -----------------------------
applications=("")

applications=(
    "docker-desktop-amd64 $dl_docker"
    "github-desktop $dl_github"
    "teamviewer $dl_teamviewer"
)

for app_cmd in "${applications[@]}"; do
    read -r app_name install_cmd <<<"$app_cmd"

    install_notification "$app_name"
    folder_down=~/Téléchargements
    if dpkg-query -l $app_name >/dev/null 2>&1; then
        install_notification " * L'application '$app_name' est déjà installé." "f"
    else
        num_inst=1
        echo $dl_github
        WGET -O "${folder_down}/${app_name}.deb" $install_cmd
        pause s 5
        sudo apt-get -y install "${folder_down}/${app_name}.deb"

        # Récupérer le code de retour
        return_code=$?
        # echo $return_code
        # Vérifier le code de retour
        if [[ $return_code -eq 0 ]]; then
            install_notification "L'installation de '$app_name' s'est terminée avec succès." "f"
        # install_notification "'$app_name' est installé avec la version $($app_name --version)." "f" "-"
        else
            if [[ $return_code -eq 5 ]]; then
                install_notification " * L'application '$app_name' est déjà installé." "f"

            else
                install_notification "Une erreur s'est produite lors de l'installation de '$app_name'. Code de retour : $return_code" "f" "-"
            fi
        fi
    fi
done
applications=("")

echo "                 NUM : '$num_parameter'"
echo "======================================================"
install_notification "execution de 'autoremove'" "f"
sudo apt autoremove -y
return_code=$?
if [[ $return_code -eq 0 ]]; then
    dial " ** 'Autoremove' OK"
else
    dial " ** Erreur de 'autoremove' : $result" "-"
fi
pause p

install_notification "execution de 'update'" "f"
sudo apt update -y
return_code=$?
if [[ $return_code -eq 0 ]]; then
    dial " ** 'Mise à jour' OK"
else
    dial " ** Erreur de 'mise à jour' : $result" "-"
fi
pause p

install_notification "execution de 'upgrade'" "f"
sudo apt full-upgrade -y
return_code=$?
if [[ $return_code -eq 0 ]]; then
    dial " ** 'Upgrade' OK"
else
    dial " ** Erreur de 'upgrade' : $result" "-"
fi

install_notification "execution de 'snap refresh'" "f"
sudo snap refresh
return_code=$?
if [[ $return_code -eq 0 ]]; then
    dial " ** 'Refresh' OK"
else
    dial " ** Erreur de 'refresh' : $result" "-"
fi

sudo apt update -y
return_code=$?
if [[ $return_code -eq 0 ]]; then
    dial " ** 'Mise à jour' OK"
else
    dial " ** Erreur de 'mise à jour' : $result" "-"
fi

pause s 1

echo "                 CHROME : '$num_parameter'"
echo "======================================================"
if dpkg-query -l google-chrome-stable >/dev/null 2>&1; then
    if zenity --question --title=$title --text="Veux tu ouvrir google chrome pour te connecter ?"; then
        echo "Fermer le navigateur pour poursuivre ...."
        URL "https://www.google.fr"
    fi
fi
