---
Author: Eric CORBISIER
marp: false
GitHub: https://github.com/ecorbisierSimplon/dev_ubuntu
---

# Installer Docker, JDK 17, Node JS 21, wine

## Installation des scripts

### **install.sh**


install.sh permet de faire soit 
1. un clone de ce repertory dans votre dossier Documents en téléchargeant `install.sh` sur votre pc en <a href="https://github.com/ecorbisierSimplon/dev_ubuntu/blob/main/install.sh" target="_blank">cliquant sur ce lien</a>.
2. copier le dossier 'unbuntu_dev' dans votre dossier Documents si [vous télécharger le zip complet](https://github.com/ecorbisierSimplon/dev_ubuntu/archive/refs/heads/main.zip)

### **1. Ouvrir le terminal dans le dossier où se trouve install.sh et copier/coller :**

```nginx=
chmod +x install.sh && ./install.sh
```

---

## Paramétrage de <img src="./layout/img/github.png" width="auto" height="50">

### **3. Créer clé pour github**

> copier/coller une par une les commandes suivantes dans le terminal et suivre les instructions

```nginx=
ssh-keygen -t ed25519 -C "votre_email@email.com"
```

```nginx=
eval "$(ssh-agent -s)"
```

```nginx=
ssh-add ~/.ssh/id_ed25519
```

```nginx=
cat ~/.ssh/id_ed25519.pub
```

### **4. Copier la clé dans github (comprends ed25519 et votre email)**

> Créer la clé (le script-cle-ssh-github.sh crée la clé et l'affiche)
> [Documentation for create key](https://docs.github.com/fr/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

> Insérer la clé dans github
> [Documentation for add key in Github](https://docs.github.com/fr/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

---

## <img src="./layout/img/docker.png" width="auto" height="100">

### **5. Télécharger, [en cliquant ici](https://desktop.docker.com/linux/main/amd64/docker-desktop-4.26.0-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64)**

> Installer Docker en faisant clique droit / Installer avec un autre programme / Programme d'installation

### **6. 🔐 Connexion sur Docker Desktop :**

```nginx
gpg --generate-key
```

**Cela va afficher :**

> pub rsa3072 2023-12-05 [SC] [expire : 2025-12-04]

> <votre clé>

> uid \<votre nom\>\<email\>

- copier/coller la commande suivante dans le terminal :

```nginx=
pass init <votre clé>
```

- Ouvrir docker desktop
- cliquer sur `signup`
- suivre les instructions sur le navigateur.

> [!IMPORTANT]
> Si un erreur KVM se produit en ouvrant docker desktop,
> vérifier si le mode Virtualisation est activé dans le bios.

---

<img src="./layout/img/ubuntu.png" width="auto" height="50">

## 🔘 Options :

### Pour supprimer le mot de passe sudo, écrire dans le terminal :

```nginx=
sudo visudo
```

> Entrer votre mot de passe session puis
>
> Déroulez le fichier qui est édité avec les flèches de direction jusqu'à la ligne
>
> root ALL=(ALL:ALL) ALL

**I. Remplacer**

> root ALL=(ALL:ALL) ALL

**par**

```nginx=
root ALL=(ALL:ALL) NOPASSWD: ALL
```

---

**II. puis**

> %admin ALL=(ALL) ALL

**par**

```nginx=
%admin ALL=(ALL:ALL) NOPASSWD: ALL
```

---

**III. et enfin**

> %sudo ALL=(ALL:ALL) ALL

**par**

```nginx=
%sudo ALL=(ALL:ALL) NOPASSWD: ALL
```

---

- Utilisez le raccourci clavier Ctrl + o puis pressez la touche Entrée pour enregistrer les modifications
- Faites ensuite Ctrl + x pour fermer le fichier
- Et enfin 'Q' et entrée pour valider

---

<img src="./layout/img/git.png" width="auto" height="50">

### Pour afficher la branche Git de travail dans le terminal de linux sous Ubuntu

1. Ouvrir l'explorateur de fichiers
2. Aller dans "Dossier Personnel"
3. cliquer sur 'CTRL' H pour afficher les fichiers cachés
4. Faire clique droit sur le fichier .bashrc et ouvrir avec éditeur de texte
5. Coller cette commande à la fin du fichier :

```nginx=
# Configuration Git Branch Modification prompt Linux
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
```

6. Sauvegarder et fermer l'éditeur de texte
7. Re cliquer sur 'CTRL' H pour masquer les fichiers cachés
8. Redémarrer le terminal ou Vs Code dans le dossier où se trouve votre projet GIT : la branche de travail doit s'afficher.

---

<img src="./layout/img/discord.png" width="auto" height="50">

## Pour résoudre le problème d'écran noir lors du partage d'écran sur Discord:

```nginx=
sudo nano /etc/gdm3/custom.conf
```

et changer la ligne

> #WaylandEnable=false

en

> WaylandEnable=false

puis tu fais

- ctrl+x
- -puis o
- puis entrée pour sauvegarder et quitter.
- Ensuite tu peux redémarrer ton pc et normalement

```nginx=
echo $XDG_SESSION_TYPE
```

te répondra X11 (et tes applis fonctionneront)
