function yout = design_cb (xS,~)
% design_cb calculates the r.m.s response of hte cantilever beam subject to
% white noise excitation 

E = xS(1);
rho = xS(2);
L  =xS(3);
width =xS(4);
thickness = xS(5);

% L           = 0.45   ; % lenght [m]

% width       = 2e-2   ; % width [m]
% thickness   = 2e-3   ; % thickness [m]

zeta = 0.1;

m = rho*width*thickness ; 
I = 1/12*width*thickness^3;

Nmode = 3; 
beta_v =[1.875 ;  4.694 ; 7.855]/L; 



Nom = 1000; 
om = linspace(0,2e3,Nom).';

xf = L/2; 
Nx = 50; 
xr = linspace(0,L,Nx);

FRF_dis = zeros(Nom,Nx);
FRF_str = zeros(Nom,Nx);
for ii = 1 : Nmode

    beta = beta_v(ii);


    % natural frequency
    om_n = (beta*L)^2*sqrt(E*I/(m*L^4));

    C = 1;

    % displacement
    phi_x =  (1./(sin(beta*L) - sinh(beta*L))).*...
            ((sin(beta*L) - sinh(beta*L)).*(sin(beta*xr) - sinh(beta*xr)) + ...
            (cos(beta*L) + cosh(beta*L)).*(cos(beta*xr) - cosh(beta*xr)));

    phi_y =  (1./(sin(beta*L) - sinh(beta*L))).*...
            ((sin(beta*L) - sinh(beta*L)).*(sin(beta*xf) - sinh(beta*xf)) + ...
            (cos(beta*L) + cosh(beta*L)).*(cos(beta*xf) - cosh(beta*xf)));

    FRF_dis = FRF_dis + C^2*phi_x*phi_y./(om_n^2 - om.^2 + 1i*2*zeta*om_n.*om); 


    % strain
    phi_x_str =  beta^2*(1./(sin(beta*L) - sinh(beta*L))).*...
            ((sin(beta*L) - sinh(beta*L)).*(-sin(beta*xr) - sinh(beta*xr)) + ...
            (cos(beta*L) + cosh(beta*L)).*(-cos(beta*xr) - cosh(beta*xr)));


    FRF_str = FRF_str + C^2*phi_x_str*phi_y./(om_n^2 - om.^2 + 1i*2*zeta*om_n.*om); 
end

dom = om(2) - om(1);
FRF_dis_rms = sqrt(sum(2*abs(FRF_dis.*om.^2).^2*dom)); % rms response - acceleration
FRF_str_rms = sqrt(sum(2*abs(FRF_str).^2*dom)); % rms response - strain

y(1) = max(FRF_dis_rms) ; % peak rms response - acceleration
y(2) = max(FRF_str_rms); % peak rms response - strain

    yout.y = y;  % this is for Fisher 
    yout.ys = y;    % this is all results 