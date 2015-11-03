% % % % % % % % % % % % % 2015-4-23 % % % % % % % % % % % % % % % % % % 
% Plot  the average error and error variance of Tk for all the sources Using P and S wave %
% Plot  the average error and error variance of Tk for all the sources only using P wave %
% In this Version, only display the results by using P&S wave data 2015-9-16 %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function Plot_TkErr_VariousGeometry(Q_Err,AverError_AbsoTk_PS,ErrorVariance_AbsoTk_PS,...
    AverError_AbsoTk_P,ErrorVariance_AbsoTk_P)
% Set the basic parameters 2015-6-5 %
Q_Err=Q_Err*100;
Model_Num=size(Q_Err,2);
Model_Id=1:Model_Num;
% Average_AttEnergy=(Att_Energy(:,1)+Att_Energy(:,2))/2;
MT_Name={'ISO','DC','CLVD^-','CLVD^+'};
LEGEND={'T-PS' ,'k-PS','T-P','k-P'};
WaveType={'P & S','P'};
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
% Plot  the average error  of Tk for all the sources 2015-7-17 %
for i=1:4
    f3=figure();
    hold on
    grid on
    %     set(f3,'position',[100 100 900 800])I
    set(f3,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 8 6]);
    
    %{
    plot(Model_Id,AverError_AbsoTk_PS(i,:,1),'-or','LineWidth',LineWidth)
    plot(Model_Id,AverError_AbsoTk_PS(i,:,2),'-^b','LineWidth',LineWidth)
    plot(Model_Id,AverError_AbsoTk_P(i,:,1),':dr','LineWidth',LineWidth)
    plot(Model_Id,AverError_AbsoTk_P(i,:,2),':sb','LineWidth',LineWidth)
    set(gca,'FontSize',FontSize,'YLim',[-1 1],'XLim',[0 Model_Num+1])
    xlabel('Model Id','FontSize',FontSize);
    %}
    
    %Using the azimuth instead of model id as the horizontal coordinate 2015-5-28
    %plot the results by using P&S wave data
    p1=plot(Q_Err,AverError_AbsoTk_PS(i,:,1),'-om','LineWidth',LineWidth,...
        'MarkerSize',MarkerSize,'Markerfacecolor','m');
    p2=plot(Q_Err,AverError_AbsoTk_PS(i,:,2),'-^m','LineWidth',LineWidth,...
        'MarkerSize',MarkerSize,'Markerfacecolor','m');
    %plot the results by only using P wave data
    %{
    p3=plot(Q_Err,AverError_AbsoTk_P(i,:,1),'-og','LineWidth',LineWidth,...
        'MarkerSize',MarkerSize,'Markerfacecolor','g');
    p4=plot(Q_Err,AverError_AbsoTk_P(i,:,2),'-^g','LineWidth',LineWidth,...
        'MarkerSize',MarkerSize,'Markerfacecolor','g');
    %}
    
    % Set the X axis property (display as the "Q Error") 2015-6-18 %
    %{
    X_Int=10;
    XTick=Q_Err(1)-X_Int:(Q_Err(Model_Num)+2*X_Int-Q_Err(1))/5:Q_Err(Model_Num)+X_Int;
    XTickLabel=ceil(Q_Err(1)-X_Int:(Q_Err(Model_Num)+2*X_Int-Q_Err(1))/5:Q_Err(Model_Num)+X_Int);
    XLim=[Q_Err(1)-X_Int,Q_Err(Model_Num)+X_Int];
    set(gca,'FontSize',FontSize,'XLim',XLim,'XTick',XTick,'XTickLabel',XTickLabel,'Box','on')
%     set(gca,'FontSize',FontSize,'Box','on')
    
    %     set(gca,'FontSize',FontSize,'YLim',[-1 1],'XLim',[0 2*pi])
    xlabel('Q Error/%','FontSize',FontSize);
    %}
    set(gca,'YLim',[-0.8 0.8])
    %Using the attenuated energy tp  instead model id as the horizontal coordinate 2015-4-28 %
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

    % Generate the legend separately 
    %Firstly, generate the P&S wave legend
    l2=legend([p1,p2],LEGEND{1},LEGEND{2});
    l2_Postion=[5 8.5 2 1];
    set(l2,'Units','centimeters','Position',l2_Postion,'Box','off');
    
    %Secondly, generate the P wave legend
    %{
    ah=axes('position',get(gca,'position'),'visible','off');
    l3=legend(ah,[p3,p4],LEGEND{3},LEGEND{4});
    %     l3_Position=get(l2,'Position');
    l3_New_Pos=[l2_Postion(1)+4,l2_Postion(2),l2_Postion(3),l2_Postion(4)];
    set(l3,'Units','centimeters','Position',l3_New_Pos,'Box','off');
    %}
    
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


