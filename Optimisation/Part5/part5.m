clc
clear all
close all

nelx = 60;      % nb elements horizontaux
nely = 30;      % nb elements verticaux
volfrac = 0.5;  % proportion volumique ( 0.001 < volfrac < 1 )
penal = 3;      % coefficient de penalisation ( 1 < penal )
rmin = 1.5;     % 'taille minimale' des barres de soutien

figure;
top(nelx,nely,volfrac,penal,rmin);

figure;
top_hole(nelx,nely,volfrac,penal,rmin);