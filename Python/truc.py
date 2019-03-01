import re, sys, subprocess


def main() :
        old = "D:/Users/Max/Desktop/Cours/MI/Semestre_7/Python/sphere.inp"
        new = old.strip('.inp')+'_new.inp'
        g = open(old,'r') 
        n = open(new,'w') 
        a = False
        for ligne in g:
                if re.search('#EXACT_SOLUTION',ligne):
                        a = False
                if a :
                        l = []
                        r = ligne
                        l = r.split(',')
                        if len(l) == 6 :
                                if l[5].split(' -') == l[5].split(' ') :
                                        l[5] = ' -'+l[5].replace(' ',"")
                                else :
                                        l[5] = ' '+l[5].replace(' -',"")
                        elif len(l) == 8 :
                                if l[5].split(' -') == l[5].split(' ') :
                                        l[5] = ' -'+l[5].replace(' ',"")
                                else :
                                        l[5] = ' '+l[5].replace(' -',"")
                                if l[7].split(' -') == l[7].split(' ') :
                                        l[7] = ' -'+l[7].replace(' ',"")
                                else :
                                        l[7] = ' '+l[7].replace(' -',"")
                        elif len(l) == 10 :
                                if l[5].split(' -') == l[5].split(' ') :
                                        l[5] = ' -'+l[5].replace(' ',"")
                                else :
                                        l[5] = ' '+l[5].replace(' -',"")
                                if l[7].split(' -') == l[7].split(' ') :
                                        l[7] = ' -'+l[7].replace(' ',"")
                                else :
                                        l[7] = ' '+l[9].replace(' -',"")
                                if l[9].split(' -') == l[9].split(' ') :
                                        l[9] = ' -'+l[9].replace(' ',"")
                                else :
                                        l[9] = ' '+l[9].replace(' -',"")
                                #if l[9].split('-') == l[9] :
                                #        ligne = ligne.replace(l[9],l[9].split('-'))
                                #else :
                                #        ligne = ligne.replace(l[9],'-'+l[9])
                        m = ""
                        m = m + l[0]
                        print(l)
                        for i in range(1,len(l)-1) :
                                m = m + ', ' + l[i].replace("\n","")
                        m = m + ', ' + l[len(l)-1]
                        ligne = m
                if re.search('#BOUNDARY_NEUMANN',ligne):
                        a = True
                n.write(ligne) #on ecrit la ligne dans le fichier new
        g.close()
        n.close()


main()
