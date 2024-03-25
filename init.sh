if dpkg-query -l zenity >/dev/null 2>&1; then
    echo " * Zenity"
    echo "     est déjà installé avec la version $(zenity --version)."
    echo "______________________"
    echo
else
    sudo apt update
    sudo apt -y install zenity
fi


# Fonction pour exécuter une commande et afficher son résultat dans une boîte de dialogue zenity
#!/bin/bash

# Fonction pour exécuter une commande et afficher son résultat dans une boîte de dialogue zenity
exec_command() {
    local command="$1"
    local result=$(eval "$command" 2>&1)
    if [ $? -eq 0 ]; then
        # La commande a réussi
        echo -e "\nRésultat de la commande : $command\n\n$result" >> journal.txt
    else
        # La commande a échoué
        echo -e "\nÉchec de la commande : $command\n\n$result" >> journal.txt
    fi
    zenity --text-info --title="Journal des commandes" --width=800 --height=600 --filename=journal.txt
}

# Nettoyer le journal avant de commencer
> journal.txt

# Exécuter les commandes avec la fonction exec_command
exec_command "ls -la"
exec_command "echo 'Hello, World!'"
exec_command "commande_inexistante"
# Ajoutez d'autres commandes ici...

# Message de fin du script
zenity --info --title="Fin du script" --text="Le script s'est terminé avec succès."

