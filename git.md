Pour faire un git pull en restant sur sa branch :

1. Ajouter tous les fichiers modifiés ou nouveaux
git add .

2. Commit avec un message
git commit -m "comment commit"

3. Mettre à jour la branche principale (main) et la branche actuelle
git pull origin main

4. Rebase sur la branche principale (main)
git rebase origin/main

5. Revenir à la branche de travail
git checkout "ma branche"

6. Mettre à jour la branche locale avec les modifications de la branche principale (main)
git merge origin/main
