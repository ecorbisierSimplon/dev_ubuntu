# Inclure le fichier de fonctions

# Rechercher le fichier de fonctions avec locate
functions_file=$(locate functions.sh)

# Vérifier si le fichier de fonctions a été trouvé
if [ -z "$functions_file" ]; then
    echo "Le fichier de fonctions n'a pas été trouvé."
    exit 1
fi

# Inclure le fichier de fonctions
source "$functions_file"

echo_bold_color "Veux tu générer la clé Github ? ?" "" "y" "" "y"
echo "[y]es / [n]o : "
read respons
if [ "$respons" = "y" ]; then
    while true; do

        while true; do
            echo "Quel sera le unique du dépot (perso, entreprise ...): ?"
            read name_unic
            name_unic=$(echo "$name_unic" | sed 's/.*/\L\u&/')
            if is_valid_name "$name_unic"; then
                break # Sortir de la boucle si l'email est valide
            else
                echo_bold_color "Le nom de dépot '$name_unic' n'est pas valide. Veuillez saisir un nom de dépot valide." "red" "y"
            fi
        done
        echo
        echo_bold_color " * Ton nom de dépot : $name_unic" "blue"
        echo "_____________"
        echo

        while true; do
            echo "Quel est l'email de ce compte Github ?"
            read email

            if is_valid_email "$email"; then
                break # Sortir de la boucle si l'email est valide
            else
                echo_bold_color "L'email '$email' n'est pas valide. Veuillez saisir un email valide." "red" "y"
            fi
        done

        echo
        echo_bold_color " email : $email" "blue"
        echo "_____________"

        # Remplacer les espaces par des tirets
        name_space=$(echo "$name_unic" | tr '[:space:]' '-')

        # Convertir en minuscules
        name_space=$(echo "$name_space" | tr '[:upper:]' '[:lower:]')

        echo "_____________"
        echo
        echo_bold_color "Le repertoire et le fichier de la clé est ~/.ssh/$name_space par defaut" "" "y"
        echo "_____________"
        echo

        ssh-keygen -t ed25519 -C "$email"
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/$name_space
        cat ~/.ssh/$name_space.pub

        echo "# $name_unic account" >>~/.ssh/config
        echo "Host github.com-$name_space" >>~/.ssh/config
        echo "	HostName github.com" >>~/.ssh/config
        echo "	PreferredAuthentications publickey" >>~/.ssh/config
        echo "	User git" >>~/.ssh/config
        echo "	IdentityFile ~/.ssh/$name_space" >>~/.ssh/config
        echo "" >>~/.ssh/config

        echo
        echo "Veux tu créer une clé pour un autre dépot Github ?"
        echo "[y]es / [n]o : "
        read respons
        if [ "$respons" = "n" ]; then
            break
        fi

    done
fi
