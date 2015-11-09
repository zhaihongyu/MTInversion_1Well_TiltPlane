% 2015-11-9 %
% Plot the decomposition results of original input moment tensors
function Plot_Decomposition_OriMTs(Original_MTs_Decom)
FontSize=9;
Axis_LineWidth=0.1;
LineWidth=1;
MarkerSize=3;
Type_Num=size(Original_MTs_Decom,2);
% Plot the result of MT decomposition
figure
hold on
Title='Decomposition of random MTs';
FaceColor={'r','g','b'};
MTs_Name={'ISO','DC','CLVD^-','CLVD^+'};

XLabel={'ISO Percent [%]','CLVD Percent [%]','DC Percent [%]'};
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 15 12]);
set(gcf,'Position',[100 100 900 400])
for i=1:Type_Num
    SingleType_MTs=Original_MTs_Decom{i};
    for j=1:3
        subplot_id=(i-1)*3+j;
        subplot(Type_Num,3,subplot_id)
        Bin_Num=8;
        h1=histogram(SingleType_MTs(:,j),Bin_Num);
        set(h1,'FaceColor',FaceColor{j})
        % Set the axis properties
        XTick=h1.BinEdges(1:2:Bin_Num+1);
        XTick_Label=round(XTick*100);
        Subplot_Title=[MTs_Name{i},'¿‡–Õ’‘¥'];
        title(Subplot_Title,'FontSize',FontSize);
        set(gca,'XLim',h1.BinLimits,'XTick',XTick,'XTickLabel',XTick_Label);
        set(gca,'FontSize',FontSize);
        xlabel(XLabel{j});
    end
    
end
print('-r300','-dtiff',Title)
% End the function
end