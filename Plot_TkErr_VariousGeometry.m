% % % % % % % % % % % % % 2015-4-23 % % % % % % % % % % % % % % % % % % 
% Plot  the average error and error variance of Tk for all the sources Using P and S wave %
% Plot  the average error and error variance of Tk for all the sources only using P wave %
% In this Version, only display the results by using P&S wave data 2015-9-16 %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function Plot_TkErr_VariousGeometry(Model_Idx,AverError_AbsoTk_PS,ErrorVariance_AbsoTk_PS,...
    AverError_AbsoTk_P,ErrorVariance_AbsoTk_P)
% Set the basic parameters 2015-6-5 %
Model_Num=size(Model_Idx,2);
Azimuth_Int=2*pi/Model_Num;
Azimuth=0:Azimuth_Int:2*pi-Azimuth_Int;

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
% Calculate the average error and error variance 2015-6-7 %
%{
AverError_Abso_Tk_PS=zeros(Sour_Num,Model_Num);
ErrorVariance_Abso_Tk_PS=zeros(Sour_Num,Model_Num);
AverError_Abso_Tk_P=zeros(Sour_Num,Model_Num);
ErrorVariance_Abso_Tk_P=zeros(Sour_Num,Model_Num);
% Set the error patameters 2015-6-7 %
AverError_AbsoTk_PS=zeros(Sour_Num,Model_Num,2);
ErrorVariance_AbsoTk_PS=zeros(Sour_Num,Model_Num,2);
AverError_AbsoTk_P=zeros(Sour_Num,Model_Num,2);
ErrorVariance_AbsoTk_P=zeros(Sour_Num,Model_Num,2);
AverError_AbsoTk_S=zeros(Sour_Num,Model_Num,2);
ErrorVariance_AbsoTk_S=zeros(Sour_Num,Model_Num,2);
for mt_type_id=1:4
    for model_id=1:Model_Num
        % Calculate the average error and error variance by using P&S-wave
        AverError_AbsoTk_PS(mt_type_id,model_id,1)=mean(Abso_T_Error_PS(:,model_id,mt_type_id));
        AverError_AbsoTk_PS(mt_type_id,model_id,2)=mean(Abso_k_Error_PS(:,model_id,mt_type_id));
        %         AverError_Abso_Tk(i,model_id)=(AverError_AbsoTk(i,model_id,1)+AverError_AbsoTk(i,model_id,2))/2;
        
        ErrorVariance_AbsoTk_PS(mt_type_id,model_id,1)=var(Abso_T_Error_PS(:,model_id,mt_type_id));
        ErrorVariance_AbsoTk_PS(mt_type_id,model_id,2)=var(Abso_k_Error_PS(:,model_id,mt_type_id));
        %         ErrorVariance_Abso_Tk(i,model_id)=sqrt((ErrorVariance_AbsoTk(i,model_id,1))^2+(ErrorVariance_AbsoTk(i,model_id,1))^2);
        
        % Calculate the average error and error variance by using P-wave
        AverError_AbsoTk_P(mt_type_id,model_id,1)=mean(Abso_T_Error_P(:,model_id,mt_type_id));
        AverError_AbsoTk_P(mt_type_id,model_id,2)=mean(Abso_k_Error_P(:,model_id,mt_type_id));
        %         AverError_Abso_Tk(i,model_id)=(AverError_AbsoTk(i,model_id,1)+AverError_AbsoTk(i,model_id,2))/2;
        
        ErrorVariance_AbsoTk_P(mt_type_id,model_id,1)=var(Abso_T_Error_P(:,model_id,mt_type_id));
        ErrorVariance_AbsoTk_P(mt_type_id,model_id,2)=var(Abso_k_Error_P(:,model_id,mt_type_id));
        %         ErrorVariance_Abso_Tk(i,model_id)=sqrt((ErrorVariance_AbsoTk(i,model_id,1))^2+(ErrorVariance_AbsoTk(i,model_id,1))^2);
        
        % Calculate the average error and error variance by using S-wave
        %         AverError_AbsoTk_S(i,model_id,1)=mean(Abso_T_Error_S(:,model_id,i));
        %         AverError_AbsoTk_S(i,model_id,2)=mean(Abso_k_Error_S(:,model_id,i));
        %         AverError_Abso_Tk(i,model_id)=(AverError_AbsoTk(i,model_id,1)+AverError_AbsoTk(i,model_id,2))/2;
        
        %         ErrorVariance_AbsoTk_S(i,model_id,1)=var(Abso_T_Error_S(:,model_id,i));
        %         ErrorVariance_AbsoTk_S(i,model_id,2)=var(Abso_k_Error_S(:,model_id,i));
        %         ErrorVariance_Abso_Tk(i,model_id)=sqrt((ErrorVariance_AbsoTk(i,model_id,1))^2+(ErrorVariance_AbsoTk(i,model_id,1))^2);
    end
end
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
    p1=plot(Azimuth,AverError_AbsoTk_PS(i,:,1),'-om','LineWidth',LineWidth,...
        'MarkerSize',MarkerSize,'Markerfacecolor','m');
    p2=plot(Azimuth,AverError_AbsoTk_PS(i,:,2),'-^m','LineWidth',LineWidth,...
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
    %     set(gca,'FontSize',FontSize,'YLim',[-1 1],'XLim',[0 2*pi])
    xlabel('Q Error/%','FontSize',FontSize);
    %}
    set(gca,'FontSize',FontSize,'Box','on')
    YLim_Min=min([AverError_AbsoTk_PS(i,:,1),AverError_AbsoTk_PS(i,:,2)]);
    YLim_Max=max([AverError_AbsoTk_PS(i,:,1),AverError_AbsoTk_PS(i,:,2)]);
    YLim=[YLim_Min,YLim_Max];
    set(gca,'YLim',YLim)
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
   
    print('-r300','-dtiff',Title);
end
% End the function
end
