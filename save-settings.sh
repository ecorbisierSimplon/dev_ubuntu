#!/bin/bash

file_rel_dump=./files/layout/dconf_dump-2024-05-20.txt
dconf dump / >$file_rel_dump
sed -i "s/^virtual-root=.*/virtual-root='file:\/\/\/home\/${USER}_'/" $file_rel_dump
tableau=""

num_setting=0
# Déclaration du tableau en shell
# echo "tab=(" >./files/layout/settings.sh
# Lecture du fichier de configuration ligne par ligne
while IFS= read -r line; do
    # Si la ligne commence par "[", c'est le début d'un nouveau répertoire
    if [[ $line == [* ]]; then
        # Si ce n'est pas le premier répertoire, fermer le précédent
        if [ -n "$current_dir" ]; then
            tableau="$tableau\"
            "
        fi
        # Extraire le nom du répertoire
        current_dir=$(echo "$line" | sed 's/\[//;s/\]//')
        # Écrire le début du répertoire dans le tableau
        tableau="$tableau\"$current_dir "
        num_setting=0
    else
        # Extraire le nom du paramètre et sa valeur
        parameter=$(echo "$line" | awk -F= '{print $1}')
        value=$(echo "$line" | awk -F= '{print $2}')
        if [[ $parameter != "" ]]; then

            ((num_setting = num_setting + 1))
            if [[ $num_setting > 1 ]]; then
                tableau="$tableau|"
            fi
            # Écrire le paramètre et sa valeur dans le tableau
            tableau="$tableau$parameter::$(echo "$value" | sed 's/ /--%20--/g')"
        fi
    fi
done <$file_rel_dump

# Fermer le dernier répertoire
tableau="$tableau\""

# Fermer le tableau
echo "tab=(
    $tableau
    )" >./files/layout/settings.sh
