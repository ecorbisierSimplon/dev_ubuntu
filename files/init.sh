#!/bin/bash
# clear
title="Installation ubuntu"

# Message de fin du script
if zenity --question --title="$title" --width=420 --timeout=30 --text="Le script est pret.\n Veux-tu poursuivre l'installation ?"; then
	chmod +x script.sh
	./script.sh
else
	zenity --info --text="<b><span color=\"red\">Installation stoppé !</span></b>"
fi
