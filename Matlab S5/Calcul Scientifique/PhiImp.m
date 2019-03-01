function PhiImp = PhiImp (y,t,x,m)

if m==2         %Euler Implicite
    PhiImp = Y(t,x);
elseif m==3     %Crank Nicolson
    PhiImp = 0.5*(Y(t,y) + Y(t,x));
end;

end