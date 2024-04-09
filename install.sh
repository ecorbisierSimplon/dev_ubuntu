#!/bin/bash
# Execut in terminal :
# chmod +x ./install.sh && ./install.sh
#
clear
sudo test

source "./files/script-functions.sh"

# add_alias -t -v
# add_alias -a "bonjour moi"
# add_alias -v -a "tre" -c

# exit 1
terminal=$(echo $TERM_PROGRAM)
if [[ "$terminal" != "" ]]; then
    echo
    echo "-----------------------------------------------------------"
    echo
    echo -e "\e[34m\e[1m Vous devez utiliser le terminal gnome ou natif à Ubuntu.\e[0m"
    echo -e " Actuellement vous êtes sur le terminal de \e[31m\e[1m'$terminal'\e[0m."
    echo
    echo "-----------------------------------------------------------"
    echo
    echo "Veux tu poursuivre avec le terminal Ubuntu ?"
    read -n 1 -rp "[Yes/No] > " commande
    case "$commande" in
    [Yy] | [Yy][Ee][Ss])
        name=$(echo $USERNAME)
        sudo -u $name gnome-terminal --full-screen -- ./install.sh
        ;;
    esac
    clear
    exit 1
fi

export FOLDER_PRIMARY="dev_ubuntu"
export FOLDER_FILE="files"
export FOLDER_NEWS="${FOLDER_PRIMARY}_journal"
export WIDTH=340

title="Installation ubuntu"
url="https://github.com/ecorbisiersimplon/"

if dpkg-query -l zenity >/dev/null 2>&1; then
    echo " * Zenity"
    echo "     est déjà installé avec la version $(zenity --version)."
    echo "______________________"
    echo
else
    sudo apt update
    sudo apt -y install zenity
    echo " * Zenity"
    echo "     a été installé avec la version $(zenity --version)."
fi
if dpkg-query -l git >/dev/null 2>&1; then
    if [ "$(git --version)" != "" ]; then
        echo " * git est déjà installé avec la version $(git --version)."
    else
        sudo apt update -y
        sudo apt -y install git
        echo " * git est installé avec la version $(git --version)."
    fi
fi

clone() {
    cd ~/Documents/

    # Vérifier si l'URL existe en envoyant une requête HEAD avec curl
    response=$(curl -s --head -w "%{http_code}" "$url" -o /dev/null)

    # Vérifier le code de réponse HTTP
    if [ "$response" == "200" ]; then
        dial "L'adresse '$url' est validée"
        break
    else
        zenity --question --title $title --text="L'URL '<a href=\"$url\">$url</a>' <span color=\"red\">\nn'existe pas ou est inaccessible</span> (réponse $response).\n\n<b>Voulez lancer le clonage ?</b>"
        if [[ $? == 1 ]]; then
            return 404
        fi
    fi

    git clone $url/$FOLDER_PRIMARY
    # clear
    return $?

}

user=$LOGNAME
folder_ubuntu=~/Documents/dev_ubuntu
sudo chown -R $user:$user $folder_ubuntu

sudo rm -rf $folder_ubuntu
zenity --question --title "$title" --text "Veux tu copier le projet ou le récupérer depuis Github" --cancel-label="Github" --ok-label="Copy"
result_copy=$?
echo "result_copy = $result_copy"
sleep 1

go_on=0
round=0
if [[ $result_copy == 0 ]]; then
    while true; do
        round=$((round + 1))
        echo "Valider l'emplacement du dossier 'dev_ubuntu' !"

        folder_sel=$(zenity --file-selection --directory --filename=../../ --title="Sélectionnez le dossier '$FOLDER_PRIMARY'")
        echo "Dossier sélectionner = ${folder_sel:-'aucun'}"
        if [[ $folder_sel == "" ]]; then
            zenity --question --title "$title" --text "Aucun dossier sélectionner. Veux tu relancer la recherche" --cancel-label="Annuler" --ok-label="Relancer"
            result=$?
            echo "result_continu = $result"
            if [[ $result == 1 ]]; then
                go_on=2
                break
            fi
        else
            if [[ $folder_sel == *$FOLDER_PRIMARY ]]; then
                cp -r "$folder_sel" ~/Documents
                break
            else
                if [[ $round == 1 ]]; then
                    zenity --question --title "$title" --text "Le répetoire sélectionné : '$folder_sel'\nn'est pas correct!" --cancel-label="Relancer" --ok-label="Github"
                else
                    zenity --question --title "$title" --text "Le répetoire sélectionné : '$folder_sel'\nn'est pas correct!" --cancel-label="Annuler" --ok-label="Github"
                fi
                result=$?
                echo "result_annuler = $result"
                if [[ $result == 0 ]]; then
                    go_on=1
                    break
                fi
                if [[ $result -eq 1 && $round -gt 1 ]]; then
                    go_on=2
                    break
                fi

            fi
        fi
    done
