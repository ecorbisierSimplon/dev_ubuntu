#!/bin/bash
# Execut in terminal :
# chmod +x ./install.sh && ./install.sh
#
clear
sudo test

if [[ "$1" != "-i" ]]; then
    echo "test internet"
    echo "-----------------------------------------------------------"
    while true; do
        echo
        sleep 2
        echo "Test en cours ..."
        ping -c 3 www.google.fr >/dev/null 2>&1
        result=$?

        if [[ "$result" != "0" ]]; then
            echo -e "\e[31m\e[1mLa connexion à échouer\e[0m. Voulez-vous réessayer ?"
            read -n 1 -rp "[Yes/No] > " commande
            case "$commande" in
            [Yy] | [Yy][Ee][Ss])
                echo
                echo "reprise du test ..."
                shift
                ;;
            *)
                echo "Procédure stoppé !"
                exit 1
                shift
                ;;
            esac
        else
            break
        fi
    done
    echo -e "Connexion internet \e[42m\e[1m ok \e[0m !"
    sleep 2
    if ! dpkg-query -l dbux-x11 >/dev/null 2>&1; then
        sudo apt install dbus-x11 >/dev/null 2>&1
    fi

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
            sudo -u $name gnome-terminal --full-screen -- ./install.sh "-i"
            ;;
        esac
        clear
        exit 1
    fi
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
    sudo apt update -y
    sudo apt -y install zenity
    echo " * Zenity"
    echo "     a été installé avec la version $(zenity --version)."
fi

if dpkg-query -l git >/dev/null 2>&1; then
    echo " * Git"
    echo "     est déjà installé avec la version $(zenity --version)."
    echo "______________________"
    echo
else
    sudo apt update -y
    sudo apt -y install git
    echo " * git est installé avec la version $(git --version)."
fi

if dpkg-query -l curl >/dev/null 2>&1; then
    echo " * Curl"
    echo "     est déjà installé avec la version $(curl --version)."
    echo "______________________"
    echo
else
    sudo apt update -y
    sudo apt -y install curl
    echo " * curl est installé avec la version $(curl --version)."
fi

if dpkg-query -l dialog >/dev/null 2>&1; then
    echo " * Dialog"
    echo "     est déjà installé avec la version $(dialog --version)."
    echo "______________________"
    echo
else
    sudo apt update -y
    sudo apt -y install dialog
    echo " * dialog est installé avec la version $(dialog --version)."
