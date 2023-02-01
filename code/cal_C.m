
function C = cal_C (beta,L,m)

Fint = (L*cos(L*beta)^2 - sin(L*beta)*(cos(L*beta*1i)/beta + (cos(L*beta)*cos(L*beta*1i)^2)/beta) ...
    + L*cos(L*beta*1i)^2 + (cos(L*beta)*sin(L*beta*1i)*1i)/beta + 2*L*cos(L*beta)*cos(L*beta*1i) ...
    + (cos(L*beta)^2*cos(L*beta*1i)*sin(L*beta*1i)*1i)/beta)/(sin(L*beta) + sin(L*beta*1i)*1i)^2;

C = sqrt(1/m/Fint); 

% % symbolic integrations for the normalisation constant 
% syms x beta L 
% 
% phi_x = (1./(sin(beta*L) - sinh(beta*L))).*...
%                 ((sin(beta*L) - sinh(beta*L)).*(sin(beta*x) - sinh(beta*x)) + ...
%                 (cos(beta*L) + cosh(beta*L)).*(cos(beta*x) - cosh(beta*x)));
% 
% f = phi_x^2;
% 
% f1 = (sin(beta*x) - sinh(beta*x))^2;
% f2 = (cos(beta*x) - cosh(beta*x))^2;
% 
% F1 = int(f1,x,[0 L]);
% F2 = int(f2,x,[0 L]);
% 
% F = int(f,x,[0 L]);



