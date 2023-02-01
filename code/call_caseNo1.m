% call_caseNo1 uses the cantilever beam example to calculate sensitivity of
% the response moments, focus on 1st and 2nd moments of the response. 
% The purpose is to compute the combined sensitivity and compare it with
% the results from Fisher which is based jpdf of the responses

% the prerequisite: TEDS (https://github.com/longitude-jyang/TEDS-ToolboxEngineeringDesignSensitivity)

% 06/09/2022 @ Franklin Court, Cambridge  [J Yang] 
% 18/1/2023 --> update this code to generate data only, with 10 repetitions
% then calls 'call_caseNo1_SFcompare.m' to calculate and plot sensitivity results 

% -------------------------------------------------------------------------   
% -------------------------------------------------------------------------   
% options 
    Opts.nSampMC  = 20000;  % number of MC samples 
    Opts.Ny       = 50;     % length y vector for cdf and pdf estimation 
    Opts.funName  ='design_cb';
    Opts.isNorm   = 1; 
    caseNo = 1;
    isF = 1;

    scn = 1; % senario 
% -------------------------------------------------------------------------
% input 
    varName=[{'E'},{'\rho'},{'L'},{'w'},{'t'}]';
    RandV.nVar = numel(varName);
    RandV.vNominal = [69e9 2700 0.45 2e-2 2e-3].'; 

    if scn == 1
            scnT = 'a';
            ttlLable = '(a) Gaussian variables (low CoV)';
            Opts.distType ='Normal'; 
            RandV.CoV = (1/10)* ones(RandV.nVar,1);
    elseif scn == 2
            scnT = 'b';
            ttlLable = '(b) Gamma variables (high CoV)';
            Opts.distType ='Gamma';
            RandV.CoV = (1/2)* ones(RandV.nVar,1);

    end 

% ------------------------------------------------------------------------- 
Nr = 10; % number of repetitions   
yr = cell(Nr,1);
xSr = cell(Nr,1);

for rr = 1 : Nr    
% -------------------------------------------------------------------------
% call TEDS   
    [y,xS,ListPar,parJ] = call_TEDS_b(Opts,RandV,[],caseNo,isF);
    [nPar, ~] = size(ListPar);                                  % get size
    nS = Opts.nSampMC;                                          % No. of samples
    
    yr{rr} = y;
    xSr{rr} = xS;
    
end

