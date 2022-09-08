function yout = design_TCylinder(xS,~)


    if  any(xS <= 0) 
        omn=[NaN ; NaN];
    else
    

    %% Tethered Floating Cylinder Design
    %% 
    % % 
    % We are proposing a simple tethered floating cylinder as shown in the figure 
    % below. It consisits of a single uniform cylinder and a vertical string below. 
    % There are nine design variables out of which seven can be varied. 
    % 
    % % 
    % The values for the variables can be adjusted here, to investigate corresponding 
    % natural frequencies of the system. The optimal frequency for the wave tank under 
    % consideration is 0.8 Hz for design waves. 

    % assign the values using the options below 
    rho     = xS(1);
    rho_f   = xS(2);
    L       = xS(3);
    L_S     = xS(4);
    L_b     = xS(5);
    r       = xS(6);
    t       = xS(7);
    mb      = xS(8);
    Ca      = xS(9);
    %% 1 Design
    % 1.1 Design variables 

    % assigne the values to a struct and run the eigen analysis to get natural
    % freuqencies 
    var_Name=[{'rho'},{'rho_f'},{'L'},{'L_S'},{'L_b'},{'r'},{'t'},{'mb'},{'Ca'}]';
    Nvar=numel(var_Name);
    for ii=1:Nvar
        var=['var' num2str(ii)];  
        varValue=eval(var_Name{ii});
        Svar.(var)=varValue; % assign the values to Svar 
    end
    [omn,V1,V2,para,tank]=cal_eig(Svar);%call the function for eig analysis


    yout.y = omn.';  % this is for Fisher 
    yout.ys = omn.';    % this is all results 
    % sprintf('Natural frequencies are %g and %g [%s].',round((omn/2/pi)*100)/100,'Hz')
    % set(gcf,'Visible','on')
    % plot_modes(V1,V2,omn,L,L_S,tank.d);
    end
end

%%
function [omn,V1,V2,para,tank]=cal_eig(Svar)

    d       = 1;  % depth [m]
    w       = 0.5;% width [m]
    f_opt   = 0.8;% optimal frequency [Hz] 
    
    tank.d  = d;
    tank.w  = w;
    tank.f  = f_opt; 
    
    g=9.81;
    %-------------------------------------------------------------------------
    % input parameters
    %                 rho: density of structure
    %                 rho_f: density of water
    %                 
    %                 L  length of structure 
    %                 L_D length of submerged section 
    %                 L_S length of the tether
    %                 L_m length of the ballast mass above the bottom of the structure
    %                 r   outer radius
    %                 t   thickness
    %
    %                 mb  mass of the ballast
    %                 Ca  added mass coefficient
    
    rho     =   Svar.var1;
    rho_f   =   Svar.var2;
    L       =   Svar.var3;
    L_S     =   Svar.var4;
    L_b     =   Svar.var5;
    r       =   Svar.var6;
    t       =   Svar.var7;
    mb      =   Svar.var8;
    Ca      =   Svar.var9;
    
    d       =   tank.d;
    L_D     =   d-L_S;
    
    %-------------------------------------------------------------------------
    
    ms      =   rho*(pi*r.^2-pi*(r-t).^2).*L;% mass of the cylinder
    B       =   rho_f*pi*r.^2.*L_D*g; % buoyancy V*rho_f*g 
    ma      =   Ca*(B/g); % added mass
% 1.2 Design requirement
% The system need to satisfy a few requirement 1) it needs to float. the buoyance 
% force needs to be larger than the weight. 2) it needs to be stable. the centre 
% of buoyancy should be higher than centre of mass 

    T       =   B-ms*g-mb*g;  % tension in the string need to be positive 
    L_B     =   L_D/2;   % centre of buoyancy from cylinder bottom 
    L_C     =   (L/2*ms+L_b*mb)/(ms+mb); % centre of mass from cylinder bottom

