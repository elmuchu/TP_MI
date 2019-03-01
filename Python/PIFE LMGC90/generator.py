# -*- coding:Utf-8 -*-

import os
import math
import numpy as np
import shutil

from pylmgc90 import pre

if not os.path.isdir('DATBOX'):
    os.mkdir('DATBOX')

dim = 3

bodies = pre.avatars()

mat   = pre.materials()
svs   = pre.see_tables()
tacts = pre.tact_behavs()


#create materials
memb = pre.material(name='MEMBx',materialType='RIGID',density=1000.)
cyto = pre.material(name='CYTOx',materialType='RIGID',density=1000.)
mat.addMaterial(memb,cyto)

# create a model of rigid
mod = pre.model(name='rigid', physics='MECAx', element='Rxx3D', dimension=dim)

# propriétes
stiff_paroi = 1.e8
visc_paroi  = 1.e7  
stiff_cyto = 1.e7
stiff_cytoparoi = 1.e6

# rayons
rcell  = 30.
rparoi = 4.
rcytomin = 6.
rcytomax = 12.
gap_ini = 1

#spheres a creer
nb_cyto = 1000
nb_paroi = 250


# calcul du nombre de sphere sur la paroi de la cellule
circ_cell = 2. * math.pi * rcell
nb_paroi_ini = int( circ_cell / (2*rparoi+gap_ini) )

#
list_sph_paroi = []

angle = 2. * math.pi / float( nb_paroi_ini )
#spheres paroi initiales
for i in range(nb_paroi_ini):
    spher = pre.rigidSphere( r=rparoi, center=[rcell,0.,0.], material=memb, model=mod, color='PAROI')
    spher.rotate(description='axis', alpha=i*angle, axis=[0., 0., 1.] , center=[0., 0., 0.])
    spher.addContactors('PT3Dx','PAROI')
    spher.imposeDrivenDof(component=3, dofty='vlocy')
    #spher.imposeDrivenDof(component=[1], dofty='force',ct=-200.)
    bodies.addAvatar(spher)
    list_sph_paroi.append([bodies.index(spher)+1,str(i+1).zfill(5),1])

#spheres paroi ajoutables
for i in range(nb_paroi-nb_paroi_ini):
    spher=pre.rigidSphere(r=rparoi, center=[0.,0.,0.], material=memb, model=mod, color='PAROI', number=None)
    spher.addContactors('PT3Dx','PAROI')
    spher.imposeDrivenDof(component=3, dofty='vlocy')
    bodies.addAvatar(spher)
    list_sph_paroi.append([bodies.index(spher)+1,str(nb_paroi_ini+i+1).zfill(5),-1])


#creation cytoplasme    
list_sph_cyto = []

r_list_sph_cyto=pre.granulo_Random(nb_cyto, rcytomin, rcytomax)

r_deposit_cyto = rcell-rparoi-rcytomax
[nb_cyto_ini, coor_sph_cyto]=pre.depositInDisk2D(r_list_sph_cyto, r_deposit_cyto, deposited_radii=None, deposited_coor=None)

#spheres cyto ini
for i in range(nb_cyto_ini):
    spher=pre.rigidSphere(r=r_list_sph_cyto[i], center=[coor_sph_cyto[2*i],coor_sph_cyto[2*i+1],0.], material=cyto, model=mod, color='CYTOx', number=None)
    spher.translate(dx=-r_deposit_cyto,dy=-r_deposit_cyto,dz=0.)
    spher.addContactors('SPHER','CYTO2',byrd=r_list_sph_cyto[i]) 
    spher.imposeDrivenDof(component=3, dofty='vlocy')
    bodies.addAvatar(spher)
    list_sph_cyto.append([bodies.index(spher)+1,1])
    
#spheres cyto ajoutables
r_list_sph_cyto=pre.granulo_Random(nb_cyto-nb_cyto_ini, rcytomin, rcytomax)
for i in range(nb_cyto-nb_cyto_ini):
    spher=pre.rigidSphere(r=r_list_sph_cyto[i], center=[0.,0.,0.], material=cyto, model=mod, color='CYTOx', number=None)
    spher.addContactors('SPHER','CYTO2',byrd=r_list_sph_cyto[i])
    spher.imposeDrivenDof(component=3, dofty='vlocy')
    bodies.addAvatar(spher)
    list_sph_cyto.append([bodies.index(spher)+1,-1])

#lois d'interaction
bl_pt3dx_paroi = pre.tact_behav(name='vgtr1', law='VOIGT_ROD', stiffness=stiff_paroi, prestrain=-0.01, viscosity = visc_paroi )
tacts += bl_pt3dx_paroi
bl_spher_paroi = pre.tact_behav(name='iqsc0', law='IQS_CLB', fric=0.1)
tacts += bl_spher_paroi
bl_spher_cyto  = pre.tact_behav(name='iqsc1', law='IQS_CLB', fric = 0.1)
tacts += bl_spher_cyto
bl_spher_cyto2 = pre.tact_behav(name='elrpl', law='ELASTIC_REPELL_CLB', stiffness=stiff_cyto, fric=0.1)
tacts += bl_spher_cyto2
bl_spher_cyto_paroi  = pre.tact_behav(name='iqsc2', law='IQS_CLB', fric = 0.1)
tacts += bl_spher_cyto_paroi
bl_spher_cyto_paroi2 = pre.tact_behav(name='elrp1', law='ELASTIC_REPELL_CLB', stiffness=stiff_cytoparoi, fric = 0.1)
tacts += bl_spher_cyto_paroi2

