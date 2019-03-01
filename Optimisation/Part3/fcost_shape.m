function U = fcost_shape(a)

global theta_p Rf L

U = 0.5*integral(@(s)(Rf*(theta_p(s,a).^2)),0,L);

end