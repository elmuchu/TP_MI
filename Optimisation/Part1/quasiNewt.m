function xfin = quasiNewt(f1)

global x0 kmax thresh

x(:,1) = x0+2*thresh*ones(size(x0));
x(:,2) = x0;
[~,df,H] = f1(x(:,2));
k = 2;
S = eye(length(x0));

while (norm((x(:,k)-x(:,k-1)))>thresh && k<kmax)
    d(:,k) = -S*df;
    t_toile(k) = -transpose(df)*d(:,k) / (transpose(d(:,k))*H*d(:,k));
    x(:,k+1) = x(:,k)+t_toile(k)*d(:,k);
    [~,dfe,He] = f1(x(:,k+1));
    gamma = dfe-df;
    delta = x(:,k+1)-x(:,k);
    S = S + (gamma*transpose(gamma))/(transpose(gamma)*delta) - S*delta*transpose(delta)*S/(transpose(delta)*S*delta); %BFGS
    df = dfe; H = He;
    k = k+1;
end

xfin = x;

end