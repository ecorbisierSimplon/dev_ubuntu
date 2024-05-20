#!/bin/bash
shopt -s expand_aliases
source $HOME/.bashrc
source $HOME/.bash_aliases
alias welcome='echo "Welcome to the tutorial!"'
hr
# parameters() {
#     num=${1:-5}
#     # Vous pouvez générer les valeurs directement dans la fonction
#     # et retourner chaque paire "nom_de_l'application commande_d'installation" sur une nouvelle ligne
#     for ((i = 0; i < $num; i++)); do
#         echo "key_$i|value_$i"
#     done
# }

# test() {
#     # Déclarer un tableau pour stocker les valeurs
#     declare -a tab
#     # Appeler la fonction parameters avec un argument différent et stocker les valeurs dans le tableau tab
#     tab=($(parameters))
#     # Afficher le tableau
#     for app_cmd in "${tab[@]}"; do
#         # Utilisez un délimiteur pour séparer les valeurs
#         IFS='|' read -r app_name install_cmd <<<"$app_cmd"
#         echo "clé: $app_name -- valeur: $install_cmd"
#     done
# }

# test

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

# exit 1
