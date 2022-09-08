function [r1,r2] = design_TCylinder_OmSensitivity()

% this codes computes the derivative of natural frequencies for sensitivity
% analysis 
% (1) rho     = 1180
% (2) rho_f   = 1025
% (3) L       = 1
% (4) L_S     = 0.2
% (5) L_b     = 0.15
% (6) r       = 0.045
% (7) t       = 0.003
% (8) mb      = 3
% (9) Ca      = 1; 

% symbolic formulation 
    syms r t mb
    syms L L_S L_b
    syms  d g rho rho_f Ca
    
    % design variables to be analyzed 
%     var=[r,t,mb,L,L_S,L_b];
    var  = [rho,rho_f,L,L_S,L_b,r,t,mb,Ca];
    Nvar = numel(var);

    L_D = d-L_S;

    ms = rho*(pi*r.^2-pi*(r-t).^2).*L;% mass of the cylinder
    B  = rho_f*pi*r.^2.*L_D*g; % buoyancy V*rho_f*g 
    ma = Ca*(B/g); % added mass

    M11=(ms+ma+mb)*L_S^2;
    M22=1/3*ms*L^2+1/3*ma*L_D^2+mb*L_b^2;
    M12=(ms*L/2+ma*L_D/2+mb*L_b)*L_S;

    K1=(B-ms*g-mb*g)*L_S;
    K2=B*L_D/2-ms*g*L/2-mb*g*L_b;

    M=[M11 M12;M12 M22];
    K=[K1 0;0 K2];

    % sensitivities 
    M11_p=jacobian(M11,var);
    M22_p=jacobian(M22,var);
    M12_p=jacobian(M12,var);

    K1_p=jacobian(K1,var);
    K2_p=jacobian(K2,var);

    
% assign values 
    w=0.5;
    r=0.045;%w/6;%linspace(w/24,w/6,10);
    d=1;
    g=9.81;

    rho=1180;
    rho_f=1025;
    L_b=0.15;
    L=1;
    t=3e-3;
    mb=3;

    L_S=0.2;
    
    Ca=1;

% eigen analysis
    [V,D]=eigs(double(subs(K)),double(subs(M)));
    lambda=diag(D); 

    V1=V(:,1)./(V(:,1).'*double(subs(M))*V(:,1)); % mass normalization
    V2=V(:,2)./(V(:,2).'*double(subs(M))*V(:,2));

% sensitivity of eigenvalues 
    lambda1_p=zeros(Nvar,1);
    lambda2_p=zeros(Nvar,1);
    for ii=1:Nvar

        K_p=[K1_p(ii) 0;0 K2_p(ii)];
        M_p=[M11_p(ii) M12_p(ii);M12_p(ii) M22_p(ii)];

        lambda1_p(ii)=V1.'*(double(subs(K_p))-lambda(1)*double(subs(M_p)))*V1; 
        lambda2_p(ii)=V2.'*(double(subs(K_p))-lambda(2)*double(subs(M_p)))*V2;

    end
 %%   
 % display the sensitivities at nominal values 
    varV  = [rho,rho_f,L,L_S,L_b,r,t,mb,Ca];
    omn=sqrt(lambda);
    
    omn1_p=lambda1_p/(2*omn(1));  % dom/dp=dlambda/dp/(2*om)
    omn2_p=lambda2_p/(2*omn(2));
    
    r1 = omn1_p.*varV.'/omn(1); 
    r2 = omn2_p.*varV.'/omn(2); 

    r1 = [r1; zeros(9,1)];
    r2 = [r2; zeros(9,1)];

   

   
 


