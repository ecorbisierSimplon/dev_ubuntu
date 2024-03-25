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

if dpkg-query -l xmlstarlet >/dev/null 2>&1; then
    echo " * xmlstarlet"
    echo "     est déjà installé avec la version $(xmlstarlet --version)."
    echo "______________________"
    echo
else
    sudo apt update
    sudo apt -y install xmlstarlet
fi

echo_bold_color " Création du fichier .gitconfig :" "" "" "" "" "y"
echo
# Copier les fichiers dans le répertoire personnel de l'utilisateur
cp ./layout/.bashrc $HOME/
cp ./layout/.gitconfig $HOME/
while true; do
    while true; do
        echo "Quel est le nom de votre compte Github ?"
        read nom

        if is_valid_name "$nom"; then
            break # Sortir de la boucle si l'email est valide
        else
            echo_bold_color "Le nom '$nom' n'est pas valide. Veuillez saisir un nom valide." "red" "y"
        fi
    done

    # URL à vérifier
    url="https://github.com/$nom/"

    # Vérifier si l'URL existe en envoyant une requête HEAD avec curl
    response=$(curl -s --head -w "%{http_code}" "$url" -o /dev/null)

    # Vérifier le code de réponse HTTP
    if [ "$response" == "200" ]; then
        break
    else
        echo_bold_color "L'URL '$url' n'existe pas ou est inaccessible. Veuillez saisir un nom valide." "red" y
    fi
done
echo
echo_bold_color " * URL Github :" "" "y"
echo_bold_color "      $url" "blue"

# La requête avec curl pour récupérer le contenu de la page web
html_content=$(curl -s "$url")

# Extraire la ligne contenant le texte souhaité à l'aide de grep
span_content=$(echo "$html_content" | awk -v RS='<span class="p-name vcard-fullname d-block overflow-hidden" itemprop="name">' 'NR>1{sub(/<.*>/,""); print; exit}')

name_user=$(echo "$span_content" | sed 's/^[ \t]*//;s/[ \t]*$//')
# Afficher le nom extrait
echo
echo_bold_color " * Votre nom utilisateur est" "" "y"
echo_bold_color "            $name_user" "blue"
echo "_____________"
echo
while true; do
    echo "Quel est votre prénom ?"
    read prenom
    prenom=$(echo "$prenom" | sed 's/.*/\L\u&/')
    if is_valid_name "$prenom"; then
        break # Sortir de la boucle si l'email est valide
    else
        echo_bold_color "Le prénom '$prenom' n'est pas valide. Veuillez saisir un prénom valide." "red" "y"
    fi
done
echo
echo_bold_color " * Ton prénom : $prenom" "blue"
echo "_____________"
echo
# Demander à l'utilisateur de saisir un email jusqu'à ce qu'un email valide soit fourni

while true; do
    echo "Quel est votre email Github ?"
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

# Utilisation de sed pour remplacer les placeholders par les valeurs saisies par l'utilisateur
sed -i "s/<lastname>/$nom/g" $HOME/.gitconfig
sed -i "s/<firstname>/$prenom/g" $HOME/.gitconfig
sed -i "s/<email>/$email/g" $HOME/.gitconfig

echo
echo_bold_color " -- Merci ;)" "green"
echo
echo_bold_color "Les fichiers .bashrc et .gitconfig sont paramétrés." "yellow"
echo
