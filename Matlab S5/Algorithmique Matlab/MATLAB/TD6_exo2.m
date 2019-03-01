clear all;
close all;
clc;

N = textread('Nioh2Raman.txt');
[k j] = size(N);

l = mean(N(1:100,2));
b = std(N(1:100,2));
r = l/b;
n(:,2) = N(:,2)-l;
n(:,1) = N(:,1);