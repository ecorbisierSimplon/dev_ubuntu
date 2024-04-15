#!/bin/bash
# source $FUNCTIONS_FILE
source ~/.bashrc
source ~/.bash_aliases

echo ""
echo "======================================================"
echo "                 NUM : 'script settings save'"
echo "======================================================"
echo ""

# Execut in terminal :
# chmod +x ./script-settings-save.sh && ./script-settings-save.sh

file_rel_settings=~/Téléchargements/Download/dev_ubuntu/files/layout/settings.sh
source $file_rel_settings

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
        # echo "Clé: $key, Valeur: ${kv_array[$key]}"
        dconf write /$app_name/$key $kv_array[$key]
    done

    unset kv_array
    echo
done
