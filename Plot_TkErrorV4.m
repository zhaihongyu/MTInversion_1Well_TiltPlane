function Plot_TkErrorV4(Model_Num,Azimuth,AverError_AbsoTk_PS,ErrorVariance_AbsoTk_PS,...
    AverError_AbsoTk_P,ErrorVariance_AbsoTk_P)
% % % % % % % % % % % % % 2015-4-23 % % % % % % % % % % % % % % % % % % 
% Plot  the average error and error variance of Tk for all the sources Using P and S wave %
% Plot  the average error and error variance of Tk for all the sources only using P wave %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
Model_Id=1:Model_Num;
% Average_AttEnergy=(Att_Energy(:,1)+Att_Energy(:,2))/2;
MT_Name={'ISO','DC','CLVD^-','CLVD^+'};
WaveType={'P & S','P'};
Legend_Loc='Best';
FontSize=22;
LineWidth=2.5;
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
    set(f3,'position',[100 100 800 600])
    
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
    plot(Azimuth,AverError_AbsoTk_PS(i,:,1),'-or','LineWidth',LineWidth)
    plot(Azimuth,AverError_AbsoTk_PS(i,:,2),'-^b','LineWidth',LineWidth)
    plot(Azimuth,AverError_AbsoTk_P(i,:,1),':dr','LineWidth',LineWidth)
    plot(Azimuth,AverError_AbsoTk_P(i,:,2),':sb','LineWidth',LineWidth)
    set(gca,'FontSize',FontSize,'YLim',[-1.5 1.2],'XLim',[0 pi])
    %     set(gca,'FontSize',FontSize,'YLim',[-1 1],'XLim',[0 2*pi])
    xlabel('Azimuth','FontSize',FontSize);
    %}
    
    %Using the attenuated energy tp  instead model id as the horizontal coordinate
    %2015-4-28 %
    %{
    plot(Azimuth(:,1),AverError_AbsoTk_PS(i,:,1),'-or','LineWidth',LineWidth)
    plot(Azimuth(:,1),AverError_AbsoTk_PS(i,:,2),'-^b','LineWidth',LineWidth)
    plot(Azimuth(:,2),AverError_AbsoTk_P(i,:,1),':dr','LineWidth',LineWidth)
    plot(Azimuth(:,2),AverError_AbsoTk_P(i,:,2),':sb','LineWidth',LineWidth)
    set(gca,'FontSize',FontSize,'YLim',[-1.5 1.2])
    %     set(gca,'FontSize',FontSize,'YLim',[-1 1],'XLim',[0 2*pi])
    xlabel('Attenuated Energy','FontSize',FontSize);
    %}
    ylabel('Error Mean','FontSize',FontSize);
    LEGEND={'T-PS' ,'k-PS','T-P','k-P'};
    l2=legend(LEGEND);
    set(l2,'Location',Legend_Loc);
    % MT_Name_Cur=char(MT_Name(i));
    Title=['Absolute Error of T-k (', MT_Name{i},')'];
    title(Title,'FontSize',FontSize);
    print('-r300','-djpeg',Title);
%     print('-dbmp',Title);
end

%{
f4=figure();
hold on
grid on
set(f4,'position',[100 100 500 400])
plot(Model_Id,AverError_AbsoTk(1,:,2),':or','LineWidth',2.5)
plot(Model_Id,AverError_AbsoTk(2,:,2),':^b','LineWidth',2.5)
plot(Model_Id,AverError_AbsoTk(3,:,2),':dk','LineWidth',2.5)
plot(Model_Id,AverError_AbsoTk(4,:,2),':sg','LineWidth',2.5)
xlabel('Model Id','FontSize',12);
ylabel('Mean','FontSize',12);
set(gca,'YLim',[-1 1],'FontSize',12,'XLim',[0 7])
l3=legend('k-ISO','k-CLVD','k-LVD','k-DC');
set(l3,'Location',Legend_Loc);
Title=['Absolute Error of k (Using ',WaveType_Sel,' wave)'];
title(Title,'FontSize',12);
print('-r600','-djpeg',Title);
%}

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

