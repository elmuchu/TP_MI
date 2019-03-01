clear all;
close all;
clc;

A  = imread('image_2.jpg');
A = double(A);
[j k n] = size(A);

p = j/10;
m = k/10;

for i=1:p
    for h=1:m
        for e=1:n
            M = 0;
            for g=10*(i-1)+1:10*(i-1)+10
                for f=10*(h-1)+1:10*(h-1)+10
                    M = M + A(g,f,e);
                end;
            end;
            B(i,h,e) = M/100;
        end;
    end;
end;

imshow(uint8(B));