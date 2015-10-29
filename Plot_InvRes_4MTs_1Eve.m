% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Plot all the inversed moment tensors by using the P-wave and S-wave or using the S-wave %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function Plot_InvRes_4MTs_1Eve(Model_Num,RandMT_Num,Sour_Num,Q_Err,T_Orig_All,k_Orig_All,...
    T_PS_All,k_PS_All,T_P_All,k_P_All,T_S_All,k_S_All)
% Set the Tk patameters 2015-6-7 %
Tk_Orig_All=zeros(2,RandMT_Num);
Tk_PS_All=zeros(2,RandMT_Num);
Tk_P_All=zeros(2,RandMT_Num);
Tk_S_All=zeros(2,RandMT_Num);

MT_Name={'ISO','DC','CLVD-','CLVD+'};
Markers=['o','s','^','v'];
Title_Id={'(e)','(f)','(g)','(h)'};

FontSize=9;
Markersize=6;
LineWidth=0.1;
% Model_Idx=[1,3,9,17];
% Plot the inversion results in the order of MTs
for source_id=1:Sour_Num
    f1=figure();
    set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 8 6]);
    hold on;
    cm=colormap(jet);
    
    Title=MT_Name{source_id};
   
    %     title(Title,'FontSize',FontSize);
    text(1.1,1.1,Title_Id(source_id),'Fontsize',FontSize);
    %         Plot the Source-Type diagram
    axis off;
    Plot_SourceTD();
    
    
    
    
%     p1=plot(TkOriginal_XY(1,:),TkOriginal_XY(2,:),'o','LineWidth',LineWidth);
%     set(p1,'Markersize',Markersize,'Markeredgecolor','b','Markerfacecolor','b');
    %Calculate the T-k parameters and X-Y coordinates 2015-7-14 %
    for model_id=1:Model_Num 
        Current_QErr=Q_Err(model_id);
        Current_Color_Id=ceil(((Current_QErr+0.75)/(1.65+0.75)+0.01)*(size(cm,1)-1));
        Current_Color=cm(Current_Color_Id,:);
        Tk_PS_All(1,:)=T_PS_All(:,model_id,source_id)';
        Tk_PS_All(2,:)=k_PS_All(:,model_id,source_id)';
        
        Tk_P_All(1,:)=T_P_All(:,model_id,source_id)';
        Tk_P_All(2,:)=k_P_All(:,model_id,source_id)';
        
        Tk_S_All(1,:)=T_S_All(:,model_id,source_id)';
        Tk_S_All(2,:)=k_S_All(:,model_id,source_id)';
        % Transform the T-k parameters to x-y coordinates
        
        [Tk_PS_All_XY]=Tk_Transform(Tk_PS_All);
        [Tk_P_All_XY]=Tk_Transform(Tk_P_All);
        [Tk_S_All_XY]=Tk_Transform(Tk_S_All);
        %Plot the inversion results
        %1st source type
        p2=plot(Tk_P_All_XY(1,:),Tk_P_All_XY(2,:),'Marker',Markers(source_id),'LineStyle','none','LineWidth',LineWidth);
%         p2=plot(Tk_PS_All_XY(1,:),Tk_PS_All_XY(2,:),'Marker',Markers(source_id),'LineStyle','none','LineWidth',LineWidth);
        set(p2,'Markersize',Markersize,'Markeredgecolor',Current_Color,'Markerfacecolor',Current_Color);
%         set(p2,'Markersize',Markersize,'Markeredgecolor',Current_Color);
    end
    
    % Plot the original moment tensor by using '+' 2015-7-15 %
    Tk_Orig_All(1,:)=T_Orig_All(:,1,source_id)';
    Tk_Orig_All(2,:)=k_Orig_All(:,1,source_id)';
    [TkOriginal_XY]=Tk_Transform(Tk_Orig_All);
    p_Ori=plot(TkOriginal_XY(1,:),TkOriginal_XY(2,:),'k*','LineStyle','none','LineWidth',1);
    set(p_Ori,'Markersize',Markersize-1);
    
    %{
        p1=plot(TkInversion_XY1(1,:),TkInversion_XY1(2,:),'o','LineWidth',LineWidth);
        set(p1,'Markersize',Markersize,'Markeredgecolor','r');
        p2=plot(TkOriginal_XY1(1,:),TkOriginal_XY1(2,:),'o','LineWidth',LineWidth);
        set(p2,'Markersize',Markersize,'Markeredgecolor','b');
        %
        p3=plot(TkInversion_XY2(1,:),TkInversion_XY2(2,:),'^','LineWidth',LineWidth);
        set(p3,'Markersize',Markersize,'Markeredgecolor','r');
        p4=plot(TkOriginal_XY2(1,:),TkOriginal_XY2(2,:),'^','LineWidth',LineWidth);
        set(p4,'Markersize',Markersize,'Markeredgecolor','b');
        %
        p5=plot(TkInversion_XY3(1,:),TkInversion_XY3(2,:),'d','LineWidth',LineWidth);
        set(p5,'Markersize',Markersize,'Markeredgecolor','r');
        p6=plot(TkOriginal_XY3(1,:),TkOriginal_XY3(2,:),'d','LineWidth',LineWidth);
        set(p6,'Markersize',Markersize,'Markeredgecolor','b');
        %
        p7=plot(TkInversion_XY4(1,:),TkInversion_XY4(2,:),'s','LineWidth',LineWidth);
        set(p7,'Markersize',Markersize,'Markeredgecolor','r');
        p8=plot(TkOriginal_XY4(1,:),TkOriginal_XY4(2,:),'s','LineWidth',LineWidth);
        set(p8,'Markersize',Markersize,'Markeredgecolor','b');
        
    %}
    
    
%     MT_Name_Cur=char(MT_Name(i));
    %     set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 9 7]);
    %     set(f1,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[0 0 1200 1000]);
    
    %     Save the figure 2015-7-14 %
    print(f1,'-r300','-dtiff',Title);
end
% Plot the colorbar for all the inversion results 2015-7-14 %
fc1=figure();
set(fc1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 15 6]);
axis off;
hold on;
cm=colormap(jet);
%     Plot the colorbar 2015-7-14
cb=colorbar;
Ticks=0:0.125:1;
TickLabels={'-75%','-45%','-15%','15%','45%','75%','105%','135%','165%'};
set(cb,'Ticks',Ticks,'TickLabels',TickLabels,'Location','South Outside');
%     Change the width of the colorbar 2015-7-14 %
Cb_Pos=get(cb,'Position');
Cb_Pos(4)=Cb_Pos(4)-Cb_Pos(4)/3;
set(cb,'Position',Cb_Pos);
% Save the ColorBar 2015-7-14 %
print(fc1,'-r300','-dtiff','ColorBar');
end
