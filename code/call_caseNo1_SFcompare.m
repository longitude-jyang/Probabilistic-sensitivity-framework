% call_caseNo1_SFcompare.m tries to use precomputed samples and compare the
% score function (SF) results of each individual utility, and compare it
% with the new combined metric and the results from Fisher

% this is different from original idea to use higher moments, for
% covergence to Fisher, as it is found that higher moments DO NOT
% necessarily converge to Fisher, as they are fundamentally different
% metrics

% the prerequisite: TEDS (https://github.com/longitude-jyang/TEDS-ToolboxEngineeringDesignSensitivity)
% 18/01/2023 @ Franklin Court, Cambridge  [J Yang] 



scn = 1; % senario 
% -------------------------------------------------------------------------

    if scn == 1
           load('case1_a_2_repeat.mat');
            ttlLable = '(a) Normal distributed variables';
    elseif scn == 2
           load('case1_b_3_repeat.mat');
            ttlLable = '(b) Gamma distributed variables';
    end 

% -------------------------------------------------------------------------
%%
% use all samples as it is (alternatively resample them) 
    Nk = Nr;
    yk = yr;
    xSk = xSr;

% -------------------------------------------------------------------------

%%
pR_F = cell(Nk,1);
pR_Mo = cell(Nk,1);

rEy_Cell = cell(Nk,1);
lambda_Mat = zeros(nPar*2,Nk);

for rr = 1 : Nk
         
         y = yk{rr};
         xS = xSk{rr};
         
         
         yF = y;
         yjpdf = cal_jpdf_hist (yF,xS,Opts.Ny);

         % compute fisher matrix (raw)
         Fraw = cal_jFisher (yjpdf,nPar);
         Fraw = Fraw(1:nPar*2,1:nPar*2);  % 3rd/4th parameters are not implemented     
    
    
    % ------------------------------------------------------------------------- 
         % eigen analysis 
         % re-parameterization and normalization  - transformation 
         Fn = parTran(Fraw, ListPar,parJ,Opts.isNorm) ;
    
         [V_e,D_e] = eig(Fn); 
         lambda = diag(D_e);
         [EigSorter,EigIndex] = sort(lambda,'descend');
         V_e = V_e(:,EigIndex);
         lambda = lambda(EigIndex);
         D_e = diag(lambda);
         
         paraRank_F = parRank(RandV.nVar,V_e,D_e);
    %    
    % -------------------------------------------------------------------------    
    % compute SF sensitivity of individual utility
    moments_v= [1];     
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
            rEy(:,ii) = rEy(:,ii)/norm(rEy(:,ii)); % like eigenvector
        end

        rEy_rank = rEy(1:RandV.nVar,:).^2 + rEy(RandV.nVar + 1: end,:).^2;
     % -------------------------------------------------------------------------
    % sensitivity matrix
         S = rEy*rEy.';
         [V_r,D_r] = eig(S); 
         lambda = diag(D_r);
         [EigSorter,EigIndex] = sort(lambda,'descend');
         V_r = V_r(:,EigIndex);
         lambda = lambda(EigIndex);
         D_r = diag(lambda);

         
         lambda_Mat(:,rr) = lambda; 
        % -------------------------------------------------------------------------    
        % Rank parameters

        paraRank(:,kk) = parRank(RandV.nVar,V_r,D_r);

    end
    
    rEy_Cell{rr} = rEy;
    pR_F{rr} = paraRank_F;
    pR_Mo{rr} = [rEy_rank paraRank ];
end    

%%
% calculate mean and error bound 

pR_F_Mat = cell2mat(pR_F.'); % nVar rows X nR columns
pR_F_mean = mean(pR_F_Mat,2);
pR_F_std = std(pR_F_Mat,1,2);


nMo = numel(moments_v) + 2 ; % plus the 2 QoIs ---->  this might need to be changed 
pR_Mo_mean = zeros(RandV.nVar , nMo);
pR_Mo_std = zeros(RandV.nVar , nMo);

for ii = 1 :  RandV.nVar
    pR_Mo_ii = cellfun(@(x)[x(ii,:)],pR_Mo,'UniformOutput',false);
    pR_Mo_ii_Mat = cell2mat(pR_Mo_ii);
    
    pR_Mo_mean(ii,:) = mean(pR_Mo_ii_Mat);
    pR_Mo_std(ii,:) = std(pR_Mo_ii_Mat,1);
    
end

display_caseNo1_paraRank_SF;