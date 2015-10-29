% % % % % % % % % % % % % 2015-7-1 % % % % % % % % % % % % % % % % % % 
% Plot  the average error of Tk for all the sources Using P and S wave %
% Plot  the average error of Tk for all the sources only using P wave %
% Plot  the average error of Tk for all the sources only using S wave %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
function Plot_TkErr(Q_Err,AverError_AbsoTk_PS,AverError_AbsoTk_P,AverError_AbsoTk_S)
% Set the basic parameters 2015-6-5 %
Q_Err=Q_Err*100;
Model_Num=size(Q_Err,2);
Model_Id=1:Model_Num;
% Average_AttEnergy=(Att_Energy(:,1)+Att_Energy(:,2))/2;
MT_Name={'ISO','DC','CLVD^-','CLVD^+'};
LEGEND={'T-PS' ,'k-PS','T-P','k-P','T-S','k-S'};
Legend_Loc='northwest';
% Legend_Loc='Best';
FontSize=9;
LineWidth=0.1;
MarkerSize=3;
% Legend_Location={'SouthEast','NorthWest'};
%{
switch Plot_Type
    case 3
        WaveType_Sel=WaveType{1};
        Legend_Loc=Legend_Location{1};
    case 4
        WaveType_Sel=WaveType{2};   
        Legend_Loc=Legend_Location{2};
    otherwise
end
%}
%     Plot the absolute inversion error of every kind of source
%{
for i=1:4
    f2=figure();
    hold on
    set(f2,'position',[100 100 500 400])
    errorbar(Model_Id,AverError_AbsoTk(i,:,1),ErrorVariance_AbsoTk(i,:,1),'-k','LineWidth',2.5)
    errorbar(Model_Id,AverError_AbsoTk(i,:,2),ErrorVariance_AbsoTk(i,:,2),':g','LineWidth',2.5)
    grid on
    Legend1=['T-',MT_Name{i}];
    Legend2=['k-',MT_Name{i}];
    l1=legend(Legend1,Legend2);
    set(l1,'Location','SouthEast');
    xlabel('Model Id','FontSize',12);
    ylabel('Mean','FontSize',12);
    set(gca,'YLim',[-1 1],'FontSize',12)
    Title=['Absolute Error of T-k (Using ',WaveType_Sel,' wave)'];
    title(Title,'FontSize',12);
%     print('-r600','-dbmp',Title);
end
%}
% Plot  the average error  of Tk for all the sources
%{
f3=figure();
set(f3,'position',[100 100 500 400])
subplot(2,2,1)
hold on
grid on
%}
% Plot  the average error  of Tk for all the sources
for i=1:4
    f3=figure();
    hold on
    grid on
    %     set(f3,'position',[100 100 900 800])I
    set(f3,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 9 7]);
    
    %{
    plot(Model_Id,AverError_AbsoTk_PS(i,:,1),'-or','LineWidth',LineWidth)
    plot(Model_Id,AverError_AbsoTk_PS(i,:,2),'-^b','LineWidth',LineWidth)
    plot(Model_Id,AverError_AbsoTk_P(i,:,1),':dr','LineWidth',LineWidth)
    plot(Model_Id,AverError_AbsoTk_P(i,:,2),':sb','LineWidth',LineWidth)
    set(gca,'FontSize',FontSize,'YLim',[-1 1],'XLim',[0 Model_Num+1])
    xlabel('Model Id','FontSize',FontSize);
    %}
    
    %Using the azimuth instead of model id as the horizontal coordinate
    %2015-4-27 %
    %
    p1=plot(Q_Err,AverError_AbsoTk_PS(i,:,1),'-om','LineWidth',LineWidth,...
        'MarkerSize',MarkerSize,'Markerfacecolor','m');
    p2=plot(Q_Err,AverError_AbsoTk_PS(i,:,2),'-^m','LineWidth',LineWidth,...
        'MarkerSize',MarkerSize,'Markerfacecolor','m');
    p3=plot(Q_Err,AverError_AbsoTk_P(i,:,1),'-og','LineWidth',LineWidth,...
        'MarkerSize',MarkerSize,'Markerfacecolor','g');
    p4=plot(Q_Err,AverError_AbsoTk_P(i,:,2),'-^g','LineWidth',LineWidth,...
        'MarkerSize',MarkerSize,'Markerfacecolor','g');
    p5=plot(Q_Err,AverError_AbsoTk_S(i,:,1),'-ok','LineWidth',LineWidth,...
        'MarkerSize',MarkerSize,'Markerfacecolor','k');
    p6=plot(Q_Err,AverError_AbsoTk_S(i,:,2),'-^k','LineWidth',LineWidth,...
        'MarkerSize',MarkerSize,'Markerfacecolor','k');
    %     Set the axis property 2015-6-18 %
    XTick=-80:30:170;
    XTickLabel=-80:30:170;
    set(gca,'FontSize',FontSize,'XLim',[-80 170],'XTick',XTick,'XTickLabel',XTickLabel,'Box','on')
