function x = ex2_qu2 (L,b)

x(1) = b(1)./L(1,1);

for i=2:length(L)
    x(i) = (b(i)-sum(L(i,1:i-1).*x(1:i-1)))./L(i,i);
end

end