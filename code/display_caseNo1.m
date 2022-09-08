 % display_caseNo1

function display_caseNo1 (V_e,D_e,V_r,D_r,rEy,rEy2,VarName)
 format short e
 
 nPar = numel(VarName);

 [~,nr1] = size(rEy);
 [~,nr2] = size(rEy2);
 Vri = zeros(size(rEy));
 Vri2 = zeros(size(rEy2));
 for ii = 1 : nr1
     Vri (:,ii) = rEy(:,ii)./max(abs(rEy(:,ii)));
 end
 for ii = 1 : nr2
     Vri2 (:,ii) = rEy2(:,ii)./max(abs(rEy2(:,ii)));
 end
 % -------------------------------------------------------------------------
 % plot  eigenvalues 
 lambdaF = diag(D_e);
 lambdar = diag(D_r);
 
 figure
 subplot(211)
 bar([1:nPar*2].',lambdaF)
 legend('Fisher')

 subplot(212)
 bar([1:nPar*2].',lambdar)
 legend('E[rr^T]')

 xlabel('Index of EigValue')
 set(gca,'FontSize',14)

 % -------------------------------------------------------------------------
 % plot Fisher eigenvectors
 figure;
  [~,ne] = size(V_e);
     for ii = 1:ne
         Vf(:,ii) = V_e(:,ii)./max(abs(V_e(:,ii)));
     end
  
     b = bar([1:nPar*2]',Vf(:,[1:2]));  

     legend('F1','F2')
     ylim([-1 1])
     
     set(gca,'FontSize',16)
     set(gca,'xtick',[round(nPar/2) nPar+round(nPar/2)],'xticklabel',[{'Mean'},{'Std Dev'}],'TickLabelInterpreter','latex','FontSize',18);

     xtips = b.XData;
     ytips = b.YData;
     ytips = ytips.*double(ytips>0);
     labels = strcat(repmat({'$$'},nPar*2,1),[VarName;VarName],repmat({'$$'},nPar*2,1));
     text(xtips,ytips,labels,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','FontSize',16,'Interpreter','latex');%

 % -------------------------------------------------------------------------
 % plot r vectors
 figure
     [~,nr] = size(V_r);
     for ii = 1 :nr
         Vrr(:,ii) = V_r(:,ii)./max(abs(V_r(:,ii)));
     end

     b = bar([1:nPar*2]',[Vrr Vri]);  

%      legend('E[rr^T]','r1','r2','r3','r4')
%      legend('E[rr^T]','r1','r2')
     ylim([-1 1])
     
     set(gca,'FontSize',16)
     set(gca,'xtick',[round(nPar/2) nPar+round(nPar/2)],'xticklabel',[{'Mean'},{'Std Dev'}],'TickLabelInterpreter','latex','FontSize',18);

     xtips = b.XData;
     ytips = b.YData;
     ytips = ytips.*double(ytips>0);
     labels = strcat(repmat({'$$'},nPar*2,1),[VarName;VarName],repmat({'$$'},nPar*2,1));
     text(xtips,ytips,labels,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','FontSize',16,'Interpreter','latex');%    


 % -------------------------------------------------------------------------
 % projection to Fisher vectors and test functions 

 Ar = [Vrr(:,1:2) Vri];
 Af = Vf(:,[1:2]);
 At = Vri2;

 [~,nAr] = size(Ar);
 [~,nAf] = size(Af);
 [~,nAt] = size(At);

 pf = zeros(nAr, nAf);
 pt = zeros(nAr, nAt);
 for ii = 1 : nAr
     for jj = 1 : nAf
         pf(ii,jj) = Ar(:,ii).'*Af(:,jj)/(norm(Ar(:,ii))*norm(Af(:,jj)));
     end     
     for kk = 1 : nAt
         pt(ii,kk) = Ar(:,ii).'*At(:,kk)/(norm(Ar(:,ii))*norm(At(:,kk)));
     end     
 end 

 figure; 
 subplot(211)
 bar([1:nAr]', abs(pf), 'stacked')
  subplot(212)
 bar([1:nAr]', abs(pt), 'stacked')



    