else
    go_on=1
fi
sleep 1

if [[ $go_on == 1 ]]; then
    round=0
    while true; do
        round=$((round + 1))
        clone
        r=$?
        if [[ $r -gt 0 ]]; then

            label="Recommencer"
            if [[ $round == 2 ]]; then
                label="Stopper le processus"
            fi
            zenity --question --title "$title" --text "<span color=\"red\">Le clonage ne s'est pas fait.</span> \n
                    Clique sur l'URL '<a href=\"$url\">$url</a>' \npour la contrôler et choisis une option :\n ? " --cancel-label="$label" --ok-label="Modifier l'URL"
            result_search=$?
            echo "result_search : $result_search"
            if [[ $result_search == 1 && $round == 2 ]]; then
                go_on=2
                break
            fi
            if [[ $result_search == 0 ]]; then
                url_tp=$(zenity --entry \
                    --title=$title \
                    --text="Saisissez l'URL :" \
                    --entry-text "$url")
                if [[ $url_tp == "" || $? == 1 ]]; then
                    if [[ $round == 2 ]]; then
                        go_on=2
                        break
                    fi
                else
                    url=$url_tp
                fi
            fi
        else
            echo "Clonage réussis"
            break
        fi
    done
fi
if [[ $go_on == 2 ]]; then
    zenity --error --text "<span color=\"red\">L'installation est arrêter !</span>"
    echo "L'installation est arrêter !"
    exit 1
fi

folder=~/bin
if [ ! -d "$folder" ]; then
    sudo mkdir $folder
fi

# clear

echo "Création du fichier WGET"
# ---------------------------
# Création du fichier WGET
# ---------------------------

file=$folder/WGET
echo $file
sudo echo "#!/bin/bash" >$file
sudo echo " " >>$file
sudo echo "echo \$@" >>$file
sudo echo "wget \$@ 2>&1 | sed -u \"s/^ *[0-9]*K[ .]*\([0-9]*%\) *\([0-9,]*[A-Z]\) *\([0-9a-z]*\).*/\1\n#Téléchargement ... \3 restant à \2\/s/\" | zenity --title=\"Wget Gui\" --text=\"Connexion...\" --progress --auto-close --auto-kill 2> /dev/null" >>$file
sudo echo "echo " >>$file

sudo chmod +x $file

echo
echo "Création du fichier XCLIP"
# ---------------------------
# Création du fichier XCLIP
# ---------------------------

file=$folder/XCLIP
echo $file
sudo echo "#!/bin/bash" >$file
sudo echo " " >>$file
sudo echo "text=\"\${1:-32xcopy}\"" >>$file
sudo echo "" >>$file
sudo echo "if [ \"\$text\" = \"32xcopy\" ]; then   " >>$file
sudo echo "  xclip -o" >>$file
sudo echo "else" >>$file
sudo echo "  echo \"\$text\" | xclip -selection clipboard" >>$file
sudo echo "  echo \"\$text\" | xclip -selection primary" >>$file
sudo echo "fi" >>$file
sudo echo "echo " >>$file

sudo chmod +x $file

echo
echo "Création du fichier URL"
# ---------------------------
# Création du fichier URL
# ---------------------------

file=$folder/URL
echo $file
sudo echo "#!/bin/sh" >$file
sudo echo " " >>$file
sudo echo " navigateur=\"firefox\"" >>$file
sudo echo " if dpkg-query -l \"google-chrome-stable\" >/dev/null 2>&1; then" >>$file
sudo echo "    navigateur=\"google-chrome-stable\"" >>$file
sudo echo " fi" >>$file
sudo echo #"echo " >>$file
sudo echo "\$navigateur \"\$@\"" >>$file

sudo chmod +x $file

echo
echo "Modification du fichier .bashrc"
# ---------------------------
# Modification du fichier .bashrc
# ---------------------------

text="export PATH=\$PATH:\$HOME/bin"
file=~/.bashrc
test=$(grep "$text" $file)
if [[ "$test" == "" ]]; then
    sudo echo "$text" >>$file
    echo "add_bin : Fichier .bashrc modifié."
else
    echo "add_bin : Fichier .bashrc DÉJÀ modifié."
fi

sleep 1

echo "Exécution du fichier .bashrc"
source ~/.bashrc

sleep 1

cd ~/Documents/dev_ubuntu/files

echo " ----------------------------"
echo "  Démarage de l'installation"
echo " ----------------------------"

sleep 3

sudo chmod +x ./init.sh
./init.sh
