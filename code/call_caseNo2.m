% call_caseNo2.m uses the riser example to compute the contrained
% sensitivity 
% it uses existing TEDS code, callTEDS_riser.m, to get the Fisher
% information and the fatigue failure sensitivity 

% the prerequisite: TEDS (https://github.com/longitude-jyang/TEDS-ToolboxEngineeringDesignSensitivity)
% 06/09/2022 @ Franklin Court, Cambridge  [J Yang] 


% choose whether to export figures 
isExportFig = 0;

% this code is from the TEDS package and the riser faitigue resutls
% (presaved) can be found there as well
callTEDS_riser; 

S = rFatigue*rFatigue.';
[V_r,D_r] = eig(S,F);
lambda = diag(D_r);
[EigSorter,EigIndex] = sort(lambda,'descend');
V_r = V_r(:,EigIndex);
lambda = lambda(EigIndex);
D_r = diag(lambda);    

% display 
varName = {'C_a', 'C_d', '\rho', 'E', '\rho_o', 'T_0','\alpha','\delta'};
nPar = numel(varName);
for ii = 1 : numel(varName)
    LabelName{ii,1} = strcat('$$',varName{ii},'$$');
end


colorvec = [{[0.75 0.75 0.75]},{[0 0 0]}];

fig1 = figure;
        
    b = bar([1:nPar*2],[rFatigue./max(abs(rFatigue)) V_r(:,1)./max(abs(V_r(:,1)))],'FaceColor','Flat');         
    b(1).FaceColor = colorvec{1};
    b(2).FaceColor = colorvec{2};

    legend('Standard','Constrained','Interpreter','latex','FontSize',18,'Location','best')

    ttl = title('Sensitivity-FatigueFailure','Interpreter','latex','FontSize',18);
    ttl.Units = 'Normalize'; 
    ttl.Position(1) = 0; % use negative values (ie, -0.1) to move further left
    ttl.HorizontalAlignment = 'left';  

    set(gca,'xtick',[round(nPar/2) nPar+round(nPar/2)],'xticklabel',[{'Mean'},{'Std Dev'}],...
        'TickLabelInterpreter','latex','FontSize',18);
    xtips1 = b(1).XData;
    xtips2 = b(2).XData;
    xtips = (xtips1 + xtips2)/2;
    ytips1 = b(1).YData;
    ytips2 = b(2).YData;
    ytips = ytips1;
    ytips (ytips2 > ytips1) = ytips2  (ytips2 > ytips1);
    ytips = ytips.*double(ytips>0);
    labels = [LabelName;LabelName];
    text(xtips,ytips,labels,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','Interpreter','latex','FontSize',16);
    
    ylim([-1 1.5])

figuresize(24, 12, 'centimeters');
movegui(fig1, [50 20])
set(gcf, 'Color', 'w');

figName = 'caseNo2';
exportFig(isExportFig,[],figName);    