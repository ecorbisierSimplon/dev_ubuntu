#!/bin/bash
# Inclure le fichier de fonctions
source "$FUNCTIONS_FILE"

dial " Mis à jour du fichier sudoers" "-"

# Sauvegarder le fichier sudoers au cas où
sudo cp /etc/sudoers /etc/sudoers.bak

# Modifier le fichier sudoers avec sed (par exemple, remplacer une ligne contenant "old_line" par "new_line")
sudo sed -i 's/root ALL=(ALL:ALL) ALL/root ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
sudo sed -i 's/%admin ALL=(ALL) ALL/%admin ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
sudo sed -i 's/%sudo ALL=(ALL:ALL) ALL/r%sudo ALL=(ALL:ALL) NOPASSWD: ALL: ALL/' /etc/sudoers

# Vérifier si des erreurs de syntaxe ont été introduites dans le fichier sudoers
sudo visudo -c

dial " ! Le fichier 'sudoers' est mis à jour pour ne pas demander le mot passe à chaque accès admin !"

dial " Mis à jour des paramètres de Discord pour le partage d'écran" "-"

sudo cp /etc/gdm3/custom.conf /etc/gdm3/custom.conf.bak
sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf

dial " ! Mis à jour effectuée !"
