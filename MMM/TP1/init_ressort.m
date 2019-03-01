function [m,k]=init_ressort(N)
%INIT_RESSORT La commande
%   [m,k]=init_ressort(N)
%  choisit de manière aléatoire une chaîne de N ressorts reliant
%  N masses
%  Les masses sont comprises entre 1 et 2 et les raideurs entre 0.5 et 1.5.
m=1+rand(N,1); k=0.5+rand(N,1);