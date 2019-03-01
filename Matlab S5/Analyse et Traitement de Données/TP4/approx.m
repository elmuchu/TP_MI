function alpha = approx(X,f,d)

liste = {}; %creation de la base B ou Bi=X^i
for i=0:d
    liste = {liste{:} strcat('X.^',num2str(i))};
end

G = mat_G(X,liste); %calcul de la matrice G
b = vect_b(X,f,liste); %calcul du vecteur b

alpha1 = linsolve(G,b); %resolution du systeme G*alpha1 = b

%alpha1 renvoyait les coefficients du polynome caracteristique de la
%fonction mais a l'envers (si f(x) = a*x^2 + b*x + c, alpha1 = [c b a])
%il a donc fallu l'inverser (boucle for suivante)

for i=1:d+1
    alpha(i) = alpha1(d+2-i);
end

end