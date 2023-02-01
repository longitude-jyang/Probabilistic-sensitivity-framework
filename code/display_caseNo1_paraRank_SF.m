% display_caseNo1_paraRank_SF

nPar = numel(varName);

for ii = 1 : numel(varName)
    LabelName{ii,1} = strcat('$$',varName{ii},'$$');
end

legendlabel = [{'$$\mathbf{r}_1$$'};{'$$\mathbf{r}_2$$'};{'$$\Omega$$'};{'Fisher'}];
colorvec = [{[0 0 1]},{[1 0 0]},{[0.35 0.35 0.35]},{[0.85 0.85 0.85]}];

fig1 = figure; 

    b = bar([1:nPar]',[ pR_Mo_mean pR_F_mean]);  

    for ii = 1 : numel(moments_v) + 3
        b(ii).FaceColor = colorvec{ii};    
        bx(ii,:) = b(ii).XEndPoints;
    end
    

    hold on 
    er = errorbar(bx.',[pR_Mo_mean pR_F_mean],[pR_Mo_std pR_F_std],...
        "LineStyle","none",'Color','k');    
    hold off
    
    set(gca,'xtick',[1 : nPar],'xticklabel',LabelName,'TickLabelInterpreter','latex','FontSize',18);
    
    if scn == 1
        legend(legendlabel,'Location','northwest','Interpreter','latex','FontSize',18)
    elseif scn == 2
        legend(legendlabel,'Location','northwest','Interpreter','latex','FontSize',18)
    end
 
    
    ttl = title(ttlLable,'Interpreter','latex','FontSize',18);
    ttl.Units = 'Normalize'; 
    ttl.Position(1) = 0; % use negative values (ie, -0.1) to move further left
    ttl.HorizontalAlignment = 'left';  

    ylim([0 1])

    set(gca,'TickLabelInterpreter','latex','FontSize',18)
    clear bx

