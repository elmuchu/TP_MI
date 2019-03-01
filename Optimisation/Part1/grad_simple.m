function xfin = grad_simple(fun)

global x0 kmax thresh

x(:,1) = x0+2*thresh*ones(size(x0));
x(:,2) = x0;
k = 2;

while (norm((x(:,k)-x(:,k-1)))>thresh && k<kmax)
    [~,df,H] = fun(x(:,k));
    d(:,k) = -df;
    t_toile(k) = -transpose(df)*d(:,k) / (transpose(d(:,k))*H*d(:,k));
    x(:,k+1) = x(:,k) + t_toile(k)*d(:,k);
    k = k+1;
end

xfin = x(:,[2:k]);

end