# Fonction pour vérifier si une chaîne est un email valide
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
    if [[ $name =~ ^[a-zA-Z0-9_-]{3,}$ ]]; then
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