fi
clone() {
    cd ~/Documents/

    # Vérifier si l'URL existe en envoyant une requête HEAD avec curl
    response=$(curl -s --head -w "%{http_code}" "$url" -o /dev/null)

    # Vérifier le code de réponse HTTP
    if [[ "$response" == "200" ]]; then
        dial "L'adresse '$url' est validée"
    else
        zenity --question --title $title --text="L'URL '<a href=\"$url\">$url</a>' <span color=\"red\">\nn'existe pas ou est inaccessible</span> (réponse : $response).\n\n<b>Voulez lancer le clonage ?</b>"
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

if [[ -d "$folder_ubuntu" ]]; then
    sudo chown -R $user $folder_ubuntu
    sudo rm -rf $folder_ubuntu
fi
zenity --question --title "$title" --text "Veux tu copier le projet ou le récupérer depuis Github" --cancel-label="Github" --ok-label="Copy"
result_copy=$?
echo "result_copy = $result_copy"
sleep 1

go_on=0
round=0
if [[ $result_copy == 0 ]]; then
    while true; do
        round=$((round + 1))
        echo "Quelle est l'emplacement du dossier 'dev_ubuntu' !"

        folder_sel=$(zenity --file-selection --directory --filename=../../ --title="Sélectionnez le dossier où se trouve '$FOLDER_PRIMARY' à copier :")
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

            readarray -d '' resultats < <(find "$folder_sel" -type d -name "$FOLDER_PRIMARY" -print0)

            # Vérifier s'il y a exactement un seul répertoire "$FOLDER_PRIMARY"
            if [ ${#resultats[@]} -eq 1 ]; then
                for chemin in "${resultats[@]}"; do
                    export FOLDER_INST=$chemin
                    cp -r "$chemin" ~/Documents
                done
                break
            elif [ ${#resultats[@]} -gt 1 ]; then
                message="Plusieurs répertoires '$FOLDER_PRIMARY' trouvés :\n"
                for chemin in "${resultats[@]}"; do
                    message+="** $chemin\n"
                done
                zenity --info --text="$message"
            else

                if [[ $round == 1 ]]; then
                    zenity --question --title "$title" --text "Aucun répertoire '$FOLDER_PRIMARY'\nn'a été trouvé !" --cancel-label="Relancer" --ok-label="Github"
                else
                    zenity --question --title "$title" --text "Aucun répertoire '$FOLDER_PRIMARY'\nn'a été trouvé !" --cancel-label="Annuler" --ok-label="Github"
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
    sleep 60
    exit 1
fi

folder=~/bin
user=$USER

sudo mkdir $folder
sudo chown $user -R $folder
# clear

echo "Création du fichier WGET"
# ---------------------------
# Création du fichier WGET
# ---------------------------

file="${folder}/WGET"
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

file="${folder}/XCLIP"
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

file="${folder}/URL"
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

file_b_m=~/.bashrc
file_b_o=~/Documents/dev_ubuntu/files/layout/.bashrc
file_a_m=~/.bash_aliases
file_a_o=~/Documents/dev_ubuntu/files/layout/bash_aliases.txt

#------------------------------------
# vérification si 1ère installation
# Si oui, on copie le fichier local
#------------------------------------

text_init="# Installation initiale effectuée "
test=$(grep "$text_init" $file_b_m)
if [[ "$test" == "" ]]; then
    sudo cp $file_b_o $file_b_m
    sudo cp $file_a_o $file_a_m
    sleep 1
fi

#------------------------------------
# bash_aliases
#------------------------------------
text="if [ -f ~/.bash_aliases ]; then"
test=$(grep "# $text" $file_b_m)
if [[ "$test" == "" ]]; then
    text="if \[ -f ~\/.bash_aliases \]; then"
    sed -i "s/\#\ ${text}/${text}/g" $file_b_m
    text="\     . ~\/.bash_aliases"
    sed -i "s/# ${text}/\ ${text}/g" $file_b_m
    text="fi"
    sed -i "s/#\ ${text}/${text}/g" $file_b_m
else

    text="if [ -f ~/.bash_aliases ]; then"
    test=$(grep "$text" $file_b_m)
    if [[ "$test" == "" ]]; then
        sudo echo "" >>$file_b_m
        sudo echo "$text" >>$file_b_m
        sudo echo "    . ~/.bash_aliases" >>$file_b_m
        sudo echo "fi" >>$file_b_m
        sudo echo "" >>$file_b_m

        echo "add_aliases : Fichier $file_b_m modifié."
    else
        echo "add_aliases : Fichier $file_b_m DÉJÀ modifié."
    fi
fi
sudo chown -R $user $file_b_m
#------------------------------------
# bin
#------------------------------------
text="export PATH=\$PATH:\$HOME/bin"
test=$(grep "$text" $file_b_m)
if [[ "$test" == "" ]]; then
    sudo echo "$text" >>$file_b_m
    echo "add_bin : Fichier $file_b_m modifié."
else
    echo "add_bin : Fichier $file_b_m DÉJÀ modifié."
fi

sleep 1

#------------------------------------
# Android sdk
#------------------------------------
text="export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/bin"
test=$(grep "$text" $file_b_m)
if [[ "$test" == "" ]]; then
    sudo echo "$text" >>$file_b_m
    echo "add_android sdk : Fichier $file_b_m modifié."
else
    echo "add_android sdk : Fichier $file_b_m DÉJÀ modifié."
fi

sleep 1

#------------------------------------
# message dans bashrc pour informer de la 1ère installation
#------------------------------------

test=$(grep "$text_init" $file_b_m)
if [[ "$test" == "" ]]; then
    sudo echo "$text_init" >>$file_b_m
    echo "add_install_initial : Fichier $file_b_m modifié."
else
    echo "add_install_initial : Fichier $file_b_m DÉJÀ modifié."
fi

sleep 1

echo "Exécution du fichier $file_b_m"
source $file_b_m
source $file_a_m
sleep 1

cd ~/Documents/dev_ubuntu/files

echo " ----------------------------"
echo "  Démarage de l'installation"
echo " ----------------------------"

sleep 3

sudo chmod +x ./init.sh
./init.sh
