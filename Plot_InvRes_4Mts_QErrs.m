% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Plot all the inversed moment tensors in order of Q error 2015-7-19 %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function Plot_InvRes_4Mts_QErrs(Model_Num,RandMT_Num,Sour_Num,Q_Err,T_Orig_All,k_Orig_All,...
    T_PS_All,k_PS_All,T_P_All,k_P_All,T_S_All,k_S_All)
% Set the Tk patameters 2015-6-7 %
Tk_Orig_All=zeros(2,RandMT_Num,Sour_Num);
Tk_PS_All=zeros(2,RandMT_Num,Sour_Num);
Tk_P_All=zeros(2,RandMT_Num,Sour_Num);
Tk_S_All=zeros(2,RandMT_Num,Sour_Num);
FontSize=9;
% MT_Name={'ISO','DC','-CLVD','+CLVD'};
for model_id=1:Model_Num
    for source_id=1:Sour_Num
        Tk_Orig_All(1,:,source_id)=T_Orig_All(:,model_id,source_id)';
        Tk_Orig_All(2,:,source_id)=k_Orig_All(:,model_id,source_id)';
        
        Tk_PS_All(1,:,source_id)=T_PS_All(:,model_id,source_id)';
        Tk_PS_All(2,:,source_id)=k_PS_All(:,model_id,source_id)';
        
        Tk_P_All(1,:,source_id)=T_P_All(:,model_id,source_id)';
        Tk_P_All(2,:,source_id)=k_P_All(:,model_id,source_id)';
        
        Tk_S_All(1,:,source_id)=T_S_All(:,model_id,source_id)';
        Tk_S_All(2,:,source_id)=k_S_All(:,model_id,source_id)';
    end
    f1=figure();
    set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 8 6]);
    hold on;
    Title=['Q Error=',num2str(Q_Err(model_id)*100),'%'];
    %     Title=['Inversion Results (Q Error=',num2str(Q_Err(model_id)*100),'%)'];
    title(Title,'FontSize',FontSize);
%     Plot_Tk(Tk_Orig_All,Tk_P_All,3)
%     Plot_Tk(Tk_Orig_All,Tk_S_All,3)
    Plot_Tk(Tk_Orig_All,Tk_PS_All,3);
%     MT_Name_Cur=char(MT_Name(i));
    %     set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 9 7]);
    %     set(f1,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[0 0 1200 1000]);
    print(f1,'-r300','-dtiff',Title);
end
end