% Plot  the  error variance of Tk for all the sources 2015-4-27 %
%
for i=1:4
    f1=figure;
    set(f1,'Position',[0 0 800 600])
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
    
    %Using the azimuth instead of model id as the horizontal coordinate
    %2015-4-24 %
    %
    plot(Azimuth,ErrorVariance_AbsoTk_PS(i,:,1),'-om','LineWidth',LineWidth);
    plot(Azimuth,ErrorVariance_AbsoTk_PS(i,:,2),'-^g','LineWidth',LineWidth);
    plot(Azimuth,ErrorVariance_AbsoTk_P(i,:,1),':dm','LineWidth',LineWidth);
    plot(Azimuth,ErrorVariance_AbsoTk_P(i,:,2),':sg','LineWidth',LineWidth);
    set(gca,'YLim',[-0.05 0.2],'FontSize',FontSize,'XLim',[0 pi])
    %     set(gca,'YLim',[-0.1 0.3],'FontSize',FontSize,'XLim',[0 2*pi])
    xlabel('Azimuth','FontSize',FontSize);
    %}
    
    %Using the attenuated energy tp  instead model id as the horizontal coordinate
    %2015-4-28 %
    %{
    plot(Azimuth(:,1),ErrorVariance_AbsoTk_PS(i,:,1),'-om','LineWidth',LineWidth);
    plot(Azimuth(:,1),ErrorVariance_AbsoTk_PS(i,:,2),'-^g','LineWidth',LineWidth);
    plot(Azimuth(:,2),ErrorVariance_AbsoTk_P(i,:,1),':dm','LineWidth',LineWidth);
    plot(Azimuth(:,2),ErrorVariance_AbsoTk_P(i,:,2),':sg','LineWidth',LineWidth);
    set(gca,'YLim',[-0.05 0.2],'FontSize',FontSize)
    %     set(gca,'YLim',[-0.1 0.3],'FontSize',FontSize,'XLim',[0 2*pi])
    xlabel('Attenuated Energy','FontSize',FontSize);
    %}
    ylabel('Error Variance','FontSize',FontSize);
    LEGEND={'T-PS' ,'k-PS','T-P','k-P'};
    l2=legend(LEGEND);
    set(l2,'Location',Legend_Loc);
    Title=[' Variance of T-k (', MT_Name{i},')'];
    title(Title,'FontSize',FontSize);
    print('-r300','-djpeg',Title);
%     print('-dbmp',Title);
end
%}

%{
f1=figure;
set(f1,'Position',[0 0 600 1200])
Model_Id=1:6;
subplot(2,1,1)
hold on
grid on
plot(Model_Id,ErrorVariance_AbsoTk(1,:,1),'-or','LineWidth',2.5);
plot(Model_Id,ErrorVariance_AbsoTk(2,:,1),'-^b','LineWidth',2.5);
plot(Model_Id,ErrorVariance_AbsoTk(3,:,1),'-dg','LineWidth',2.5);
plot(Model_Id,ErrorVariance_AbsoTk(4,:,1),'-sk','LineWidth',2.5);
set(gca,'XLim',[0 7],'YLim',[-0.1 0.4],'FontSize',12)
xlabel('Model_Id','FontSize',12);
ylabel('Error Variance','FontSize',12);
legend('T-ISO','T-CLVD','T-LVD','T-DC','Location','NorthWest');
Title=['Absolute Error and Variance of T (Using ',WaveType_Sel,' wave)'];
title(Title,'FontSize',12);
subplot(2,1,2)
hold on
grid on
plot(Model_Id,ErrorVariance_AbsoTk(1,:,2),':or','LineWidth',2.5);
plot(Model_Id,ErrorVariance_AbsoTk(2,:,2),':^b','LineWidth',2.5);
plot(Model_Id,ErrorVariance_AbsoTk(3,:,2),':dg','LineWidth',2.5);
plot(Model_Id,ErrorVariance_AbsoTk(4,:,2),':sk','LineWidth',2.5);
set(gca,'XLim',[0 7],'YLim',[-0.1 0.4],'FontSize',12)
xlabel('Model_Id','FontSize',12);
ylabel('Error Variance','FontSize',12);
legend('T-ISO','T-CLVD','T-LVD','T-DC','Location','NorthWest');
Title=['Absolute Error and Variance of k (Using ',WaveType_Sel,' wave)'];
title(Title,'FontSize',12);
%}