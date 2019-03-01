function Wex = Wex(t,x)

ul = 0; ur = 0;
hl = 2; hr = 1;
g = 9.81;

F = @(h)(ul-ur+2*sqrt(g)*(sqrt(hl)-sqrt(h))+(hr-h)*sqrt((g*(h+hr))/(2*h*hr)));
Fprime = @(h)(-sqrt(g/h)-sqrt((g*(h+hr))/(2*h*hr))+0.5*(hr-h)*sqrt((2*h*hr)/(g*(h+hr))));

%methode secante
% emax = 0.01; imax = 10; i = 0;
% htoile1 = hl; htoile2 = hr;
% while i<imax && abs(F(htoile2))>emax
%     htoile = htoile2 - (htoile2-htoile1)*F(htoile2)/(F(htoile2)-F(htoile1));
%     htoile1 = htoile2; htoile2 = htoile;
%     i = i+1;
% end

%methode newton
emax = 0.01; imax = 10; i = 0;
htoile = hl;
while i<imax && abs(F(htoile))>emax
    htoile = htoile - F(htoile)/Fprime(htoile);
    i = i+1;
end

utoile = ul+2*sqrt(g)*(sqrt(hl)-sqrt(htoile));

Wex = zeros(2,length(x));
for j=1:length(x)
    
    if x(j) < (ul-sqrt(g*hl)*t)
        Wex(:,j) = [hl
            ul];
    elseif x(j) > (ul-sqrt(g*hl)*t) && x(j) < (utoile-sqrt(g*htoile))*t
        Wex(:,j) = [((ul+2*sqrt(g*hl)-x(j)/t).^2)/(9*g)
            (ul+2*sqrt(g*hl)+2*x(j)/t)/3];
    elseif x(j) > (utoile-sqrt(g*htoile))*t && x(j) < (utoile + hr*sqrt((g*(htoile+hr))/(2*htoile*hr)))*t
        Wex(:,j) = [htoile
            utoile];
    else
        Wex(:,j) = [hr
            ur];
    end
end

end