function xfin = grad_conj(fun)

global x0 kmax thresh

x(:,1) = x0+2*thresh*ones(size(x0));
x(:,2) = x0;
k = 2;

[~,df,H] = fun(x(:,2));
d(:,2) = -df;

while (norm(d(:,k))>thresh && k<kmax)
    t_toile(k) = -transpose(df)*d(:,k) / (transpose(d(:,k))*H*d(:,k));
    x(:,k+1) = x(:,k) + t_toile(k)*d(:,k);
    [~,df,H] = fun(x(:,k+1));
    beta(k) = (transpose(d(:,k))*H*df) / (transpose(d(:,k))*H*d(:,k));
    d(:,k+1) = -df+beta(k)*d(:,k);
    k = k+1;
end

xfin = x(:,[2:k]);

end