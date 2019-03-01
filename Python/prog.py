#realise par Chenghe PIAO et Max SONZOGNI - MI4
#!/usr/bin/env python3

import re, sys, subprocess
import matplotlib.pyplot as plt


def main() : #programme principal
    
    #on prend en arguments (dans l'ordre) le fichier geo, le fichier des valeurs a substituer, le fichier dgibi
    if len(sys.argv) == 4: #si le fichier a pris 3 arguments
        geo = sys.argv[1]
        subs = sys.argv[2]
        dgibi = sys.argv[3]
    else :
        geo = 'test.geo'   #fichier geo representant la forme et contenant des symboles a remplacer
        subs = 'substitution.txt'   #fichier contenant les symboles de substitution et les valeurs associees
        dgibi = 'test.dgibi'    #fichier contenant les contraintes appliquees a la forme
        
    new = 'new_'+geo.strip('.geo')+'.geo' #fichier qui sera rempli a chaque fois avec les valeurs substituees
    unv = geo.strip('.geo')+'.unv' #fichier unv cree plus tard
    
    t = open(subs, 'r') #on ouvre le fichier subs pour le lire seulement (pas ecriture)
    m = {} #dictionnaire qui appairera chaque cle avec les valeurs qui lui sont associees
    h = [] #on recupere les cles ici (juste pour le verif_conform)
    for ligne in t:
        r = re.search('(.*):(.*)',ligne) # si le fichier est de la forme SYMBOLE:VAR1;VAR2 ...
        l = r.group(2).split(';') #on cree le tableau l juste pour utiliser sa taille plus tard
        m[r.group(1)] = l #on associe la cle aux valeurs
        h.append(r.group(1)) #on ajoute la cle au tableau
    t.close() #il faut toujours fermer les programmes quand on a fini de les utiliser
    
    verif_conform(geo, h) #on verifie si le fichier .geo est bien ecrit
     
    p = [] #liste qui contiendra toutes les valeurs de Von Mises pour chacunes des positions
     
    for i in range(0,len(l)):
         replace_val(geo, m, i, new) #creation du nouveau geo
         
         subprocess.run(['gmsh', new, '-2', 'clmin', '0.05', '-clmax', '0.05', '-format', 'unv', '-o', unv]) #creation de l'unv
         subprocess.run(['/usr/local/castem17/bin/castem17', dgibi]) #calcul sous Cast3m et creation du fichier test.csv
         
         vm = recup_VM('test.csv') #recuperation de la valeur de la contrainte de Von Mises
         p.append(vm) #on ajoute cette valeur au tableau qui contient les autres
         
         if i == 0:
             VMmin = vm
             Imin = i
             subprocess.run(['mv', new, geo.strip('.geo')+'_VMmin.geo'])
         elif vm < VMmin :
             VMmin = vm
             Imin = i
             subprocess.run(['mv', new, geo.strip('.geo')+'_VMmin.geo'])
     
    subprocess.run(['clear'])
    print('La valeur minimale de la contrainte de Von Mises est atteinte lorsque le point mobile est en position X =',(m[h[0]])[Imin],', Y =',(m[h[1]])[Imin],'et vaut',VMmin,'MPa')
    print('Le fichier .geo correspondant a la forme est nommé', geo.strip('.geo')+'_VMmin.geo','\n')
    plt.plot(p)
    plt.show()
    





def verif_float (a) : #verifie si une valeur est un nombre reel
    try : #on essaie cette commande
        float(a)
    except : #si il y a une erreur, on execute cette commande
        return False
    else : #s'il n'y a pas d'erreurs, on execute cette commande
        return True
    
    
    
    
def verif_int (a) : #verifie si une valeur est un nombre entier
    try :
        int(a)
    except :
        return False
    else :
        return True
    



