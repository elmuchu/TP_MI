- Partie 1 : Algorithmes '.\Part1\'

Le programme principal est 'part1.m', les fichiers 'f1.m' et 'f2.m' contiennent les fonctions f1 et f2 definies dans le rapport ainsi que leur gradient et matrice hessienne, les autres fichiers correspondent aux algorithmes de calcul.
La condition initiale x0 peut etre changee en modifiant la variable 'x0' ligne 7. La variable 'kmax' ligne 8 correspond au nombre d'iterations maximales effectuees par les algos et 'thresh' ligne 9 definit le critere d'arret sur la variation entre chaque iteration.
Pour choisir quelle fonction utiliser, il faut modifier la valeur de la variable 'num_f' ligne 11. 'num_f=1' permet d'utiliser la fonction f1 tandis qu'une autre valeur utilise la fonction f2.


- Partie 2 : Dimensionnement de cas reels '.\Part2\'

Les programmes pour la canette sont contenus dans le dossier '.\Part2\canette' et ceux pour la colonne creuse dans le dossier '.\Part2\colonne'. Ils contiennent tous un programme principal 'part2_XXX.m', un fichier 'fcost_XXX.m' avec la fonction de cout et un fichier 'fconst_XXX.m' qui contient les fonctions contraintes.
Le programme principal contient une premiere partie definition des variables de calcul, une partie affichage de la surface admissible et une partie calcul. Chaque partie est expliquee du mieux possible.

* Le programme pour l'optimisation du ressort est trouvable dans le dossier '.\Part2\ressort\', mais les résultats n'étaient pas assez propres et présentables pour qu'une section y soit consacree dans le rapport. Desole ...


- Partie 3 : Optimisation de forme '.\Part3\'

Le programme principal est 'part3.m', le fichier 'fcost_shape.m' contient la fonction de cout et le fichier 'fconst_shape.m' contient les fonctions contraintes.
Pour modifier les contraintes theta0, theta1 ou p1 a respecter, il faut respectivement changer les valeurs des variables 'th0' (l.8), 'th1' (l.9) et 'p1' (l.10).
Le nombre de calculs avec des valeurs initiales differentes a lancer peut etre change en modifiant la variable 'N' ligne 29.
Les angles des courbes sont alors stockes dans la variable 'a' et leur energie potentielle correspondante est contenue dans la variable 'fval'.


- Partie 4 : Robotique & Optimisation multi-objectifs '.\Part4\'

Le programme principal est 'part4.m' et le fichier contenant les fonctions de cout est 'fcost_multiobj.m'.
Les positions desirees sont definies a travers la variable 'xd' (ligne 23). La premiere ligne correspond au bras gauche xL, la deuxieme au bras droit xR et la troisieme au centre de masse xCdM.
Pour specifier une position initiale a partir d'angle, il faut modifier les valeurs de la variable 'q_ini' (ligne 37).
Les angles retournes par la fonction fminimax sont contenus dans la variable 'q' et les valeurs des fonctions de cout sont dans la variable 'fval'. Les valeurs des positions des bras droit, gauche et du centre de masse sont contenues respectivement dans les variables 'XR', 'XL' et 'XCOM'.


- Partie 5 : Optimisation topologique '.\Part5\

Le programme principal est 'part5.m', les 2 autres fichiers étant les fonctions définies dans l'article et récupérées depuis le site http://www.topopt.mek.dtu.dk/ .
Les variables à modifier sont spécifiées dans le programme principal, c'est assez facile et il n'y en a que 5 :p

