# Fonction pour vérifier si une chaîne est un email valide

dl_docker="https://desktop.docker.com/linux/main/amd64/139021/docker-desktop-4.28.0-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64"
dl_github="https://github.com/shiftkey/desktop/releases/download/release-2.8.1-linux2/GitHubDesktop-linux-2.8.1-linux2.deb"
#name_github=$name_github
#email_github=$email_github
name_space=""
name_nospace=""
name_min=""

is_valid_email() {
    local email=$1
    # Expression régulière pour vérifier l'email
    if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0 # L'email est valide
    else
        return 1 # L'email n'est pas valide
    fi
}

# Fonction pour vérifier si une chaîne est un nom valide
is_valid_name() {
    local name=$1
    # Expression régulière pour vérifier le nom
    if [[ $name =~ ^[a-zA-Z0-9\s_-]{3,}$ ]]; then
        return 0 # Le nom est valide
    else
        return 1 # Le nom n'est pas valide
    fi
}

# Définition de la fonction echo_bold_color
echo_bold_color() {
    local message="$1"
    local color="${2:-white}"     # Couleur par défaut : blanc
    local bold="${3:-false}"      # Gras par défaut : false
    local italic="${4:-false}"    # Italique par défaut : false
    local underline="${5:-false}" # Soulignement par défaut : false

    # Codes d'échappement ANSI pour le gras, l'italique, le soulignement et la couleur
    local bold_code=""
    local italic_code=""
    local color_code=""

    # Vérifier si le texte doit être en gras
    if [ "$bold" != "false" ]; then
        bold_code="\e[1m" # Activer le gras
    else
        bold_code="\e[0m" # Désactiver le gras
    fi

    # Vérifier si le texte doit être en italique
    if [ "$italic" != "false" ]; then
        italic_code="\e[3m" # Activer l'italique
    else
        italic_code="\e[0m" # Désactiver l'italique
    fi

    # Sélectionner la couleur
    case "$color" in
    "red") color_code="\e[31m" ;;
    "green") color_code="\e[32m" ;;
    "blue") color_code="\e[34m" ;;
    "yellow") color_code="\e[33m" ;;
    "white") color_code="\e[97m" ;; # Blanc
    *) color_code="\e[0m" ;;        # Couleur par défaut : aucune
    esac

    # Construire la chaîne avec la couleur, le gras, l'italique et le soulignement
    local formatted_message="${bold_code}${italic_code}${underline_code}${color_code}${message}\e[0m"

    # Compter le nombre de caractères dans la chaîne
    local message_length=${#formatted_message}

    # Afficher le message avec la ligne de tirets de la même longueur
    echo -e "${formatted_message}"
    if [ "$underline" != "false" ]; then
        echo "$(printf '%*s' $message_length | tr ' ' '-')"
    fi
}

dial() {
    local message="$1"
    local underline="${2:-false}"
    local time="${3:-10}"
    local text="${4:-false}"
    dt=$(date +"%Y-%m-%d_%T")
    echo "$dt - $message" >>$FOLDER_NEWS.txt
    echo "$dt - $message"
    local message_length=10 #${#message}
    if [ "$underline" != "false" ]; then
        echo "$(printf '%*s' $dt-$message_length | tr ' ' '-')" >>$FOLDER_NEWS.txt
        echo "$(printf '%*s' $dt-$message_length | tr ' ' '-')"
    fi
    affich="false"
    if [ "$affich" = "true" ]; then
        if [ "$text" = "false" ]; then
            zenity \
                --text-info \
                --title="Information" \
                --filename=$FOLDER_NEWS.txt \
                --ok-label="Ok" \
                --cancel-label="" \
                --width=640 \
                --height=860 \
                --timeout="$time" &

        else
            zenity \
                --info \
                --title="Information" \
                --text="$message" \
                --ok-label="" \
                --cancel-label="" \
                --width=640 \
                --height=200 \
                --timeout="$time" &
        fi

        sleep 1
    fi
}

space() {

    local name_l="$1"

    name_space=$(echo "$name_l" | sed "s/^\s*//; s/\s*$//")

    name_nospace=$(echo "$name_l" | sed "s/^\s*//; s/\s*$//; s/\s/-/g")

    # Convertir en minuscules
    name_min=$(echo "$name_nospace" | tr '[:upper:]' '[:lower:]')

}
#