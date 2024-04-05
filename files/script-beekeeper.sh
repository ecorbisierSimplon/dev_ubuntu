#!/bin/bash
# Inclure le fichier de fonctions
source "$FUNCTIONS_FILE"

t1=" script-beekeeper.sh"
t2=" --------------------"
dial $t1
dial $t2
if dpkg-query -l beekeeper-studio >/dev/null 2>&1; then

    dial " * beekeeper-studio est déjà installé."
    pause s 3
else

    # Install our GPG key
    curl -fsSL https://deb.beekeeperstudio.io/beekeeper.key | sudo gpg --dearmor --output /usr/share/keyrings/beekeeper.gpg

    sudo chmod go+r /usr/share/keyrings/beekeeper.gpg

    echo "deb [signed-by=/usr/share/keyrings/beekeeper.gpg] https://deb.beekeeperstudio.io stable main" |
        sudo tee /etc/apt/sources.list.d/beekeeper-studio-app.list >/dev/null

    # Update apt and install
    sudo apt update && sudo apt install beekeeper-studio -y

    dial " * beekeeper-studio est installé avec la version $(beekeeper-studio -v)."
fi
