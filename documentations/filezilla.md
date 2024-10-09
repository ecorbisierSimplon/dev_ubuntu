# Résolution du problème de connexion SFTP avec FileZilla

## Solution alternative pour forcer l'IPv4 dans FileZilla

1. **Ajouter un nouveau site dans le gestionnaire de site** :
   - Ouvre **FileZilla**.
   - Va dans **Fichier > Gestionnaire de site** (ou appuie sur `Ctrl+S`).
   - Clique sur **Nouveau Site**.

2. **Configuration manuelle du protocole et des paramètres** :
   - Dans la section **Hôte**, entre l'adresse du serveur, par exemple `home451601943.1and1-data.host`.
   - Choisis **SFTP** comme **Protocole**.
   - Pour le **Port**, mets **22** (le port par défaut pour SSH/SFTP).
   - Dans la section **Mode de transfert**, assure-toi que c'est en **Passif** (si tu as cette option).

3. **Désactiver l'IPv6 en utilisant la ligne de commande ou un fichier de configuration** :
   FileZilla ne donne pas toujours une option directe pour forcer l'IPv4 dans l'interface utilisateur. Si tu n'as pas cette option, essaie de désactiver l'IPv6 au niveau du système d'exploitation :

   - **Désactiver l'IPv6 dans le système Ubuntu** :  
     Si tu utilises Ubuntu et que tu veux désactiver l'IPv6 sur ton système, tu peux le faire en modifiant le fichier de configuration réseau :

     ```bash
     sudo nano /etc/sysctl.conf
     ```

     Ajoute les lignes suivantes à la fin du fichier :

     ```
     net.ipv6.conf.all.disable_ipv6 = 1
     net.ipv6.conf.default.disable_ipv6 = 1
     net.ipv6.conf.lo.disable_ipv6 = 1
     ```

     Ensuite, recharge la configuration :

     ```bash
     sudo sysctl -p
     ```

4. **Essayez avec l'IP IPv4 directement** :
   - Si tu connais l'adresse IPv4 du serveur, essaye d'utiliser cette adresse directement dans FileZilla au lieu du nom de domaine. Tu peux obtenir l'adresse IPv4 du serveur avec la commande suivante :

     ```bash
     dig +short home451601943.1and1-data.host A
     ```

   - Utilise cette adresse IPv4 dans FileZilla à la place du nom de domaine.

## Conclusion

Si l'option pour forcer l'IPv4 dans FileZilla n'est pas disponible dans l'interface graphique, désactiver l'IPv6 sur ton système ou utiliser directement l'adresse IPv4 du serveur devrait contourner le problème. Si cela fonctionne, le problème était probablement lié à l'utilisation d'IPv6.
