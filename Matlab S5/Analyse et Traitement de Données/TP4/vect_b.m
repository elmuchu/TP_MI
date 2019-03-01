function b = vect_b(X,F,liste)

b = zeros(length(liste),1); %creation du vecteur b

for j=1:length(liste)
    b(j) = integrale(X,F.*eval(liste{j})); %produit scalaire de F,Bj
end

end