%% 2. A simple two dofs rigid body model
% The model considers a upside down pendulum with two degrees of freedom, $\theta_1$ 
% and $\theta_2$. The tether at the bottom is considered to be massless but sustains 
% variable tension. It has fixed length and equivalent to infinite stiffness. 
% A ballast weight can be adjusted, both its mass and location, to control the 
% natural frequencies of the system. 
% 2.1 Kinetic and potential energy 
% The system can be seen as consisting of three parts, a uniform cylinder, the 
% ballast and the buoyancy and/or added mass due to surrunding fluid. 
% 
% For kinetic energy:
% 
% $$T=T_1+T_2+T_3$$
% 
% $$T_1=\frac{1}{2}m_s[{L_s}^2\dot{\theta}_1^2+(\frac{L}{2})^2\dot{\theta}_2^2+L_sL\cos(\theta_1-\theta_2)\dot{\theta}_1\dot{\theta}_2]+\frac{1}{2}\frac{1}{12}m_sL^2\dot{\theta}_2$$
% 
% $$T_2=\frac{1}{2}m_a[L_s^2\dot{\theta}_1^2+(\frac{L_D}{2})^2\dot{\theta}_2^2+L_sL_D\cos(\theta_1-\theta_2)\dot{\theta}_1\dot{\theta}_2]+\frac{1}{2}\frac{1}{12}m_aL_D^2\dot{\theta}_2$$
% 
% $$T_3=\frac{1}{2}m_b[L_s^2\dot{\theta}_1^2+L_b^2\dot{\theta}_2^2+2L_sL_b\cos(\theta_1-\theta_2)\dot{\theta}_1\dot{\theta}_2]$$
% 
% For potential energy:
% 
% $$V=V_1+V_2+V_3$$
% 
% $$V_1=-m_sg[L_s(1-\cos(\theta_1)+\frac{L}{2}(1-\cos(\theta_2)]$$
% 
% $$V_2=B[L_s(1-\cos(\theta_1)+\frac{L_D}{2}(1-\cos(\theta_2)]$$
% 
% $$V_3=-m_bg[L_s(1-\cos(\theta_1)+L_b(1-\cos(\theta_2)]$$
% 2.2 Eigen analysis 
% Applying Lagrange's equation and assume small amplitdues, we obtain the mass 
% and stiffness matrix 
% 
% $\mathbf{M}=\left\lbrack \begin{array}{cc}M_{11}  & M_{12} \\M_{21}  & M_{22} 
% \end{array}\right\rbrack$; $\mathbf{K}=\left\lbrack \begin{array}{cc}K_{11}  
% & 0\\0 & K_{22} \end{array}\right\rbrack$;
% 
% $M_{11}=(m_s+m_a+m_b)L_s^2$; $M_{12}=L_s(m_s\frac{L}{2}+m_a\frac{L_D}{2}+m_bL_b)$; 
% $M_{21}=M_{12}$ ; $M_{22}=\frac{1}{3}m_sL^2+\frac{1}{3}m_a{L_D}^2+m_b{L_b}^2$
% 
% $K_{11}=(B-m_sg-m_bg)L_s$; $K_{12}=K_{21}=0$ ; $K_{22}=B\frac{L_D}{2}-m_sg\frac{L}{2}-m_bgL_b$
% 
% Then we can solve for natural frequencies via eigen analysis
% 
% $$\mathbf{Kx}=\omega^2\mathbf{Mx}$$

    %-------------------------------------------------------------------------
    % mass and stiffness matrix 
    M11=(ms+ma+mb)*L_S^2;
    M22=1/3*ms*L^2+1/3*ma*L_D^2+mb*L_b^2;
    M12=(ms*L/2+ma*L_D/2+mb*L_b)*L_S;
    
    K1=(B-ms*g-mb*g)*L_S;
    K2=B*L_D/2-ms*g*L/2-mb*g*L_b;
    
    K=[K1 0;0 K2];
    M=[M11 M12;M12 M22];
    %-------------------------------------------------------------------------
    [V,D_om]=eig(K,M); 
    
        D_om=diag(D_om);
        [sorter,index]=sort(D_om);
        V=V(:,index);
        D_om=D_om(index);
        
        omn=sqrt(D_om); % natrual frequencies 
        
        % Mass normalization 
      
        V1=V(:,1)/sqrt((V(:,1).'*M*V(:,1)));
        V2=V(:,2)/sqrt((V(:,2).'*M*V(:,2)));

        
    %------------------------------------------------------------------------
    para=[rho rho_f Ca L L_D L_S L_b r t mb L_B-L_C T 1 1]';
    if T<=0 
%         disp('not floating')
        omn=[NaN ; NaN];
        para(end-1)=0; % not floating
    end
    
    if L_B<=L_C 
%         disp('not stable')
        omn=[NaN ; NaN];
        para(end)=0; % not stable
    end
end
%% 
% 
% plot the mode shape
function plot_modes(V1,V2,omn,L,L_S,d)

    fn=round((omn/2/pi)*100)/100;

%     figure   
    
    for jj=1:2
        
        subplot(1,2,jj)
        % nominal position
        x1=(d-L_S);y1=0;
        x2=x1-L;y2=y1+0;
        plot([0 y1 y2],[d x1 x2],'ko:')
        
        if jj==1
            V=V1;
        elseif jj==2
            V=V2;
        end

    
        Vm=V/5;

        theta1=Vm(1);
        theta2=Vm(2);
        

        x1s=x1+(L_S-L_S*cos(theta1));
        y1s=y1+L_S*sin(theta1);
        
        x2s=x1s-L*cos(theta2);
        y2s=y1s+L*sin(theta2);


        
        hold on
        plot([0 y1s y2s],[d x1s x2s],'ko-')
   
        xlim([-1 1])
        ylim([-0.5 1])
        set(gca,'xticklabel',[])
        xlabel('Arbitrary Amplitude')
        ylabel('x [m]')
        title(['Mode ' num2str(jj) '; fn=' num2str(fn(jj)) ' Hz'])
        
         set(gca, 'YDir','reverse')
         
         set(gca,'FontSize',14)
    end

end

