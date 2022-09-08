function display_caseNo3(D_e,V_e,r1,r2,varName,isExportFig)

 
nPar = numel(varName);

for ii = 1 : numel(varName)
    LabelName{ii,1} = strcat('$$',varName{ii},'$$');
end

% V_e is the FIM eigenvectors
% r1,r2 is the analytical sensitivities 
% normalise them for same graph 
omS{1}= [-squeeze(V_e(:,1,1))/max(abs(squeeze(V_e(:,1,1)))) r2/max(abs(r2))];
omS{2} = [-squeeze(V_e(:,1,2))/max(abs(squeeze(V_e(:,1,2)))) r1/max(abs(r1))];

colorvec = [{[0.75 0.75 0.75]},{[0 0 0]}];
titleNo = [{'(a)'},{'(b)'}];
fig1 = figure;
for ii = 1 : 2

     subplot(2,1,ii)

     b = bar([1:nPar*2]',omS{ii},'FaceColor','Flat');          % just 1st eigenvector
     b(1).FaceColor = colorvec{1};
     b(2).FaceColor = colorvec{2};

     b(2).CData(1,:) = [0.2 0.6 0.5];

     set(gca,'xtick',[round(nPar/2) nPar+round(nPar/2)],'xticklabel',[{'Mean'},{'Std Dev'}],...
         'TickLabelInterpreter','latex','FontSize',18);

     xtips = b.XData;
     ytips = b.YData;
     ytips = ytips.*double(ytips>0);
     labels = [LabelName;LabelName];
     text(xtips,ytips,labels,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','Interpreter','latex','FontSize',16);

     if ii == 1
         legend('1st Fisher EigVector','Deterministic Sensitivity','Interpreter','latex','FontSize',18)
     end
     title(strcat(titleNo{ii},'{ }','Sensitivity of ','{ }','$$\omega_',num2str(ii),'$$'),'Interpreter','latex','FontSize',18)
    
     ylim([-1 1.5])

     ax = gca;
     ax.TitleHorizontalAlignment = 'left'; 


end

        figuresize(28, 18, 'centimeters');
        movegui(fig1, [50 20])
        set(gcf, 'Color', 'w');

        figName = 'caseNo3';
        exportFig(isExportFig,[],figName);