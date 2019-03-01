clear all
close all
clc

M = [2 -1 0
    -1 2 -1
    0 -1 2];

[L,U] = lu(M);

b = [1 2 3];

x = ex2_qu4(M,b)