%     set(gca,'FontSize',FontSize,'Box','on')
    set(gca,'YLim',[-1.3 1.8])
    %     set(gca,'FontSize',FontSize,'YLim',[-1 1],'XLim',[0 2*pi])
    xlabel('Q Error/%','FontSize',FontSize);
    %}
    
    %Using the attenuated energy tp  instead model id as the horizontal coordinate
    %2015-4-28 %
    %{
    plot(Vari_Q(:,1),AverError_AbsoTk_PS(i,:,1),'-or','LineWidth',LineWidth)
    plot(Vari_Q(:,1),AverError_AbsoTk_PS(i,:,2),'-^b','LineWidth',LineWidth)
    plot(Vari_Q(:,2),AverError_AbsoTk_P(i,:,1),':dr','LineWidth',LineWidth)
    plot(Vari_Q(:,2),AverError_AbsoTk_P(i,:,2),':sb','LineWidth',LineWidth)
    set(gca,'FontSize',FontSize,'YLim',[-1.5 1.2])
    %     set(gca,'FontSize',FontSize,'YLim',[-1 1],'XLim',[0 2*pi])
    xlabel('Attenuated Energy','FontSize',FontSize);
    %}
    ylabel('Error','FontSize',FontSize);
    Title=['Absolute Error of T-k (', MT_Name{i},')'];
    title(Title,'FontSize',FontSize);

    l1=legend([p1,p2],LEGEND{1},LEGEND{2},'FontSize',FontSize);
    l1_Postion=[3.5 8.8 2 1];
    set(l1,'Units','centimeters','Position',l1_Postion,'Box','off');
    %
    ah1=axes('position',get(gca,'position'),'visible','off');
    l2=legend(ah1,[p3,p4],LEGEND{3},LEGEND{4},'FontSize',FontSize);
    %     l3_Position=get(l2,'Position');
    l2_Position=[l1_Postion(1)+3.5,l1_Postion(2),l1_Postion(3),l1_Postion(4)];
    set(l2,'Units','centimeters','Position',l2_Position,'Box','off');
    
    ah2=axes('position',get(gca,'position'),'visible','off');
    l3=legend(ah2,[p5,p6],LEGEND{5},LEGEND{6},'FontSize',FontSize);
    %     l3_Position=get(l2,'Position');
    l3_Position=[l1_Postion(1)+6.8,l1_Postion(2),l1_Postion(3),l1_Postion(4)];
    set(l3,'Units','centimeters','Position',l3_Position,'Box','off');
%     l2=legend([p1,p2,p3,p4],'e','vr','b','v');
    
%     l2_pos=get(l2,'Position');
%     l3=legend([p3,p4],LEGEND(3:4));
%     set(l3,'Orientation','horizontal','Position',[l2_pos(1),l2_pos(2)-0.2,l2_pos(3),l2_pos(4)]);
    % MT_Name_Cur=char(MT_Name(i));
    
    %     set(f3,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[0 0 800 550]);
    print('-r300','-dtiff',Title);
%     print('-dbmp',Title);
end
% Plot  the average error and error variance of Tk for all the sources
% 2015-4-10 %
%{
f5=figure();
hold on
grid on
set(f5,'position',[100 100 500 400])
errorbar(Model_Id,AverError_AbsoTk(1,:,1),ErrorVariance_AbsoTk(1,:,1),'-r','LineWidth',2.5)
errorbar(Model_Id,AverError_AbsoTk(2,:,1),ErrorVariance_AbsoTk(2,:,1),'-b','LineWidth',2.5)
errorbar(Model_Id,AverError_AbsoTk(3,:,1),ErrorVariance_AbsoTk(3,:,1),'-k','LineWidth',2.5)
errorbar(Model_Id,AverError_AbsoTk(4,:,1),ErrorVariance_AbsoTk(4,:,1),'-g','LineWidth',2.5)
xlabel('Perturbation Coefficient (%)','FontSize',12);
ylabel('Mean & Variance','FontSize',12);
set(gca,'FontSize',12,'YLim',[-1 1],'XLim',[0 Model_Num+1])
l2=legend('T-ISO','T-CLVD','T-LVD','T-DC');
set(l2,'Location',Legend_Loc);
% MT_Name_Cur=char(MT_Name(i));
Title=['Absolute Error and Variance of T (Using ',WaveType_Sel,' wave)'];
title(Title,'FontSize',12);
print('-r600','-djpeg',Title);

f6=figure();
hold on
grid on
set(f6,'position',[100 100 500 400])
errorbar(Model_Id,AverError_AbsoTk(1,:,2),ErrorVariance_AbsoTk(1,:,2),':r','LineWidth',2.5)
errorbar(Model_Id,AverError_AbsoTk(2,:,2),ErrorVariance_AbsoTk(2,:,2),':b','LineWidth',2.5)
errorbar(Model_Id,AverError_AbsoTk(3,:,2),ErrorVariance_AbsoTk(3,:,2),':k','LineWidth',2.5)
errorbar(Model_Id,AverError_AbsoTk(4,:,2),ErrorVariance_AbsoTk(4,:,2),':g','LineWidth',2.5)
xlabel('Perturbation Coefficient (%)','FontSize',12);
ylabel('Mean & Variance','FontSize',12);
set(gca,'YLim',[-1 1],'FontSize',12,'XLim',[0 Model_Num+1])
l3=legend('k-ISO','k-CLVD','k-LVD','k-DC');
set(l3,'Location',Legend_Loc);
Title=['Absolute Error and Variance of k (Using ',WaveType_Sel,' wave)'];
title(Title,'FontSize',12);
print('-r600','-djpeg',Title);
%}
end
