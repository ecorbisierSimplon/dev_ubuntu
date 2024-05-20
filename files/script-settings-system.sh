#!/bin/bash
source $FUNCTIONS_FILE
source ~/.bashrc
source ~/.bash_aliases

echo ""
echo "======================================================"
echo "                  '$(basename $0)'"
echo "======================================================"
echo ""

# Execut in terminal :
# chmod +x ./script-settings-system.sh && ./script-settings-system.sh

file_img=$FUNCTIONS_DIRECTORY/layout/img/trains/1715922647397.jpg
echo $file_img
home=~
file_img_pp="$home/Images/Papiers peints"
mkdir -p "$file_img_pp"
echo $file_img_pp
cp -v "$file_img" "$file_img_pp"
pause s 2

file_rel_settings=$FUNCTIONS_DIRECTORY/layout/settings.sh
echo $file_rel_settings
source $file_rel_settings
pause s 2

for app_cmd in "${tab[@]}"; do
    # Séparer le nom de l'application et la commande d'installation
    read -r app_name install_cmd <<<"$app_cmd"
    echo "***   $app_name   ***"

    # Diviser la commande d'installation en paires clé-valeur
    IFS='|' read -ra pairs <<<"$install_cmd"
    declare -A kv_array

    for pair in "${pairs[@]}"; do
        # Utiliser awk pour séparer la paire clé-valeur
        key=$(echo "$pair" | awk -F '::' '{print $1}')
        value=$(echo "$pair" | awk -F '::' '{print $2}')
        kv_array["$key"]="$(echo "$value" | sed 's/--%20--/ /g')"
    done

    # Afficher les paires clé-valeur
    for key in "${!kv_array[@]}"; do
        # Construire le chemin complet de la clé avec un slash
        full_key="/$app_name/$key"
        # Utiliser dconf write avec le chemin complet de la clé
        dconf write "$full_key" "${kv_array[$key]}"
    done
    unset kv_array

done

# DEMARAGE AUTOMATIQUE