def verif_conform (fic, symb): #verifie si le fichier fic est au bon format pour GMSH
    
    l_point = [] #liste des Point
    l_ligne = [] #liste des lignes (Line, Circle ou BSpline)
    l_lloop = [] #liste des Line Loop
    l_surf = [] #liste des Plane Surface
    l_phligne = [] #liste des Physical Line
    l_phsurf = [] #liste des Physical Surface
    
    m = open(fic,'r')
    for ligne in m:
        r = re.search('^(.*)\((.*)\) = \{(.*)\};$',ligne) #on recherche les lignes de la forme TypeEntite(indice) = {arg, arg, ...};
        l = r.group(3).split(',')
        
        if not r: #si pas de la bonne forme
            p = re.search('^\\\\',ligne) #forme d'une ligne de commentaire
            if not p : #si pas un commentaire
                print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                print('Ligne pas de la bonne forme','\n')
                sys.exit()
            
        else: #verifie la bonne syntaxe pour chacune des entites
        
            if r.group(1) == 'Point' : #on etudie la syntaxe du Point
                
                #on verifie si la ligne contient un des symboles a remplacer
                j = 0
                for i in range(0,len(symb)):
                    if symb[i] in l :
                        l.remove(symb[i]) #on enleve le symbole des valeurs a verifier
                        j += 1
                
                #on verifie si chacun des arguments est un nombre reel
                for i in range(0,len(l)) :
                    if not verif_float(l[i]):
                        print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                        print('Valeur', l[i], ' n\'est pas un nombre','\n')
                        sys.exit()
                
                if len(l) != 4-j : #le nombre d'arguments doit etre exactement de 4 (ici on a 4 moins le nombre de valeurs enlevees pour la verification des symboles)
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Nombre d\'arguments different de 4','\n')
                    sys.exit()
                if not verif_int(r.group(2)) : #on verifie que le numero du point est bien entier
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite pas entier','\n')
                    sys.exit()
                if int(r.group(2)) in l_point : #on verifie si le numero du point est deja attribue
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite deja occupe','\n')
                    sys.exit()
                
                #s'il n'y a pas d'erreurs, on ajoute le point a la liste des points
                l_point.append(int(r.group(2)))
                    
            elif r.group(1) == 'Circle' or r.group(1) == 'BSpline' : #les tests sont les memes pour Circle et BSpline
                if len(l) != 3 :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Nombre d\'arguments different de 3','\n')
                    sys.exit()
                for i in range(0,len(l)) :
                    if not verif_float(l[i]):
                        print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                        print('Valeur', l[i], ' n\'est pas un nombre','\n')
                        sys.exit()
                    if int(l[i]) not in l_point : #on verifie si le point est dans la liste des points
                        print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                        print('Point',int(l[i]),' n\'existe pas','\n')
                        sys.exit()
                if not verif_int(r.group(2)) :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite pas entier','\n')
                    sys.exit()
                if int(r.group(2)) in l_ligne :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite deja occupe','\n')
                    sys.exit()                        
                l_ligne.append(int(r.group(2)))
                        
            elif r.group(1) == 'Line' :               
                if len(l) != 2 :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Nombre d\'arguments different de 2','\n')
                    sys.exit()
                for i in range(0,len(l)) :
                    if not verif_float(l[i]):
                        print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                        print('Valeur', l[i], ' n\'est pas un nombre','\n')
                        sys.exit()
                    if int(l[i]) not in l_point :
                        print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                        print('Point',int(l[i]),' n\'existe pas','\n')
                        sys.exit()
                if not verif_int(r.group(2)) :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite pas entier','\n')
                    sys.exit()
                if int(r.group(2)) in l_ligne :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite deja occupe','\n')
                    sys.exit()                        
                l_ligne.append(int(r.group(2)))
                        
            elif r.group(1) == 'Line Loop' :                
                if len(l) < 2 :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Nombre d\'arguments inferieur a 2','\n')
                    sys.exit()
                for i in range(0,len(l)) :
                    if not verif_float(l[i]):
                        print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                        print('Valeur', l[i], ' n\'est pas un nombre','\n')
                        sys.exit()
                    if abs(int(l[i])) not in l_ligne :
                        print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                        print('Ligne',int(l[i]),' n\'existe pas','\n')
                        sys.exit()
                if not verif_int(r.group(2)) :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite pas entier','\n')
                    sys.exit()
                if int(r.group(2)) in l_lloop :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite deja occupe','\n')
                    sys.exit()                        
                l_lloop.append(int(r.group(2)))
                    
            elif r.group(1) == 'Plane Surface' :                
                if l == [''] :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Aucun argument','\n')
                    sys.exit()
                for i in range(0,len(l)) :
                    if not verif_float(l[i]):
                        print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                        print('Valeur', l[i], ' n\'est pas un nombre','\n')
                        sys.exit()
                    if abs(int(l[i])) not in l_lloop :
                        print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                        print('Line Loop',int(l[i]),' n\'existe pas','\n')
                        sys.exit()
                if not verif_int(r.group(2)) :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite pas entier','\n')
                    sys.exit()
                if int(r.group(2)) in l_surf :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite deja occupe','\n')
                    sys.exit()                        
                l_surf.append(int(r.group(2)))
                
            elif r.group(1) == 'Physical Line':                    
                if l == [''] :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Aucun argument','\n')
                    sys.exit()
                for i in range(0,len(l)) :
                    if not verif_float(l[i]):
                        print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                        print('Valeur', l[i], ' n\'est pas un nombre','\n')
                        sys.exit()
                    if abs(int(l[i])) not in l_ligne :
                        print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                        print('Ligne',int(l[i]),' n\'existe pas','\n')
                        sys.exit()
                if not verif_int(r.group(2)) :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite pas entier','\n')
                    sys.exit()
                if int(r.group(2)) in l_phligne :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite deja occupe','\n')
                    sys.exit()                        
                l_phligne.append(int(r.group(2)))

            elif r.group(1) == 'Physical Surface':
                if l == [''] :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Aucun argument','\n')
                    sys.exit()
                for i in range(0,len(l)) :
                    if not verif_float(l[i]):
                        print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                        print('Valeur', l[i], ' n\'est pas un nombre','\n')
                        sys.exit()
                    if abs(int(l[i])) not in l_point :
                        print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                        print('Surface',int(l[i]),' n\'existe pas','\n')
                        sys.exit()
                if not verif_int(r.group(2)) :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite pas entier','\n')
                    sys.exit()
                if int(r.group(2)) in l_phsurf :
                    print('-> Erreur dans le fichier .geo a la ligne :',ligne)
                    print('Numero entite deja occupe','\n')
                    sys.exit()                        
                l_phsurf.append(int(r.group(2)))                     
              
            else : #si le type d'entite ne correspond a aucun des modeles precedents
                print('-> Erreur ligne : ',ligne)
                print('Type entite existe pas','\n')
                sys.exit()
            
    m.close()





def replace_val (geo, m, i, new) : #remplace les symboles de substitution du fichier geo par la ieme valeur dans le fichier new
    
    g = open(geo,'r') 
    n = open(new,'w') #on ouvre le fichier new pour ecrire dedans, ou on le cree s'il n'existe pas
    for ligne in g:
        for cle in m:
            if re.search(cle,ligne): #si la ligne contient la cle
                ligne = ligne.replace(cle, (m[cle])[i]) #on remplace la cle par la ieme valeur
        n.write(ligne) #on ecrit la ligne dans le fichier new
    g.close()
    n.close()






def recup_VM(csv) :
    
    p = open(csv,'r')
    for ligne in p:
        r = re.search('.*([0-9]\.[0-9]*E\+[0-9]*)',ligne) #la valeur est stockee sous la forme '     1.2345...E+123  ' dans les fichiers csv
        if r:
            p.close()
            return r.group(1) #on renvoie la valeur
    else : #si l'on a rien renvoye a la fin du for
        p.close()
        return 0



main()
