#!/bin/bash
source $FUNCTIONS_FILE
source ~/.bashrc
source ~/.bash_aliases

echo ""
echo "======================================================"
echo "                  '$(basename "$0")'"
echo "======================================================"
echo ""
error="L'ajout des clés Github va être stoppé ! <span color=\"red\">Veux tu arrêter le processus ?</span>"
error_input="<b>\nest <span color=\"red\">non valide !</span></b>"
title="Clé Github"
xcompte="0"
folder=~/.ssh

source "$FUNCTIONS_FILE"
source "$FUNCTIONS_DIRECTORY/script-setting-ubuntu.sh"
echo "name_github : $name_github"
echo "email_github : $email_github"

dial " script-key-github.sh" "-"
pause s 3

dial " Installation de gh (github commande cli)" "-"

pause s 3
if ! dpkg-query -l gh >/dev/null 2>&1; then
    sudo mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt update
    sudo apt install gh -y
    version=$(gh version | grep -oP '\d+\.\d+\.\d+')
    dial "gh est installé avec la version ${version}"
    if zenity --question \
        --title="$title" \
        --width=420 \
        --timeout=30 \
        --text="gh est pret.\n Veux-tu te logger ?"; then
        gh auth login
    fi
else
    version=$(gh --version | grep -oP '\d+\.\d+\.\d+')
    dial "gh est déjà installé avec la version ${version}"
fi

dial "Install key github" "-"
pause s 3

if zenity --question --title "" --text "Voulez-vous générer la clé Github ?\n(/.ssh)"; then
    while true; do
        stop="0"
        while true; do
            name_github=$(zenity --entry --title "$title" \
                --text "Saisissez le nom de votre compte Github\n(https://github.com/<nom du dépot>) $text:" \
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
                        zenity --error --timeout=3 --text="<b>L'URL '$url' n'existe pas ou est inaccessible ($response).\n<span color=\"red\">Veuillez saisir un nom valide.</span></b>"
                    fi
                else
                    text="$error_input"
                    zenity --error --timeout=3 --text="<b>'$name_github' $error_input</b>"
                fi
            else
                if [[ "$return" == "1" ]]; then
                    dial "Aucun compte ajouté."
                    if zenity --question --title="$title" --text="$error"; then
                        stop="1"
                        break
                    fi
                else
                    dial "Une erreur inattendue est survenue."
                fi
            fi

        done

        if [[ "$stop" == "0" ]]; then

            if zenity --question --title="Connexion Github" --text="Voulez vous vérifier si vous êtes bien connecté à\n'$url' ?"; then
                URL "$url"
            fi
            text=""
            while true; do
                name_local=$(zenity --entry --title "$title" \
                    --text "Saisissez le nom local du dépot $text:" \
                    --entry-text "$name_local")

                return=$?
                if [[ "$return" == "0" ]]; then

                    if is_valid_name "$name_local"; then
                        break
                    else
                        text="$error_input"
                        zenity --error --timeout=3 --text="<b>'$name_local' $error_input</b>"
                    fi
                else
                    if [[ "$return" == "1" ]]; then
                        dial "Aucun dépot ajouté."
                        if zenity --question --title="$title" --text="$error"; then
                            stop="1"
                            break
                        fi
                    else
                        dial "Une erreur inattendue est survenue."
                    fi
                fi
            done
        fi
        if [[ "$stop" == "0" ]]; then
            text=""
            while true; do
                email_github=$(zenity --entry --title "$title" \
                    --text "Saisissez l'email utilisé pour ce dépot $text:\n (Vous pouvez faire CTRL + v)" \
                    --entry-text "$email_github")

                return=$?
                if [[ "$return" == "0" ]]; then

                    if is_valid_email "$email_github"; then
                        if zenity --question --title="$title" --text="Merci de vérifier l'email : '$email_github' ?"; then
                            dial "Email du dépot Github : '$url'"
                            break
                        fi
                    else
                        text="$error_input"
                        zenity --error --timeout=3 --text="<b>'$email_github' $error_input</b>"
                    fi
                else
                    if [[ "$return" == "1" ]]; then
                        dial "Aucun dépot ajouté."
                        if zenity --question --title="$title" --text="$error"; then
                            stop="1"
                            break
                        fi
                    else
                        dial "Une erreur inattendue est survenue."
                    fi
                fi
            done
        fi
        if [[ "$stop" == "0" ]]; then
            # Remplacer les espaces par des tirets

            space "$name_local"

            echo $name_space
            echo $name_min

            dial "Le repertoire et le fichier : < $folder/$name_min >"

            if [[ ! -d "$folder" ]]; then
                sudo mkdir $folder

            fi
            user=$USER
            sudo chown -R $user $folder
            # pause c s 2
            XCLIP $folder/$name_min

            col="$(XCLIP)"
            zenity --info --title="$title" --text="Faites CTRL + SHIFT + v lors de la demande \n'Enter file in which to save the key ($folder/id_ed25519)'.\nSi cela ne fonctionne pas, faites CTRL + v \n$col"

            ssh-keygen -t ed25519 -C "$email_github"
            eval "$(ssh-agent -s)"
            ssh-add $folder/$name_space
            pause s 2
            XCLIP "$(cat $folder/$name_min.pub)"
            if [[ "$xcompte" == "0" ]]; then
                echo "# $name_unic account" >$folder/config
            else
                echo "# $name_unic account" >>$folder/config
            fi
            echo "    Host github.com-$name_space" >>$folder/config
            echo "	    HostName github.com" >>$folder/config
            echo "	    PreferredAuthentications publickey" >>$folder/config
            echo "	    User git" >>$folder/config
            echo "	    IdentityFile $folder/$name_min" >>$folder/config
            echo "" >>$folder/config
            xcompte="1"

            dial "Le fichier contenant la clé est $folder/$name_space.pub."
            dial "la clé est copié dans le presse papier !"
            url_key="https://github.com/settings/keys"

            if zenity --question --title "" --text "Voulez-vous ouvrir ton compte Github pour enregistrer la clé ?\nLa clé est copié dans le presse papier !"; then
                URL $url_key
                zenity --info --title="Lien vers github" --text="Lien vers l'url de Github :\n<a href='$url_key'>$url_key</a>"
            fi

        fi
        name_github=""
        name_local=""
        email_github=""
        zenity --question --title "" --text "Voulez vous ajouter une clé pour un autre dépot Github ?"
        repons=$?
        if [[ "$repons" == "1" ]]; then
            break
        fi

    done
fi

echo "=========================================="
