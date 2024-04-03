#!/bin/bash
# Inclure le fichier de fonctions
source "$FUNCTIONS_FILE"

num="${1:-1000}"
title="Installation"
num_inst=0

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
    pause p c
}

if [[ "$num" == "1" ]]; then
    sudo apt update -y
    sudo apt -y install curl
fi

if [[ "$num" == "1" ]]; then
    # Installation des paquets avec notification
    install_notification "refresh" "f"
    sudo snap refresh

    install_notification "refresh snap-store" "f"
    sudo snap refresh snap-store
    # Définir les applications à installer avec leur nom et la commande d'installation

    applications=(
        "notepad-plus-plus notepad-plus-plus"
    )
else
    if [[ "$num" == "2" ]]; then
        applications=(
            "git-ubuntu git-ubuntu --classic"
            "docker docker"
        )
    else
        applications=(
            "code code --classic"
            "android-studio android-studio --classic"
            "eclipse eclipse --classic"
            "shotcut shotcut --classic"
            "office365webdesktop office365webdesktop --beta "
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
            "pygpt pygpt"
            "wps-office-multilang wps-office-multilang"
            "notion-snap-reborn notion-snap-reborn"
        )
    fi
fi

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
        sudo snap install $install_cmd |
            zenity --progress \
                --title="$title" \
                --text="$app_name" \
                --auto-close \
                --no-cancel \
                --width=420

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

# -----------------------------
# APT
# -----------------------------
if [[ "$num" == "1" ]]; then
    applications=(
        "xclip xclip"
        "wget wget"
        "git git"
        "xmlstarlet xmlstarlet"
        "google-chrome google-chrome-stable"
    )
else
    if [[ "$num" == "2" ]]; then
        applications=(
            ""
        )
    else
        applications=(
            "teamviewer teamviewer"
            "filezilla filezilla"
            "diodon diodon"
            "gparted gparted"
            "emoji-picker ibus-table-emoji"
            "php php8.1"
            "net-tools net-tools"

        )
    fi
fi
for app_cmd in "${applications[@]}"; do
    read -r app_name install_cmd <<<"$app_cmd"
    # install_notification "$app_name"
    if dpkg-query -l $install_cmd >/dev/null 2>&1; then
        install_notification " * L'application '$app_name' est déjà installé." "f"
    else
        num_inst=1
        sudo apt -y install $install_cmd |
            zenity --progress \
                --title="$title" \
                --text="$app_name" \
                --auto-close \
                --no-cancel \
                --width=420

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

# -----------------------------
# WGET
# -----------------------------

if [[ "$num" == "1" ]]; then
    applications=(
        ""
    )
else
    if [[ "$num" == "2" ]]; then
        applications=(
            "docker-desktop $dl_docker"
            "github-desktop $dl_github"
        )
    else
        applications=(
            " "
        )
    fi
fi
for app_cmd in "${applications[@]}"; do
    read -r app_name install_cmd <<<"$app_cmd"

    install_notification "$app_name"

    if dpkg-query -l $app_name >/dev/null 2>&1; then
        install_notification " * L'application '$app_name' est déjà installé." "f"
    else
        num_inst=1
        WGET -O $app_name.deb $install_cmd

        sudo apt-get -y install $functions_directory/$app_name.deb | zenity --progress \
            --title="$title" \
            --text="$app_name" \
            --percentage=0 \
            --no-cancel \
            --auto-close \
            --width=420

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

if [[ "$num" == "1000" ]]; then
    install_notification "execution de 'autoremove'" "f"
    sudo apt autoremove -y
    return_code=$?
    if [[ $return_code -eq 0 ]]; then
        dial " ** 'Autoremove' OK"
    else
        dial " ** Erreur de 'autoremove' : $result" "-"
    fi
    pause p c

    install_notification "execution de 'update'" "f"
    sudo apt update -y
    return_code=$?
    if [[ $return_code -eq 0 ]]; then
        dial " ** 'Mise à jour' OK"
    else
        dial " ** Erreur de 'mise à jour' : $result" "-"
    fi
    pause p c

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
else
    if [[ "num_inst" == "0" ]]; then
        sudo apt update -y
        return_code=$?
        if [[ $return_code -eq 0 ]]; then
            dial " ** 'Mise à jour' OK"
        else
            dial " ** Erreur de 'mise à jour' : $result" "-"
        fi
    fi
fi

pause p c

if [[ "$num" == "1" ]]; then
    if dpkg-query -l google-chrome-stable >/dev/null 2>&1; then
        if zenity --question --title=$title --text="Veux tu ouvrir google chrome pour te connecter ?"; then
            URL "https://www.google.fr"
        fi
    fi
fi
