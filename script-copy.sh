#!/bin/bash
# Inclure le fichier de fonctions
functions_file="$1"
source "$functions_file"

if dpkg-query -l xmlstarlet >/dev/null 2>&1; then
    dial " * xmlstarlet\n     est déjà installé avec la version $(xmlstarlet --version)."
else
    sudo apt update
    sudo apt -y install xmlstarlet
fi

dial " Création du fichier .gitconfig :"
echo
# Copier les fichiers dans le répertoire personnel de l'utilisateur
cp ./layout/.bashrc $HOME/
cp ./layout/.gitconfig $HOME/

#On crée le formulaire en stockant les valeurs de sortie dans $cfgpass :/
while true; do
    RESULT= zenity --forms --title="Ajout d'un ami" \
        --text="Saisissez les informations concernant votre ami." \
        --separator="|" \
        --add-entry="Prénom" \
        --add-entry="Nom" \
        --add-entry="Courriel"
    return=$?
    echo "test  : ${RESULT}"
    dial "${RESULT}"
    dial $return
    if [ "$return" != "2" ]; then
        break
    else
        exit
    fi
    # case $return in
    # 0)
    #     break
    #     ;;
    # 1)
    #     dial "Aucun compte ajouté."
    #     break
    #     ;;
    # -1)
    #     dial "Une erreur inattendue est survenue."
    #     ;;
    # esac
done
echo "${RESULT}"
name= "${RESULT}" | cut -d "|" -f1     #Nom de l'utilisateur
lastname= "${RESULT}" | cut -d "|" -f2 #Nom de l'utilisateur
email= "${RESULT}" | cut -d "|" -f3    #Nom de l'utilisateur

dial $name
dial $lastname
dial $email

# while true; do
#     while true; do
#         echo "Quel est le nom de votre compte Github ?"
#         read nom

#         if is_valid_name "$nom"; then
#             break # Sortir de la boucle si l'email est valide
#         else
#             echo_bold_color "Le nom '$nom' n'est pas valide. Veuillez saisir un nom valide." "red" "y"
#         fi
#     done

#     # URL à vérifier
#     url="https://github.com/$nom/"

#     # Vérifier si l'URL existe en envoyant une requête HEAD avec curl
#     response=$(curl -s --head -w "%{http_code}" "$url" -o /dev/null)

#     # Vérifier le code de réponse HTTP
#     if [ "$response" == "200" ]; then
#         break
#     else
#         echo_bold_color "L'URL '$url' n'existe pas ou est inaccessible. Veuillez saisir un nom valide." "red" y
#     fi
# done
# echo
# echo_bold_color " * URL Github :" "" "y"
# echo_bold_color "      $url" "blue"

# # La requête avec curl pour récupérer le contenu de la page web
# html_content=$(curl -s "$url")

# # Extraire la ligne contenant le texte souhaité à l'aide de grep
# span_content=$(echo "$html_content" | awk -v RS='<span class="p-name vcard-fullname d-block overflow-hidden" itemprop="name">' 'NR>1{sub(/<.*>/,""); print; exit}')

# name_user=$(echo "$span_content" | sed 's/^[ \t]*//;s/[ \t]*$//')
# # Afficher le nom extrait
# echo
# echo_bold_color " * Votre nom utilisateur est" "" "y"
# echo_bold_color "            $name_user" "blue"
# echo "_____________"
# echo
# while true; do
#     echo "Quel est votre prénom ?"
#     read prenom
#     prenom=$(echo "$prenom" | sed 's/.*/\L\u&/')
#     if is_valid_name "$prenom"; then
#         break # Sortir de la boucle si l'email est valide
#     else
#         echo_bold_color "Le prénom '$prenom' n'est pas valide. Veuillez saisir un prénom valide." "red" "y"
#     fi
# done
# echo
# echo_bold_color " * Ton prénom : $prenom" "blue"
# echo "_____________"
# echo
# # Demander à l'utilisateur de saisir un email jusqu'à ce qu'un email valide soit fourni

# while true; do
#     echo "Quel est votre email Github ?"
#     read email

#     if is_valid_email "$email"; then
#         break # Sortir de la boucle si l'email est valide
#     else
#         echo_bold_color "L'email '$email' n'est pas valide. Veuillez saisir un email valide." "red" "y"
#     fi
# done

# echo
# echo_bold_color " email : $email" "blue"
# echo "_____________"

# # Utilisation de sed pour remplacer les placeholders par les valeurs saisies par l'utilisateur
# sed -i "s/<lastname>/$nom/g" $HOME/.gitconfig
# sed -i "s/<firstname>/$prenom/g" $HOME/.gitconfig
# sed -i "s/<email>/$email/g" $HOME/.gitconfig

# echo
# echo_bold_color " -- Merci ;)" "green"
# echo
# echo_bold_color "Les fichiers .bashrc et .gitconfig sont paramétrés." "yellow"
# echo
