function Y = ma_fonction (X,beta)

Y = 0.5*(beta(1)+beta(2))+(beta(2)-beta(1))*atan((X-beta(3))./beta(4))./pi(); 

end