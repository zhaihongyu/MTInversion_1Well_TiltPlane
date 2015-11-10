% % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Plot all the inversed moment tensors by using the P-wave and S-wave
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% According to the random number of different kind of MT, us different
% algorithm to plot the 
function Plot_InvRes_4MTs_Eves(Tk_Original,Tk_Inversed_PS,Tk_Inversed_P,Tk_Inversed_S)
% Get the basic parameters
[Model_Num,Sour_Num]=size(Tk_Inversed_PS);
Model_Idx=1:Model_Num;

FontSize=9;
Markersize=3;
LineWidth=0.1;

MT_Name={'ISO','DC','CLVD-','CLVD+'};
Markers=['o','s','^','v'];
Title_Id={'(a)','(b)','(c)','(d)'};
% Model_Idx=[1,3,5,6,9,13,17];
% Model_Idx=1:2:17;


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
        Current_QErr=Model_Idx(model_id);
        Current_Color_Id=ceil(((Current_QErr-Model_Idx(1))/(Model_Idx(Model_Num)-Model_Idx(1))+0.01)*(size(cm,1)-1));
        Current_Color=cm(Current_Color_Id,:);
        % Transform the T-k parameters to x-y coordinates       
        [Tk_PS_All_XY]=Tk_To_XY(Tk_Inversed_PS{model_id,source_id});
        [Tk_P_All_XY]=Tk_To_XY(Tk_Inversed_P{model_id,source_id});
        [Tk_S_All_XY]=Tk_To_XY(Tk_Inversed_S{model_id,source_id});
        %Plot the inversion results
        %1st source type
%         p2=plot(Tk_P_All_XY(1,:),Tk_P_All_XY(2,:),'Marker',Markers(source_id),'LineStyle','none','LineWidth',LineWidth);
        p2=plot(Tk_PS_All_XY(1,:),Tk_PS_All_XY(2,:),'Marker',Markers(source_id),'LineStyle','none','LineWidth',LineWidth);
        set(p2,'Markersize',Markersize,'Markeredgecolor',Current_Color,'Markerfacecolor',Current_Color);
    end
    
    % Plot the original moment tensor by using '+' 2015-7-15 %
    [TkOriginal_XY]=Tk_To_XY(Tk_Original{source_id});
    p_Ori=plot(TkOriginal_XY(1,:),TkOriginal_XY(2,:),'k*','LineStyle','none','LineWidth',LineWidth);
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
