#!/bin/bash

# Déclaration du tableau en shell
echo "tab=(" > settings.sh

# Lecture du fichier de configuration ligne par ligne
while IFS= read -r line; do
    # Si la ligne commence par "[", c'est le début d'un nouveau répertoire
    if [[ $line == [* ]]; then
        # Si ce n'est pas le premier répertoire, fermer le précédent
        if [ -n "$current_dir" ]; then
            echo ")," >> settings.sh
        fi
        # Extraire le nom du répertoire
        current_dir=$(echo "$line" | sed 's/\[//;s/\]//')
        # Écrire le début du répertoire dans le tableau
        echo "  \"$current_dir\" (" >> settings.sh
    else
        # Extraire le nom du paramètre et sa valeur
        parameter=$(echo "$line" | awk -F= '{print $1}')
        value=$(echo "$line" | awk -F= '{print $2}')
        if [[ $parameter != "" ]]; then
            # Écrire le paramètre et sa valeur dans le tableau
            echo "  \"$parameter\" \"$value\"," >> settings.sh
        fi
    fi
done < ./dconf_dump.txt

# Fermer le dernier répertoire
echo ")," >> settings.sh

# Fermer le tableau
echo ")" >> settings.sh

