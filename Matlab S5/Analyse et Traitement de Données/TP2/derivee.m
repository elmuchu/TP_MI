function [ds_dx] = derivee(t,s)

% méthode par differences finies schema amont ordre 1


for i=2:length(t)
ds_dx(i)=  ( s(i) - s(i-1) )/ ( t(i) - t(i-1) );
end

ds_dx(1)=  ( s(1) - s(length(t)) ) / ( t(1) - t(length(t)) ); % avec l'hypothese de périodicité de la fonction s

end