function x = ex2_qu3 (U,b)

x(length(U)) = b(length(U))./U(length(U),length(U));

for i=length(U)-1:-1:1
    x(i) = (b(i)-sum(U(i,length(U):-1:i+1).*x(length(U):-1:i+1)))./U(i,i);
end

end