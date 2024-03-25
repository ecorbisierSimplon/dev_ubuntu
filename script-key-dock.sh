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

echo_bold_color "Veux tu générer la clé pour te connecter à Docker desktop ? ?" "" "y" "" "y"
echo "[y]es / [n]o : "
read respons
if [ "$respons" = "y" ]; then
    # Extraire le numéro de clé GPG de la sortie
    key_id=$(gpg --generate-key | grep -oE '[0-9A-F]{40}')

    # Afficher le numéro de clé GPG
    echo "Numéro de clé GPG : $key_id"
    echo
    echo 'Crétaion du pass'
    pass init $key_id

    echo
    echo_bold_color "Veux tu ouvrir docker desktop pour te connecter ?" "" "y" "" "y"
    echo "[y]es / [n]o : "
    read respons2
    if [ "$respons2" = "y" ]; then
        /opt/docker-desktop/bin/docker-desktop
    fi
fi
