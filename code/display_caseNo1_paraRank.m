% display_caseNo1_paraRank
isExportFig = 0;

nPar = numel(varName);

for ii = 1 : numel(varName)
    LabelName{ii,1} = strcat('$$',varName{ii},'$$');
end

legendlabel = [strcat('$$N=',string(num2cell(moments_v)),'$$') 'Fisher'];

fig1 = figure; 

    b = bar([1:nPar]',[paraRank paraRank_F]);  

    colorvec = gray(numel(moments_v) + 5);
    for ii = 1 : numel(moments_v) + 1 
        b(ii).FaceColor = colorvec(end - ii ,:);    
    end

    set(gca,'xtick',[1 : nPar],'xticklabel',LabelName,'TickLabelInterpreter','latex','FontSize',18);
    
    if scn == 1
        legend(legendlabel,'Location','northeast','Interpreter','latex','FontSize',18)
    elseif scn == 2
        legend(legendlabel,'Location','northwest','Interpreter','latex','FontSize',18)
    end
 
    ttl = title(ttlLable,'Interpreter','latex','FontSize',18);
    ttl.Units = 'Normalize'; 
    ttl.Position(1) = 0; % use negative values (ie, -0.1) to move further left
    ttl.HorizontalAlignment = 'left';  

    ylim([0 0.6])

    set(gca,'TickLabelInterpreter','latex','FontSize',18)

figuresize(24, 12, 'centimeters');
movegui(fig1, [50 20])
set(gcf, 'Color', 'w');

figName = strcat('caseNo1',scnT);
exportFig(isExportFig,[],figName);