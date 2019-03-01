clear all;
close all;
clc;

A  = imread('image_1.jpg');
A = double(A);
[j k] = size(A);

M = 0;
for i=1:j
    for l=1:k
        M = M + A(i,l);
    end;
end;
M = M/(j*k);

for i=1:j
    for l=1:k
        if A(i,l)<M
            B(i,l) = 0;
        else
            B(i,l) = 1;
        end;
    end;
end;

for i=1:j
    for l=1:k
        A(i,l) = A(i,l)*B(i,l);
    end;
end;

A = uint8(A);
imshow(A);