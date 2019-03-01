function x = ex2_qu4 (A,b)

[L,U] = lu(A);

y = ex2_qu2(L,b);
x = ex2_qu3(U,y);

%x = ex2_qu3(U,ex2_qu2(L,b));

end