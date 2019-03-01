function t = suiv(k,l,m)

if (k==0 & l==0 & m==0) | (k==1 & l==0 & m==1) | (k==0 & l==1 & m==0) | (k==0 & l==1 & m==1)
    t = true;
else
    t = false;
end;