#distance d'activation
alert_spher_paroi = 1.e-2 * rparoi
alert_pt3dx_paroi = 4*rparoi
alert_spher_cyto  = 1.e-2 * rcytomax
alert_spher_cyto2 = 1.e-2 * rcytomax
alert_spher_cyto_paroi  = 1.e-2 * rcytomax
alert_spher_cyto_paroi2 = 1.e-2 * rcytomax

#relations
st_spher_paroi = pre.see_table(CorpsCandidat   ='RBDY3',candidat   ='SPHER', colorCandidat   ='PAROI',behav=bl_spher_paroi,
                               CorpsAntagoniste='RBDY3',antagoniste='SPHER', colorAntagoniste='PAROI',alert=alert_spher_paroi)
svs+=st_spher_paroi
st_pt3dx_paroi = pre.see_table(CorpsCandidat   ='RBDY3',candidat   ='PT3Dx', colorCandidat   ='PAROI',behav=bl_pt3dx_paroi,
                               CorpsAntagoniste='RBDY3',antagoniste='PT3Dx', colorAntagoniste='PAROI',alert=alert_pt3dx_paroi)
svs += st_pt3dx_paroi
st_spher_cyto  = pre.see_table(CorpsCandidat   ='RBDY3',candidat   ='SPHER', colorCandidat   ='CYTOx',behav=bl_spher_cyto,
                               CorpsAntagoniste='RBDY3',antagoniste='SPHER', colorAntagoniste='CYTOx',alert=alert_spher_cyto)
svs+=st_spher_cyto
st_spher_cyto2 = pre.see_table(CorpsCandidat   ='RBDY3',candidat   ='SPHER', colorCandidat   ='CYTO2',behav=bl_spher_cyto2,
                               CorpsAntagoniste='RBDY3',antagoniste='SPHER', colorAntagoniste='CYTO2',alert=alert_spher_cyto2)
svs+=st_spher_cyto2
st_spher_cyto_paroi  = pre.see_table(CorpsCandidat   ='RBDY3',candidat   ='SPHER', colorCandidat   ='PAROI',behav=bl_spher_cyto_paroi,
                                     CorpsAntagoniste='RBDY3',antagoniste='SPHER', colorAntagoniste='CYTOx',alert=alert_spher_cyto_paroi)
svs+=st_spher_cyto_paroi
st_spher_cyto_paroi2 = pre.see_table(CorpsCandidat   ='RBDY3',candidat   ='SPHER', colorCandidat   ='PAROI',behav=bl_spher_cyto_paroi2,
                                     CorpsAntagoniste='RBDY3',antagoniste='SPHER', colorAntagoniste='CYTO2',alert=alert_spher_cyto_paroi2)
svs+=st_spher_cyto_paroi2


#ecriture fichier liaisons
file = open('DATBOX/PTPT3_NETWORK.DAT','w')
dist_ini = rcell*(2-2*math.cos(angle))**0.5
for i in range(nb_paroi_ini-1):
    line = str(list_sph_paroi[i][1])+' '+str(list_sph_paroi[i+1][1])+' 0 0 0 '+ str(dist_ini)+'\n'
    file.write(line)
line = str(list_sph_paroi[0][1])+' '+str(list_sph_paroi[nb_paroi_ini-1][1])+' 0 0 0 '+str(dist_ini)+'\n'
file.write(line)
file.close()

#ecriture fichiers datbox
post = pre.postpro_commands()
pre.writePostpro(commands=post, parts=bodies, path='DATBOX/')

pre.writeBodies(bodies,chemin='DATBOX/')
pre.writeBulkBehav(mat,chemin='DATBOX/', gravy=[0., 0., 0.])
pre.writeTactBehav(tacts,svs,chemin='DATBOX/')
pre.writeDrvDof(bodies,chemin='DATBOX/')
pre.writeDofIni(bodies,chemin='DATBOX/')
pre.writeVlocRlocIni(chemin='DATBOX/')
#shutil.copy('PTPT3_NETWORK.DAT', 'DATBOX/PTPT3_NETWORK.DAT')    

#visualisation
pre.visuAvatars(bodies)

#transfert donnees
import pickle

pre_data = ( dim, rcell , rparoi, list_sph_paroi, dist_ini, list_sph_cyto
           )

with open('pre_data.pickle','wb') as f:
  pickle.dump( pre_data, f, pickle.HIGHEST_PROTOCOL)

