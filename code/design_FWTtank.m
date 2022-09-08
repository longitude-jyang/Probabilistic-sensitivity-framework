function yout = design_FWTtank (xS,Opts)

    % overwrite the values for uncertain parameters 
    varName = Opts.varName; 
    ModPar  = Opts.ModPar; 

    nVar = numel(varName);
    % assign the values that are varying 
    for ii = 1 : nVar
        ModPar.(varName{ii}) = xS(ii); 
    end  
    
          %---------------------------------------------------------------------    
            Out = maincode (ModPar);    
          %---------------------------------------------------------------------
 
  % pick up response 

    ytest = Opts.ytest; 
    Ny = numel (ytest);
    iy = zeros(1,Ny);
    for ii = 1 : Ny
        xcoor = Out.xCoord;
        [~, iy(ii)] = min(abs(xcoor - xcoor(end)  + ytest(ii)));
    end
    

    % cases with interested in displacement response at one frequency 
%      y = mean(abs(Out.response.frf(iy,:)),2).' ; 
     y = max(abs(Out.response.frf(iy,:)),[],2).' ; 
     delta = y;
     ys  = abs(Out.response.frf(iy,:)) ; 
    
    
    yout.y = delta;  % this is for Fisher 
    yout.ys = ys;    % this is all results 
% ---------------------------------------------------------
% archive 
% ---------------------------------------------------------
%     response = Out.response;
%     BM       = Out.BM;
%     wave     = Out.wave;
%     mode     = Out.mode;
     
%      om_range = wave.F_f;
%      [~,iom]  = min(abs(om_range-sqrt(mode.om(2))));  
      
     % interested in stress response 
%        z = abs(BM.SigmaIR);
       
       %      y = max(z (:,iom));
     
%       y  = z (:,iom).';