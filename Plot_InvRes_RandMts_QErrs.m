% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Plot all the inversed moment tensors in order of Q error 2015-7-19 %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function Plot_InvRes_RandMts_QErrs(Model_Num,RandMT_Num,Sour_Num,Q_Err,...
    T_Orig_All,k_Orig_All,T_PS_All,k_PS_All,T_P_All,k_P_All)
% Set the Tk patameters 2015-6-7 %
Tk_Orig_All=zeros(2,RandMT_Num,Sour_Num);
Tk_PS_All=zeros(2,RandMT_Num,Sour_Num);
Tk_P_All=zeros(2,RandMT_Num,Sour_Num);
FontSize=9;
Markersize=5;
LineWidth=0.3;

for model_id=1:Model_Num
    for source_id=1:Sour_Num
        Tk_Orig_All(1,:,source_id)=T_Orig_All(:,model_id,source_id)';
        Tk_Orig_All(2,:,source_id)=k_Orig_All(:,model_id,source_id)';
        
        Tk_PS_All(1,:,source_id)=T_PS_All(:,model_id,source_id)';
        Tk_PS_All(2,:,source_id)=k_PS_All(:,model_id,source_id)';
        
        Tk_P_All(1,:,source_id)=T_P_All(:,model_id,source_id)';
        Tk_P_All(2,:,source_id)=k_P_All(:,model_id,source_id)';
    end
    % Transform the T-k parameters to x-y coordinates
    [TkOriginal_XY]=Tk_Transform(Tk_Orig_All);  
    [TkInversionPS_XY]=Tk_Transform(Tk_PS_All);
    [TkInversionP_XY]=Tk_Transform(Tk_P_All);
    
    %% 
    f2=figure;
    % Set the figure propersitie
    set(f2,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 8 6]);
    hold on
    axis off;
    Plot_SourceTD();
    % Plot the original and inversed data on the T-k diagram 2015-7-1 %
    
    plot(TkOriginal_XY(1,:),TkOriginal_XY(2,:),'*b','Markersize',Markersize,'LineWidth',LineWidth);
    plot(TkInversionPS_XY(1,:),TkInversionPS_XY(2,:),'.r','Markersize',Markersize,'LineWidth',LineWidth);
%     plot(TkInversionP_XY(1,:),TkInversionP_XY(2,:),'.r','Markersize',Markersize,'LineWidth',LineWidth);
    %     plot(TkInversionS_XY(1,:),TkInversionS_XY(2,:),'.r','Markersize',Markersize,'LineWidth',LineWidth);
    Title=['P Wave Q Error=',num2str(Q_Err(model_id)*100),'%'];
    %     Title=['Inversion Results (Q Error=',num2str(Q_Err(model_id)*100),'%)'];
    %     Title=['Inversed Moment Tensors - Model Id=',num2str(model_id)];
    %     Title=['Inversed Moment Tensors - Radius=',num2str(Radius(model_id))];
    t2=title(Title);
    set(t2,'FontSize',FontSize)
    
    %     title(Title,'FontSize',FontSize);
    %     set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 9 7]);
    print(f2,'-r300','-dtiff',Title);
end

end
