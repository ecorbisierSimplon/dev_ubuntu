#!/bin/bash
# Inclure le fichier de fonctions
functions_file="$1"
source $functions_file

# Fonction pour afficher une notification d'installation de paquet
install_notification() {
    local package_name="$1"
    local instal="${2:-true}"
    local underline="${3:-false}"
    if [ "$instal" = "true" ]; then
        dial "Installation du paquet '$package_name' en cours..." "$underline" "" ""
    else
        dial "$package_name" "$underline" "" ""
    fi
    clear
}

# Installation des paquets avec notification
install_notification "refresh" "f"
sudo snap refresh

install_notification "refresh snap-store" "f"
sudo snap refresh snap-store
# Définir les applications à installer avec leur nom et la commande d'installation
applications=(
    "code code --classic"
    "android-studio android-studio --classic"
    "git-ubuntu git-ubuntu --classic"
    "eclipse eclipse --classic"
    "shotcut shotcut --classic"
    "office365webdesktop --beta office365webdesktop"
    "gimp gimp"
    "discord discord"
    "postman postman"
    "zoom-client zoom-client"
    "audacity audacity"
    "inkscape inkscape"
    "kcolorchooser kcolorchooser"
    "whatsapp-linux-app whatsapp-linux-app"
    "beekeeper-studio beekeeper-studio"
    "notepad-plus-plus notepad-plus-plus"
    "termius-app termius-app"
    "gnome-calendar gnome-calendar"
    "onenote-desktop onenote-desktop"
    "pygpt pygpt"
    "wps-office-multilang wps-office-multilang"
    "docker docker"
    "notion-snap-reborn notion-snap-reborn"
)

# Fonction pour afficher une notification d'installation

# install_notification  "Installation de $1 en cours..."

# Parcourir la liste des applications et les installer
for app_cmd in "${applications[@]}"; do
    read -r app_name install_cmd <<<"$app_cmd"
    # install_notification "$app_name"
    if dpkg-query -l $install_cmd >/dev/null 2>&1; then
        install_notification " * L'application '$app_name' est déjà installé." "f"
    else
        eval "snap install $install_cmd" | zenity --progress \
            --title="Installation" \
            --text="$app_name" \
            --percentage=0 \
            --timeout=1 \
            --pulsate \
            --no-cancel \
            --width=420

        # Récupérer le code de retour
        return_code=$?
        # echo $return_code
        # Vérifier le code de retour
        if [ $return_code -eq 0 ]; then
            install_notification "L'installation de '$app_name' s'est terminée avec succès." "f"
        # install_notification "'$app_name' est installé avec la version $($app_name --version)." "f" "-"
        else
            if [ $return_code -eq 5 ]; then
                install_notification " * L'application '$app_name' est déjà installé." "f"

            else
                install_notification "Une erreur s'est produite lors de l'installation de '$app_name'. Code de retour : $return_code" "f" "-"
            fi
        fi
    fi
done

applications=(
    "docker-desktop docker-desktop"
    "github-desktop github-desktop"
    "google-chrome-stable google-chrome-stable"
    "teamviewer teamviewer"
    "filezilla filezilla"
    "diodon diodon"
    "gparted gparted"
    "emoji-picker ibus-table-emoji"
    "git git"
)
for app_cmd in "${applications[@]}"; do
    read -r app_name install_cmd <<<"$app_cmd"
    # install_notification "$app_name"
    if dpkg-query -l $install_cmd >/dev/null 2>&1; then
        install_notification " * L'application '$app_name' est déjà installé." "f"
    else
        eval "apt -y install  $install_cmd" | zenity --progress \
            --title="Installation" \
            --text="$app_name" \
            --percentage=0 \
            --timeout=2 \
            --pulsate \
            --no-cancel \
            --width=420

        # Récupérer le code de retour
        return_code=$?
        # echo $return_code
        # Vérifier le code de retour
        if [ $return_code -eq 0 ]; then
            install_notification "L'installation de '$app_name' s'est terminée avec succès." "f"
        # install_notification "'$app_name' est installé avec la version $($app_name --version)." "f" "-"
        else
            if [ $return_code -eq 5 ]; then
                install_notification " * L'application '$app_name' est déjà installé." "f"

            else
                install_notification "Une erreur s'est produite lors de l'installation de '$app_name'. Code de retour : $return_code" "f" "-"
            fi
        fi
    fi
done

install_notification "execution de 'autoremove'" "f"
sudo apt autoremove -y
return_code=$?
if [ $return_code -eq 0 ]; then
    dial " ** 'Autoremove' OK"
else
    dial " ** Erreur de 'autoremove' : $result" "-"
fi
clear

install_notification "execution de 'update'" "f"
sudo apt update -y
return_code=$?
if [ $return_code -eq 0 ]; then
    dial " ** 'Mise à jour' OK"
else
    dial " ** Erreur de 'mise à jour' : $result" "-"
fi
clear

install_notification "execution de 'upgrade'" "f"
sudo apt full-upgrade -y
return_code=$?
if [ $return_code -eq 0 ]; then
    dial " ** 'Upgrade' OK"
else
    dial " ** Erreur de 'upgrade' : $result" "-"
fi
clear

install_notification "execution de 'snap refresh'" "f"
sudo snap refresh
return_code=$?
if [ $return_code -eq 0 ]; then
    dial " ** 'Refresh' OK"
else
    dial " ** Erreur de 'refresh' : $result" "-"
fi
clear
