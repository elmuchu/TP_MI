# -*- coding:Utf-8 -*-

#fct qui renvoie le premier element d'une liste
def takeFirst(elem):
    return elem[0]

# getting data from pre
import pickle

with open('pre_data.pickle','rb') as f:
  pre_data = pickle.load( f )


dim         = pre_data[0]
rcell       = pre_data[1]
rparoi      = pre_data[2]
list_sph_paroi = pre_data[3]
dist_ini        = pre_data[4]
list_sph_cyto = pre_data[5]


from pylmgc90 import chipy
import numpy as np
import shutil

#variables de controle
iter_ajout = 15
dist_max = 3.7*rparoi #1.5*dist_ini
r_add_cyto = 0.2*rcell
dist_norm = 0.3
proba_div = 0.2
paroi_max = 25

# modeling hypothesis ( 1 = plain strain, 2 = plain stress, 3 = axi-symmetry)
mhyp = 0
# time evolution parameters
tmax = 200
dt = 1.e-1
nb_steps = int(tmax/dt)
# theta integrator parameter
theta = 0.5
# deformable  yes=1, no=0
deformable = 0
# interaction parameters
freq_detect = 1
Rloc_tol = 5.e-2
# nlgs parameters
tol = 1e-4
relax = 1.0
norm = 'Quad'
gs_it1 = 200
gs_it2 = 10
solver_type='Stored_Delassus_Loops'  
# write parameter
freq_write = 1
n_write_final = nb_steps//freq_write
restart_write = nb_steps//freq_write
# display parameters
freq_display = 1
restart_display = nb_steps//freq_display
ref_radius = 1.e0

# restart count:
ii = 0

chipy.Initialize()
chipy.checkDirectories()

chipy.nlgs_3D_DiagonalResolution()

# Set space dimension
chipy.SetDimension(dim,mhyp)
#
chipy.utilities_logMes('INIT TIME STEPPING')
chipy.TimeEvolution_SetTimeStep(dt)
chipy.Integrator_InitTheta(theta)
#
chipy.utilities_logMes('READ BEHAVIOURS')
chipy.ReadBehaviours()
if deformable: chipy.ReadModels()
#
chipy.utilities_logMes('READ BODIES')
chipy.ReadBodies()
#    
chipy.utilities_logMes('LOAD BEHAVIOURS')
chipy.LoadBehaviours()
if deformable: chipy.LoadModels()
#
chipy.utilities_logMes('LOAD TACTORS')
chipy.LoadTactors()
#
chipy.utilities_logMes('READ DRIVEN DOF')
chipy.ReadDrivenDof()
#
chipy.utilities_logMes('READ INI')
if ii==0:
    chipy.ReadIniDof()
    chipy.ReadIniVlocRloc()
    if deformable:
        chipy.ReadIniGPV()
else:
    chipy.ReadIniDof(ii*restart_write)
    chipy.ReadIniVlocRloc(ii*restart_write)
    if deformable:
        chipy.ReadIniGPV(ii*restart_write)


#rend invisible les spheres
for i in list_sph_paroi:
    if i[2]==-1:
        chipy.RBDY3_SetInvisible(i[0])
        
for i in list_sph_cyto : 
    if i[1]==-1:
        chipy.RBDY3_SetInvisible(i[0])
        

chipy.utilities_logMes('WRITE BODIES')
chipy.WriteBodies()
chipy.utilities_logMes('WRITE BEHAVIOURS')
chipy.WriteBehaviours()
chipy.utilities_logMes('WRITE DRIVEN DOF')
chipy.WriteDrivenDof()

chipy.utilities_logMes('DISPLAY & WRITE')
if ii==0:
    chipy.OpenDisplayFiles()
else:
    chipy.OpenDisplayFiles(ii*restart_display+1)
chipy.OpenPostproFiles()

chipy.utilities_logMes('COMPUTE MASS')
chipy.ComputeMass()
    
#lecture fichier de relations
chipy.PTPT3_LoadNetwork()

#initialisation list_cell
list_cell = []
list_paroi = []
for i in list_sph_paroi :
    if i[2]==1:
        list_paroi.append(i[0])
cdg = [0.,0.,0.,0.,0.,0.]
list_cell.append([1, list(list_paroi), 0, list(cdg), [-1.,-1.,-1.]])
nb_cell=1

#initialisation listes temporaires
list_line = []
list_ajout = []


