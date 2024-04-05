#!/bin/bash
# Inclure le fichier de fonctions
source "$FUNCTIONS_FILE"
echo $name_github

# Récupération du dossier personnel
home=~
pause c s 1
dial " script-copy.sh"
dial " --------------"
dial " * curl est installé avec la version $(curl --version)."
dial " Création du fichier .gitconfig :"

title="Add setting account Github"
text=""
name_github=""
email_github=""
lastename=""

error="L'ajout du compte Github va être stoppé ! <span color=\"red\">Veux tu stopper le processus ?</span>"
error_input="<b>\nest <span color=\"red\">non valide !</span></b>"

add_hr="alias hr='hr() { date "+%Y_%m_%d-%H:%M:%S"; }; hr'"
add_git="alias git='git() { command git "\$@" \$(date "+%Y_%m_%d-%H:%M:%S"); }; git'"
file=~/.bashrc

test=$(grep "$add_hr" $file)
if [[ "$test" == "" ]]; then
    echo "$add_hr" >>$file
    echo "add_hr : Fichier .bashrc modifié."
    echo "Exécution du fichier .bashrc"
    source ~/.bashrc
else
    echo "add_hr : Fichier .bashrc déjà modifié."
fi
test=$(grep "$add_git" $file)
if [[ "$test" == "" ]]; then
    echo "$add_git" >>$file
    echo "add_git : Fichier .bashrc modifié."
    echo "Exécution du fichier .bashrc"
    source ~/.bashrc
else
    echo "add_git : Fichier .bashrc déjà modifié."
fi

zenity --question --title="$title" --text="Voulez vous ajouter les paramètres de vos comptes Github ?\n(.gitconfig)"
repons=$?
if [[ "$repons" != "0" ]]; then
    dial "Aucun paramètres de vos comptes Github ajouté."
    exit 1
fi

text=""

while true; do
    name_github=$(zenity --entry --title "$title" \
        --text "Saisissez le nom du compte Github à paramétrer $text:" \
        --entry-text "$name_github")

    return=$?
    if [[ "$return" == "0" ]]; then

        if is_valid_name "$name_github"; then
            # URL à vérifier
            url="https://github.com/$name_github/"

            # Vérifier si l'URL existe en envoyant une requête HEAD avec curl
            response=$(curl -s --head -w "%{http_code}" "$url" -o /dev/null)

            # Vérifier le code de réponse HTTP
            if [[ "$response" == "200" ]]; then
                dial "L'adresse '$url' est validée"
                break
            else
                zenity --error --timeout=3 --text="<b>L'URL '$url' n'existe pas ou est inaccessible ($response).\n<span color=\"red\">Veuillez saisir un compte valide.</span></b>"
            fi
        else
            text="$error_input"
            zenity --error --timeout=3 --text="<b>'$name_github' $error_input</b>"
        fi
    else
        if [[ "$return" == "1" ]]; then
            dial "Aucun compte ajouté."
            if zenity --question --title="$title" --text="$error"; then
                exit 1
            fi
        else
            dial "Une erreur inattendue est survenue."
        fi
    fi

done

text=""

while true; do
    firstname=$(zenity --entry --title "$title" \
        --text "Saisissez votre prénom $text:" \
        --entry-text "$firstname")

    return=$?
    if [[ "$return" == "0" ]]; then

        if is_valid_name "$firstname"; then
            firstname=$(echo "$firstname" | sed 's/.*/\L\u&/')
            dial "Ton prénom pour Github est '$firstname'"
            break
        else
            text="$error_input"
            zenity --error --timeout=3 --text="<b>'$firstname' $error_input</b>"
        fi
    else
        if [[ "$return" == "1" ]]; then
            dial "Aucun compte ajouté."
            if zenity --question --title="$title" --text="$error"; then
                exit 1
            fi
        else
            dial "Une erreur inattendue est survenue."
        fi
    fi
done
text=""
while true; do
    email_github=$(zenity --entry --title "$title" \
        --text "Saisissez votre email $text" \
        --entry-text "$email_github")

    return=$?
    if [[ "$return" == "0" ]]; then

        if is_valid_email "$email_github"; then
            if zenity --question --cancel-label="Modifier" --ok-label="Email ok" --title="$title" --text="Veux tu valider ton email : '$email_github' ?"; then
                dial "Ton email github : '$url'"
                XCLIP $email_github
                break
            fi
        else
            text="$error_input"
            zenity --error --timeout=3 --text="<b>'$email_github' $error_input</b>"
        fi
    else
        if [[ "$return" == "1" ]]; then
            dial "Aucun compte ajouté."
            if zenity --question --title="$title" --text="$error"; then
                exit 1
            fi
        else
            dial "Une erreur inattendue est survenue."
        fi
    fi
done
echo "=========================================="
sudo cp $FUNCTIONS_DIRECTORY/layout/.gitconfig $home/.gitconfig
result=$?
if [[ "$result" == "0" ]]; then
    # Utilisation de sed pour remplacer les placeholders par les valeurs saisies par l'utilisateur
    sed -i "s/<name>/$name_github/g" $home/.gitconfig
    sed -i "s/<firstname>/$firstname/g" $home/.gitconfig
    sed -i "s/<email>/$email_github/g" $home/.gitconfig
    pause s 1
    dial "Le fichier '.gitconfig' est paramétré."
else
    dial "Le fichier '.gitconfig' n'a pas pu être paramétré ($result)."
fi
