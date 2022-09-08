% call_caseNo3.m uses the floating cylinder example to show that we can use
% Fisher sensitivity to approximate analytical sensitivities 

% the prerequisite: TEDS (https://github.com/longitude-jyang/TEDS-ToolboxEngineeringDesignSensitivity)

% 06/09/2022 @ Franklin Court, Cambridge  [J Yang] 


% -------------------------------------------------------------------------   
% options 
    Opts.nSampMC  = 2000;  % number of MC samples 
    Opts.Ny       = 50;     % length y vector for cdf and pdf estimation 
    Opts.funName  ='design_TCylinder';
    Opts.distType ='Normal'; 
    Opts.isNorm   = 1; 
    caseNo = 3;
% -------------------------------------------------------------------------
% input 
    varName=[{'\rho'},{'\rho_f'},{'L'},{'L_S'},{'L_b'},{'r'},{'t'},{'m_b'},{'C_a'}]';
    nVar = numel(varName);

    vNominal = [1180 1025 1 0.2 0.15 4.5e-2 3e-3 3 1].';
    CoV = 1/1e4 * ones(nVar,1);

    RandV.nVar = nVar;
    RandV.vNominal = vNominal;
    RandV.CoV = CoV;
   
% -------------------------------------------------------------------------
% call TEDS   
    [y,V_e,D_e,xS,ListPar] = call_TEDS(Opts,RandV,[],caseNo);

% -------------------------------------------------------------------------
% calculate deterministic sensitivity for the natural frequencies (analytical)
    [r1,r2] = design_TCylinder_OmSensitivity();

% -------------------------------------------------------------------------
% display    
   display_caseNo3(D_e,V_e,r1,r2,varName,1)