for k in range(0,nb_steps):
    
    #ajout sph cytoplasme
    if (k % iter_ajout) == 0:
        for j in list_cell :
            if j[2]==0 :
                id_cyto_ajout = list_sph_cyto.index(next(x for x in list_sph_cyto if x[1]==-1))
                pos_ajout = j[3]
                chipy.RBDY3_PutBodyVector("Coor0", list_sph_cyto[id_cyto_ajout][0], pos_ajout)
                list_sph_cyto[id_cyto_ajout][1]=1
                chipy.RBDY3_SetVisible(list_sph_cyto[id_cyto_ajout][0])
        
    chipy.utilities_logMes('INCREMENT STEP')
    chipy.IncrementStep()

    chipy.utilities_logMes('COMPUTE Fext')
    chipy.ComputeFext()
    
    chipy.utilities_logMes('COMPUTE Fint')
    chipy.ComputeBulk()
    
    #DIVISION
    for j in list_cell :
        if j[2]==1 :
            id_div_1 = j[4][1]-1
            id_div_2 = j[4][2]-1
            pos1 = chipy.RBDY3_GetBodyVector("Coorb", list_sph_paroi[id_div_1][0])
            pos2 = chipy.RBDY3_GetBodyVector("Coorb", list_sph_paroi[id_div_2][0])
            dist_division = ((pos1[0]-pos2[0])**2+(pos1[1]-pos2[1])**2)**0.5
            vectD = (pos2-pos1)/dist_division #vecteur directeur unitaire
            
            if dist_division > dist_ini : #imposition force division
                chipy.RBDY3_PutBodyVector("Fext_", list_sph_paroi[id_div_1][0], 1.e3*vectD*dist_division*(j[4][0]**2))
                chipy.RBDY3_PutBodyVector("Fext_", list_sph_paroi[id_div_2][0], -1.e3*vectD*dist_division*(j[4][0]**2))
                j[4][0] = j[4][0]+1
            
            else : #DEBUT SEPARATION
                vectN = [-vectD[1], vectD[0], 0, 0, 0, 0] #vecteur normal unitaire
                list_ajout[:] = []
                list_paroi_ini = list(j[1])
                
                for i in [id_div_1, id_div_2]:
                    pos = chipy.RBDY3_GetBodyVector("Coorb", list_sph_paroi[i][0])
                    file = open('DATBOX/PTPT3_NETWORK.DAT','r')
                    list_line[:] = []
                    
                    #cherche lignes de relations ou sph apparait
                    for line in file:
                        linefile = line.split(' ')
                        if linefile[0] == list_sph_paroi[i][1] or linefile[1] == list_sph_paroi[i][1]:
                            list_line.append(line)
                    file.close()
                    
                    #pour chaque relation trouvee
                    for linefile in list_line:
                        line = linefile.split(' ')
                        #recuperation sphere invisible
                        id_paroi_ajout = list_sph_paroi.index(next(x for x in list_sph_paroi if x[2]==-1))
                        #recuperation numero sphere a cote et range par ordre croissant
                        if line[0] == list_sph_paroi[i][1]:
                            numCote = int(line[1])-1
                        else:
                            numCote = int(line[0])-1
                        
                        #positionnnement nouvelle sphere
                        pos2 = chipy.RBDY3_GetBodyVector("Coorb", list_sph_paroi[numCote][0])
                        vect12 = pos2 - pos #vecteur sph_centr->sph_cote
                        c = (vect12[0]*vectN[0]+vect12[1]*vectN[1])
                        vect1N = [c*vectN[0], c*vectN[1], 0, 0, 0, 0] #projection sur la normale
                        posN = [pos[0]+vect1N[0], pos[1]+vect1N[1], 0, 0, 0, 0]
                        chipy.RBDY3_PutBodyVector("Coor0", list_sph_paroi[id_paroi_ajout][0], posN)
                        #rendre visible
                        list_sph_paroi[id_paroi_ajout][2] = 1 
                        chipy.RBDY3_SetVisible(list_sph_paroi[id_paroi_ajout][0])  
                        
                        #stockage sph ajoutee + cote de la normale
                        list_ajout.append([id_paroi_ajout, c])
                        
                        #reecriture du fichier
                        if id_paroi_ajout > numCote :
                            new_line = str(list_sph_paroi[numCote][1]) + ' ' + str(list_sph_paroi[id_paroi_ajout][1]) +' 0 0 0 ' + str(dist_ini) + '\n'
                        else :
                            new_line = str(list_sph_paroi[id_paroi_ajout][1]) + ' ' + str(list_sph_paroi[numCote][1]) +' 0 0 0 ' + str(dist_ini) + '\n'
                        file = open('DATBOX/PTPT3_NETWORK.DAT','a')
                        file.write(new_line)
                        file.close()
                        
                        #ajout dans la liste des spheres de paroi de la cellule
                        list_paroi_temp = list(j[1])
                        index_i = list_paroi_temp.index(i+1)
                        index_cote = list_paroi_temp.index(numCote+1)
                        if index_cote < index_i :
                            list_paroi_temp.insert(index_i,list_sph_paroi[id_paroi_ajout][0])
                        else:
                            list_paroi_temp.insert(index_cote,list_sph_paroi[id_paroi_ajout][0])
                        j[1]=list(list_paroi_temp)
                        
                            
                #rearrangement liste sph ajoutee dans lordre [[1,X],[2,Y]...]
                list_ajout = sorted(list_ajout, key=takeFirst)
                id1 = list_ajout[0][0]
                if np.sign(list_ajout[0][1]) == np.sign(list_ajout[1][1]): #si les 2 sont du mm cote de la normale
                    id2 = list_ajout[1][0]
                    id3 = list_ajout[2][0]
                    id4 = list_ajout[3][0]
                elif np.sign(list_ajout[0][1]) == np.sign(list_ajout[2][1]):
                    id2 = list_ajout[2][0]
                    id3 = list_ajout[1][0]
                    id4 = list_ajout[3][0]
                else :
                    id2 = list_ajout[3][0]
                    id3 = list_ajout[1][0]
                    id4 = list_ajout[2][0]
                #ecriture relations sphs de chaque cote
                new_line1 = str(list_sph_paroi[id1][1]) + ' ' + str(list_sph_paroi[id2][1]) +' 0 0 0 ' + str(dist_ini) + '\n'
                new_line2 = str(list_sph_paroi[id3][1]) + ' ' + str(list_sph_paroi[id4][1]) +' 0 0 0 ' + str(dist_ini) + '\n'
                file = open('DATBOX/PTPT3_NETWORK.DAT','a')
                file.write(new_line1)
                file.write(new_line2)
                file.close()
                
                #reecriture fichier relations
                file_old = open('DATBOX/PTPT3_NETWORK.DAT','r')
                file_new = open('DATBOX/PTPT3_NETWORK_NEW.DAT','w')
                for line in file_old :
                    if line not in list_line : #on ne copie que les lignes a garder
                        file_new.write(line)
                file_old.close()
                file_new.close()
                shutil.copy('DATBOX/PTPT3_NETWORK_NEW.DAT', 'DATBOX/PTPT3_NETWORK.DAT') #remplacement fichier
                #reset fichier relations
                chipy.utilities_logMes('RESET PTPT3 DETECTION')
                chipy.PTPT3_SelectProxTactors(1)
                #rend invisible les anciennes spheres
                for i in [id_div_1,id_div_2] :
                    chipy.RBDY3_SetInvisible(list_sph_paroi[i][0])
                    posb = chipy.RBDY3_GetBodyVector("Coorb", list_sph_paroi[i][0])
                    pos0 = chipy.RBDY3_GetBodyVector("Coor0", list_sph_paroi[i][0])
                    chipy.RBDY3_PutBodyVector("Coor0", list_sph_paroi[i][0], pos0-posb)
                    list_sph_paroi[i][2] = 0 #PB si les sphs sont reutilisees (mauvais positionnement) -> invisibilte = 0 pour eviter ca
                
                #creation des nvls listes sphs
                list_paroi_temp = list(j[1])
                list_paroi_temp.remove(j[4][1])
                list_paroi_temp.remove(j[4][2])
                index1 = next(list_paroi_temp.index(x) for x in list_paroi_temp if x not in list_paroi_ini)+1
                index2 = next(list_paroi_temp.index(x) for x in list_paroi_temp if (x not in list_paroi_ini) and list_paroi_temp.index(x)>index1 )+1
                list_paroi_temp1 = list_paroi_temp[:index1]
                list_paroi_temp2 = list_paroi_temp[index1:index2]
                list_paroi_temp3 = list_paroi_temp[index2:]
                nvl_list1 = list_paroi_temp1 + list_paroi_temp3
                nvl_list2 = list_paroi_temp2
                #mise a jour de list_cell
                nb_cell = nb_cell+1
                list_cell.append([nb_cell, list(nvl_list1), 0, [0.,0.,0.,0.,0.,0.], [-1.,-1.,-1.] ])
                j[1] = list(nvl_list2)
                j[2] = 0
                j[4] = list([-1.,-1.,-1.])
                #fin division
    #FIN DIVISION
                    
    

    chipy.utilities_logMes('COMPUTE Free Vlocy')
    chipy.ComputeFreeVelocity()

    chipy.utilities_logMes('SELECT PROX TACTORS')
    chipy.SelectProxTactors(freq_detect)

    chipy.utilities_logMes('RESOLUTION' )
    chipy.RecupRloc(Rloc_tol)

    chipy.ExSolver(solver_type, norm, tol, relax, gs_it1, gs_it2)
    chipy.UpdateTactBehav()

    chipy.StockRloc()

    chipy.utilities_logMes('COMPUTE DOF, FIELDS, etc.')
    chipy.ComputeDof()
        
    chipy.utilities_logMes('UPDATE DOF, FIELDS')
    chipy.UpdateStep()

    chipy.utilities_logMes('WRITE OUT DOF')
    chipy.WriteOutDof(freq_write)
    chipy.utilities_logMes('WRITE OUT Rloc')
    chipy.WriteOutVlocRloc(freq_write)

    chipy.utilities_logMes('VISU & POSTPRO')
    chipy.WriteDisplayFiles(freq_display,ref_radius)
    chipy.WritePostproFiles()
    
    #determination si lancement de division ou non
    for j in range(len(list_cell)):
        if len(list_cell[j][1])>paroi_max and list_cell[j][2]==0:
            chance_div = np.random.rand()
            if chance_div > proba_div: #si division acceptee
                list_cell[j][2]=1
                id_rand = int(((len(list_cell[j][1])//2)-1)*np.random.rand())+1
                id_div_1 = list_cell[j][1][id_rand]
                id_div_2 = list_cell[j][1][id_rand+(len(list_cell[j][1])//2)]
                list_cell[j][4][0] = 0
                list_cell[j][4][1] = id_div_1
                list_cell[j][4][2] = id_div_2


    #CROISSANCE MEMBRANE
    for j in range(len(list_cell)):
        if list_cell[j][2] == 0 or list_cell[j][2] == 1: #si cellule est en croissance ou en division
            list_ajout[:] = []
            list_paroi_temp = list(list_cell[j][1])
            for i in range(len(list_paroi_temp)-1): #test de distance sur tous les couples
                pos1 = chipy.RBDY3_GetBodyVector("Coor_", list_sph_paroi[list_paroi_temp[i]-1][0])
                pos2 = chipy.RBDY3_GetBodyVector("Coor_", list_sph_paroi[list_paroi_temp[i+1]-1][0])
                dist_att = ((pos1[0]-pos2[0])**2+(pos1[1]-pos2[1])**2)**0.5
                if dist_att > dist_max : #si la distance est trop grande
                    list_ajout.append([i,pos1,pos2])
                    break
            pos1 = chipy.RBDY3_GetBodyVector("Coor_", list_sph_paroi[list_paroi_temp[len(list_paroi_temp)-1]-1][0])
            pos2 = chipy.RBDY3_GetBodyVector("Coor_", list_sph_paroi[list_paroi_temp[0]-1][0])
            dist_att = ((pos1[0]-pos2[0])**2+(pos1[1]-pos2[1])**2)**0.5
            #if dist_att > dist_max : 
                #list_ajout.append([len(list_paroi_temp)-1,pos1,pos2])
            #FORMAT A REFAIRE
            
            for i in range(len(list_ajout)): #pour chaque couple trouve
                num_sph1 = list_paroi_temp[list_ajout[i][0]] #recuperation num sphs
                if list_ajout[i][0] == len(list_paroi_temp)-1 :
                    num_sph2 = list_paroi_temp[0]
                else:
                    num_sph2 = list_paroi_temp[list_ajout[i][0]+1]
                        
                #creation et positionnement nvl sphere
                id_paroi_ajout = list_sph_paroi.index(next(x for x in list_sph_paroi if x[2]==-1))
               
                pos1 = list_ajout[i][1]
                pos2 = list_ajout[i][2]
                vectD = pos2-pos1
                ptMilieu = (pos1+pos2)/2
                vectN = [-vectD[1]*dist_norm, vectD[0]*dist_norm, 0, 0, 0, 0] #vecteur normal
                pos_norm1 = [ptMilieu[0]+vectN[0], ptMilieu[1]+vectN[1],0,0,0,0,]
                pos_norm2 = [ptMilieu[0]-vectN[0], ptMilieu[1]-vectN[1],0,0,0,0,]
                distCDM1 = ((pos_norm1[0]-cdg[0])**2+(pos_norm1[1]-cdg[1])**2)**0.5
                distCDM2 = ((pos_norm2[0]-cdg[0])**2+(pos_norm2[1]-cdg[1])**2)**0.5
                if distCDM1 > distCDM2: #choix normale sortante
                    pos_norm = pos_norm1
                else:
                    pos_norm = pos_norm2
                chipy.RBDY3_PutBodyVector("Coor0", list_sph_paroi[id_paroi_ajout][0], pos_norm)
                #rend visible
                list_sph_paroi[id_paroi_ajout][2]=1
                chipy.RBDY3_SetVisible(list_sph_paroi[id_paroi_ajout][0]) 
                
                #modification liste paroi
                list_paroi_temp.insert(list_ajout[i][0]+1,list_sph_paroi[id_paroi_ajout][0])
                list_cell[j][1]=list(list_paroi_temp)
                
                #cherche ligne de relations ou les 2 sph apparaissent
                file = open('DATBOX/PTPT3_NETWORK.DAT','r')
                for line in file:
                    linefile = line.split(' ')
                    if (linefile[0] == list_sph_paroi[num_sph1-1][1] or linefile[1] == list_sph_paroi[num_sph1-1][1]) and (linefile[0] == list_sph_paroi[num_sph2-1][1] or linefile[1] == list_sph_paroi[num_sph2-1][1]):
                        line_rel = line
                        break
                file.close()
                
                #tri lignes ordre croissant
                line = line_rel.split(' ')
                if id_paroi_ajout > int(line[0])-1:
                    new_line1 = str(list_sph_paroi[int(line[0])-1][1]) + ' ' + str(list_sph_paroi[id_paroi_ajout][1]) +' 0 0 0 ' + str(dist_ini) + '\n'
                    if id_paroi_ajout > int(line[1])-1:
                        new_line2 = str(list_sph_paroi[int(line[1])-1][1]) + ' ' + str(list_sph_paroi[id_paroi_ajout][1]) +' 0 0 0 ' + str(dist_ini) + '\n'
                    else :
                        new_line2 = str(list_sph_paroi[id_paroi_ajout][1]) + ' ' + str(list_sph_paroi[int(line[1])-1][1]) +' 0 0 0 ' + str(dist_ini) + '\n'
                else :
                    new_line1 = str(list_sph_paroi[id_paroi_ajout][1]) + ' ' + str(list_sph_paroi[int(line[0])-1][1]) +' 0 0 0 ' + str(dist_ini) + '\n'
                    new_line2 = str(list_sph_paroi[id_paroi_ajout][1]) + ' ' + str(list_sph_paroi[int(line[1])-1][1]) +' 0 0 0 ' + str(dist_ini) + '\n'
                    
                #ecriture lignes
                file = open('DATBOX/PTPT3_NETWORK.DAT','a')
                file.write(new_line1)
                file.write(new_line2)
                file.close()
                
                #reecriture fichier relations
                file_old = open('DATBOX/PTPT3_NETWORK.DAT','r')
                file_new = open('DATBOX/PTPT3_NETWORK_NEW.DAT','w')
                for line in file_old :
                    if line != line_rel : #on ne copie que les lignes a garder
                        file_new.write(line)
                file_old.close()
                file_new.close()
                shutil.copy('DATBOX/PTPT3_NETWORK_NEW.DAT', 'DATBOX/PTPT3_NETWORK.DAT') #remplacement fichier
                #reset fichier relations
                chipy.utilities_logMes('RESET PTPT3 DETECTION')
                chipy.PTPT3_SelectProxTactors(1)
            #fin pour chaque couple
    #FIN CROISSANCE MEMBRANE

    #calcul CDG cellules
    for j in range(len(list_cell)) :
        cdg = [0,0,0,0,0,0]
        list_paroi = list(list_cell[j][1])
        for i in list_paroi:
            cdg+=chipy.RBDY3_GetBodyVector("Coor_", i)
        cdg = cdg/len(list_paroi)
        list_cell[j][3] = list(cdg)
    
    
#FIN BOUCLE CALCUL

    
chipy.CloseDisplayFiles()
chipy.ClosePostproFiles()
chipy.Finalize()

