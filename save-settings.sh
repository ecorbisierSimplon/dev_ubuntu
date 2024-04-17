#!/bin/bash
parameters() {
    num=${1:-5}
    # Vous pouvez générer les valeurs directement dans la fonction
    # et retourner chaque paire "nom_de_l'application commande_d'installation" sur une nouvelle ligne
    for ((i = 0; i < $num; i++)); do
        echo "key_$i|value_$i"
    done
}

test() {
    # Déclarer un tableau pour stocker les valeurs
    declare -a tab
    # Appeler la fonction parameters avec un argument différent et stocker les valeurs dans le tableau tab
    tab=($(parameters))
    # Afficher le tableau
    for app_cmd in "${tab[@]}"; do
        # Utilisez un délimiteur pour séparer les valeurs
        IFS='|' read -r app_name install_cmd <<<"$app_cmd"
        echo "clé: $app_name -- valeur: $install_cmd"
    done
}

test

# Afficher le contenu de la variable, qui contient le tableau avec ses clés et valeurs

# parameters() {
#     declare -A tab
#     for ((i = 0; i < 5; i++)); do
#         tab["key_$i"]="value_$i"
#     done
#     # Retourner le tableau au lieu de le passer en tant qu'argument
#     echo "${tab[@]}"
# }

# Appeler la fonction parameters et stocker le résultat dans le tableau parameter
# parameter=($(parameters))
# echo $(parameters)
# # Parcourir les paires clé-valeur dans le tableau parameter
# for ((i = 0; i < ${#parameter[@]}; i += 2)); do
#     key="${parameter[i]}"
#     val="${parameter[i + 1]}"
#     echo "$key = $val"
# done

exit 1
file_rel_dump=./files/layout/dconf_dump-new.txt
dconf dump / >$file_rel_dump
sed -i "s/^virtual-root=.*/virtual-root='file:\/\/\/home\/${USER}_'/" $file_rel_dump
tableau=""
exit 1
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
done <./files/layout/dconf_dump.txt

# Fermer le dernier répertoire
tableau="$tableau\""

# Fermer le tableau
echo "tab=(
    $tableau
    )" >./files/layout/settings.sh
