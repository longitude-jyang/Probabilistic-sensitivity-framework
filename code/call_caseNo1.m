% call_caseNo1 uses the cantilever beam example to calculate sensitivity of
% the response moments, focus on 1st and 2nd moments of the response. 
% The purpose is to compute the combined sensitivity and compare it with
% the results from Fisher which is based jpdf of the responses

% the prerequisite: TEDS (https://github.com/longitude-jyang/TEDS-ToolboxEngineeringDesignSensitivity)

% 06/09/2022 @ Franklin Court, Cambridge  [J Yang] 

% -------------------------------------------------------------------------   
% options 
    Opts.nSampMC  = 5000;  % number of MC samples 
    Opts.Ny       = 50;     % length y vector for cdf and pdf estimation 
    Opts.funName  ='design_cb';
    Opts.isNorm   = 1; 
    caseNo = 1;
    isF = 1;

    scn = 2; % choose senario 
% -------------------------------------------------------------------------
% input 
    varName=[{'E'},{'\rho'},{'L'},{'w'},{'t'}]';
    RandV.nVar = numel(varName);
    RandV.vNominal = [69e9 2700 0.45 2e-2 2e-3].'; 

    if scn == 1
            scnT = 'a';
            ttlLable = '(a) Gaussian variables (low CoV)';
            Opts.distType ='Normal'; 
            RandV.CoV = (1/100)* ones(RandV.nVar,1);
    elseif scn == 2
            scnT = 'b';
            ttlLable = '(b) Gamma variables (high CoV)';
            Opts.distType ='Gamma';
            RandV.CoV = (1/2)* ones(RandV.nVar,1);

    end 
   
% -------------------------------------------------------------------------
% call TEDS   
[y,V_e,D_e,xS,ListPar] = call_TEDS(Opts,RandV,[],caseNo,isF);

paraRank_F = parRank(RandV.nVar,V_e,D_e);
%%    
% -------------------------------------------------------------------------    
% compute moment and its sensitivity
moments_v= [1 2 5 20 50];     
paraRank = zeros(RandV.nVar,numel(moments_v));

for kk = 1 : numel(moments_v)

    moments_index = moments_v(kk);
    rEy = calSen_moments (y,xS,moments_index);

    if Opts.isNorm == 1

        b_v = reshape(ListPar(:,[5 6]),RandV.nVar*2,1);
        rEy = rEy .* b_v;

    end
    
    [~,nr1] = size(rEy);
    for ii = 1 : nr1
        rEy(:,ii) = rEy(:,ii)/norm(rEy(:,ii));
    end

% -------------------------------------------------------------------------
% sensitivity matrix
     S = rEy*rEy.';
     [V_r,D_r] = eig(S); 
     lambda = diag(D_r);
     [EigSorter,EigIndex] = sort(lambda,'descend');
     V_r = V_r(:,EigIndex);
     lambda = lambda(EigIndex);
     D_r = diag(lambda);

    % -------------------------------------------------------------------------    
    % Rank parameters

    paraRank(:,kk) = parRank(RandV.nVar,V_r,D_r);

end

% -------------------------------------------------------------------------
% display
display_caseNo1_paraRank;

