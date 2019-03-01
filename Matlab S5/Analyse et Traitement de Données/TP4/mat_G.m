function G = mat_G(X,liste)

G = zeros(length(liste));  %creation de la matrice G

for i=1:length(liste)
    for j=1:length(liste)
        Bi = eval(liste{i}); %vecteur Bi
        Bj = eval(liste{j}); %vecteur Bj
        V = Bi.*Bj;  %vecteur Bi*Bj
        G(i,j) = integrale(X,V); %produit scalaire de Bi,Bj
    end
end

end