% Plot  the  error variance of Tk for all the sources 2015-4-27 %
%{
for i=1:4
    f1=figure;
    %     set(f1,'Position',[0 0 800 600])
    set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 8 7]);
    hold on
    grid on
    
    %{
    plot(Model_Id,ErrorVariance_AbsoTk_PS(i,:,1),'-om','LineWidth',LineWidth);
    plot(Model_Id,ErrorVariance_AbsoTk_PS(i,:,2),'-^g','LineWidth',LineWidth);
    plot(Model_Id,ErrorVariance_AbsoTk_P(i,:,1),':dm','LineWidth',LineWidth);
    plot(Model_Id,ErrorVariance_AbsoTk_P(i,:,2),':sg','LineWidth',LineWidth);
    set(gca,'XLim',[0 Model_Num+1],'YLim',[-0.1 0.6],'FontSize',FontSize)
    xlabel('Model Id','FontSize',FontSize);
    %}
    
    %Using the Vari_Q instead of model id as the horizontal coordinate
    %2015-4-24 %
    %
    plot(Q_Err,ErrorVariance_AbsoTk_PS(i,:,1),':om','LineWidth',LineWidth,'Markerfacecolor','m');
    plot(Q_Err,ErrorVariance_AbsoTk_PS(i,:,2),':^m','LineWidth',LineWidth,'Markerfacecolor','m');
    plot(Q_Err,ErrorVariance_AbsoTk_P(i,:,1),':og','LineWidth',LineWidth,'Markerfacecolor','g');
    plot(Q_Err,ErrorVariance_AbsoTk_P(i,:,2),':^g','LineWidth',LineWidth,'Markerfacecolor','g');
    %     Set the axis property
    XTick=-80:30:170;
    XTickLabel=-80:30:170;
    set(gca,'FontSize',FontSize,'XLim',[-80 170],'XTick',XTick,'XTickLabel',XTickLabel,'Box','on')
%     set(gca,'FontSize',FontSize,'Box','on')
%     set(gca,'YLim',[-0.05 0.2])
    %     set(gca,'YLim',[-0.1 0.3],'FontSize',FontSize,'XLim',[0 2*pi])
    xlabel('Q Error/%','FontSize',FontSize);
    %}
    
    %Using the attenuated energy tp  instead model id as the horizontal coordinate
    %2015-4-28 %
    %{
    plot(Vari_Q(:,1),ErrorVariance_AbsoTk_PS(i,:,1),'-om','LineWidth',LineWidth);
    plot(Vari_Q(:,1),ErrorVariance_AbsoTk_PS(i,:,2),'-^g','LineWidth',LineWidth);
    plot(Vari_Q(:,2),ErrorVariance_AbsoTk_P(i,:,1),':dm','LineWidth',LineWidth);
    plot(Vari_Q(:,2),ErrorVariance_AbsoTk_P(i,:,2),':sg','LineWidth',LineWidth);
    set(gca,'YLim',[-0.05 0.2],'FontSize',FontSize)
    %     set(gca,'YLim',[-0.1 0.3],'FontSize',FontSize,'XLim',[0 2*pi])
    xlabel('Attenuated Energy','FontSize',FontSize);
    %}
    ylabel('Error Variance','FontSize',FontSize);
    l2=legend(LEGEND);
    set(l2,'Location',Legend_Loc,'Orientation','horizontal');
    Title=[' Variance of T-k (', MT_Name{i},')'];
    title(Title,'FontSize',FontSize);
    print('-r300','-dtiff',Title);
    %}
end
