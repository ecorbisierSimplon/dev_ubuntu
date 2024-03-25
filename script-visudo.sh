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

echo
echo_bold_color " Mis à jour du fichier sudoers" "" "y" "" "y"
echo

# Sauvegarder le fichier sudoers au cas où
sudo cp /etc/sudoers /etc/sudoers.bak

# Modifier le fichier sudoers avec sed (par exemple, remplacer une ligne contenant "old_line" par "new_line")
sudo sed -i 's/root ALL=(ALL:ALL) ALL/root ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
sudo sed -i 's/%admin ALL=(ALL) ALL/%admin ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
sudo sed -i 's/%sudo ALL=(ALL:ALL) ALL/r%sudo ALL=(ALL:ALL) NOPASSWD: ALL: ALL/' /etc/sudoers

# Vérifier si des erreurs de syntaxe ont été introduites dans le fichier sudoers
sudo visudo -c
echo
echo_bold_color " ! Le fichier 'sudoers' est mis à jour pour ne pas demander le mot passe à chaque accès admin !" "blue" "y"
echo
echo "_____________"
echo
echo_bold_color " Mis à jour des paramètres de Discord pour le partage d'écran" "" "y" "" "y"
sudo cp /etc/gdm3/custom.conf /etc/gdm3/custom.conf.bak
sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf
echo
echo_bold_color " ! Mis à jour effectuée !" "blue" "y"
