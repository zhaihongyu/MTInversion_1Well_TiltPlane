% Calculate the inversion error of 4 types moment tensor
% In this version, we choose the little interval of the receivers 
clc;
clear all;
close all;
% % % Set the model parameters
Sample_Int=0.00025;
Model_Num=20;
Model_Id=1:Model_Num;
Radius=100;

% [Wells]=Set_Geometry(Radius);

% [Vp,Vs,Rho,Well,Shot_xyz,Layer_Num,ELayerTime_SR,Qp,Qs]=Set_Model_QV6(Model_Num);
% Calculate the travel time and direction cosin
% [Travel_T1,Direction_Cosin1,SR_Vec_model1]=Cal_TraT_DirCosV3(Vp,Vs,Well,Shot_xyz);

% Generate the ricker wavelet
main_frequency=600;
[Ricker_Derivative]=Gen_Ricker_Der(main_frequency,Sample_Int);
%}

% % % Generate random seismic moment tensor % % %
Sour_Num=1;
[RandomMTs]=Gen_RandomMTs();
RandMT_Num=size(RandomMTs,2);
M_ISO=[1 0 0;0 1 0;0 0 1];
M_LD=[1 0 0;0 0 0;0 0 0];
M_CLVD=[1 0 0;0 -2 0;0 0 1];
M_DC=[0 1 0;1 0 0;0 0 0];

M=zeros(3,3,4);
M(:,:,1)=M_ISO;
M(:,:,2)=M_CLVD;
M(:,:,3)=M_LD;
M(:,:,4)=M_DC;
% 
RandMT_ValueOri=rand(RandMT_Num*6,1);

%
MT=zeros(3,3);
% MT_Base=eye(3);
MT_Base=zeros(3,3);

Tk_Orig_All=zeros(2,RandMT_Num,Sour_Num);
Tk_PS_All=zeros(2,RandMT_Num,Sour_Num);
Tk_P_All=zeros(2,RandMT_Num,Sour_Num);

T_Orig_All=zeros(RandMT_Num,Model_Num,Sour_Num);
k_Orig_All=zeros(RandMT_Num,Model_Num,Sour_Num);
T_PS_All=zeros(RandMT_Num,Model_Num,Sour_Num);
k_PS_All=zeros(RandMT_Num,Model_Num,Sour_Num);
T_P_All=zeros(RandMT_Num,Model_Num,Sour_Num);
k_P_All=zeros(RandMT_Num,Model_Num,Sour_Num);
% Tk_Orig_XY_All=zeros(2,RandMT_Num,Sour_Num);
% Tk_XY_All=zeros(2,RandMT_Num,Sour_Num);
%
Abso_T_Error_PS=zeros(RandMT_Num,Model_Num,Sour_Num);
Abso_k_Error_PS=zeros(RandMT_Num,Model_Num,Sour_Num);
Abso_T_Error_P=zeros(RandMT_Num,Model_Num,Sour_Num);
Abso_k_Error_P=zeros(RandMT_Num,Model_Num,Sour_Num);

AverError_AbsoTk_PS=zeros(Sour_Num,Model_Num,2);
ErrorVariance_AbsoTk_PS=zeros(Sour_Num,Model_Num,2);
AverError_AbsoTk_P=zeros(Sour_Num,Model_Num,2);
ErrorVariance_AbsoTk_P=zeros(Sour_Num,Model_Num,2);
% Rela_Error=zeros(6,RandMT_Num);
%
MTsRandom_Vector=zeros(6,RandMT_Num,4);
MTs4_Vector=zeros(6,4);
Inversion_MTs_PS=zeros(6,RandMT_Num);
Inversion_MTs_P=zeros(6,RandMT_Num);
%
Radius=zeros(1,Model_Num);
for model_id=1:Model_Num
    %     According to the model id, select the geometry
    %     [Wells,Shot,Radius(model_id)]=Set_Geometry1(model_id);
    [Wells,Shot]=Set_Geometry(model_id);
    %     Set the basic parameters
    [Vp,Vs,Rho,Layer_Num,ELayerTime_SR,Qp,Qs]=Set_Model_MultiRec(Wells,Shot);
    % Calculate the travel time and direction cosin
    [Travel_T1,Direction_Cosin1,SR_Vec_model1]=Cal_TraT_DirCosV3(Vp,Vs,Wells,Shot);
%     According to the Q model, calculate the inversion results (Version 2.0)
    %
    
    for i=1:Sour_Num
        Count_Num=1;
        %     Genrate random disturb
        for j=1:RandMT_Num
           
            %         Generate the moment tensor matrix
            MT(1,:)=[RandomMTs(1,j) RandomMTs(2,j) RandomMTs(3,j)];
            MT(2,:)=[RandomMTs(2,j) RandomMTs(4,j) RandomMTs(5,j)];
            MT(3,:)=[RandomMTs(3,j) RandomMTs(5,j) RandomMTs(6,j)];
            %         Generate the P-wave field
            [P_wave1,P_wave_xyz1,PWaveform_XYZ1]=Generate_Pwave_WithQ...
                (Sample_Int,Travel_T1,Direction_Cosin1,SR_Vec_model1,...
                MT,Rho,Vp,Ricker_Derivative,Qp,Layer_Num,ELayerTime_SR);
            %         Generate the S-wave field
            [S_wave1,S_wave_xyz1,SWaveform_XYZ1]=Generate_Swave_WithQ...
                (Sample_Int,Travel_T1,Direction_Cosin1,SR_Vec_model1,...
                MT,Rho,Vs,Ricker_Derivative,Qs,Layer_Num,ELayerTime_SR);
            %         Inversion schedul: d=Am+n
            %             [G_P,G_S]=Inversion_CoeNew(Direction_Cosin1,Rho,Vp,Vs,SR_Vec_model1,Ricker_Derivative);
            %             [PWave_ObsData1,SWave_ObsData1]=Inversion_ObserData(PWaveform_XYZ1,SWaveform_XYZ1);
            
            %             [G_P,G_S,Ricker_EffValue_Idx]=Inversion_CoefficientV2(Direction_Cosin1,Rho,Vp,Vs,SR_Vec_model1,Ricker_Derivative);
            %             [PWave_ObsData1,SWave_ObsData1]=Inversion_ObserDataV2(PWaveform_XYZ1,SWaveform_XYZ1,Ricker_EffValue_Idx);
            
            [G_P,G_S,Ricker_EffValue_Idx]=Inversion_CoefficientV3(Direction_Cosin1,Rho,Vp,Vs,SR_Vec_model1,Ricker_Derivative);
            [PWave_ObsData1,SWave_ObsData1]=Inversion_ObserDataV3(PWaveform_XYZ1,SWaveform_XYZ1,Ricker_EffValue_Idx);
            %             Using the P-wave and S-wave to inverse the moment tensor
            G_PS=[G_P;G_S];
            PSWave_ObsData=[PWave_ObsData1;SWave_ObsData1];
            
            Inversion_m_PS=G_PS\PSWave_ObsData;
            Inversion_MTs_PS(:,i)=Inversion_m_PS;
            %             Using the P-wave to inverse the moment tensor
            
            Inversion_m_P=G_P\PWave_ObsData1;
            Inversion_MTs_P(:,i)=Inversion_m_P;
            %         Calculate the inversion error
%             Abso_TkError(:,i)=MTs_Vector(:,i)-Inversion_m;
            %         Rela_Error(:,i)=abs(Abso_Error(:,i))./MTs_Vector(:,i);
            
            %         Transform the moment tensor to T-k parameters
            [T_k_Orig]=MT_Transform(RandomMTs(:,j,i));
            T_Orig_All(j,model_id,i)=T_k_Orig(1);
            k_Orig_All(j,model_id,i)=T_k_Orig(2);
            
            [T_k_PS]=MT_Transform(Inversion_m_PS);
            T_PS_All(j,model_id,i)=T_k_PS(1);
            k_PS_All(j,model_id,i)=T_k_PS(2);
            
            [T_k_P]=MT_Transform(Inversion_m_P);
            T_P_All(j,model_id,i)=T_k_P(1);
            k_P_All(j,model_id,i)=T_k_P(2);
            
            
            
            Count_Num=Count_Num+1;
            % Calculate the inversion error
            Abso_T_Error_PS(j,model_id,i)=T_k_PS(1)-T_k_Orig(1);
            Abso_k_Error_PS(j,model_id,i)=T_k_PS(2)-T_k_Orig(2);
            
            Abso_T_Error_P(j,model_id,i)=T_k_P(1)-T_k_Orig(1);
            Abso_k_Error_P(j,model_id,i)=T_k_P(2)-T_k_Orig(2);
        end
        %     Plot the original data and inverion data
        %{
        subplot(2,2,per_id)
        f1=figure();
        set(f1,'position',[100 100 800 600])
        hold on
        Plot_Tk(Tk_Orig_All,Tk_All,1)
        MT_Name_Cur=char(MT_Name(i));
        Title=['Inversion Results (',MT_Name_Cur,') - ',num2str(Per_Coeff(per_id)),'% Perturbation'];
        title(Title,'FontSize',18);
        print('-r600','-djpeg',Title);
        %}
    end
    
%     calculate the inversion results (Version 1.0) 
    %{
    Count_Num=1;
%     Generate the moment tensor matrix
    MT=M(:,:,i);
    MTs4_Vector(:,i)=[MT(1,1);MT(1,2);MT(1,3);MT(2,2);MT(2,3);MT(3,3);];
%     Genrate random disturb
    
    for j=1:RandMT_Num
%         According to the iterarion, changing the MT_Vector and adding the random disturbance into it
        MTsRandom_Vector(1,j,i)=MTs4_Vector(1,i)+RandMT_Value((Count_Num-1)*6+1);
        MTsRandom_Vector(2,j,i)=MTs4_Vector(2,i)+RandMT_Value((Count_Num-1)*6+2);
        MTsRandom_Vector(3,j,i)=MTs4_Vector(3,i)+RandMT_Value((Count_Num-1)*6+3);
        MTsRandom_Vector(4,j,i)=MTs4_Vector(4,i)+RandMT_Value((Count_Num-1)*6+4);
        MTsRandom_Vector(5,j,i)=MTs4_Vector(5,i)+RandMT_Value((Count_Num-1)*6+5);
        MTsRandom_Vector(6,j,i)=MTs4_Vector(6,i)+RandMT_Value((Count_Num-1)*6+6);
%         Generate the moment tensor matrix
        MT(1,:)=[MTsRandom_Vector(1,j,i) MTsRandom_Vector(2,j,i) MTsRandom_Vector(3,j,i)];
        MT(2,:)=[MTsRandom_Vector(2,j,i) MTsRandom_Vector(4,j,i) MTsRandom_Vector(5,j,i)];
        MT(3,:)=[MTsRandom_Vector(3,j,i) MTsRandom_Vector(5,j,i) MTsRandom_Vector(6,j,i)];
%         Generate the P-wave field
        [P_wave1,P_wave_xyz1,PWaveform_XYZ1]=Generate_Pwave_WithQ(Travel_T1,Direction_Cosin1,SR_Vec_model1,T_Interval_PS1,...
            MT,Rho,Vp,Ricker_Derivative,Q,Layer_Num,ELayerTime_SR);
%         Generate the S-wave field
        [S_wave1,S_wave_xyz1,SWaveform_XYZ1]=Generate_Swave_WithQ(Travel_T1,Direction_Cosin1,SR_Vec_model1,T_Interval_PS1,...
            MT,Rho,Vs,Ricker_Derivative,Q,Layer_Num,ELayerTime_SR);
%         Inversion schedul: d=Am+n
        [G_P,G_S]=Inversion_CoeNew(Direction_Cosin1,Rho,Vp,Vs,SR_Vec_model1,Ricker_Derivative);
        [PWave_ObsData1,SWave_ObsData1]=ObserData_WithQ(PWaveform_XYZ1,SWaveform_XYZ1);
        
        G=[G_P;G_S];
        PSWave_ObsData=[PWave_ObsData1;SWave_ObsData1];
        
        Inversion_m=G\PSWave_ObsData;
        Inversion_MTs(:,i)=Inversion_m;
%         Calculate the inversion error
%         Abso_Error(:,i)=MTs_Vector(:,i)-Inversion_m;
%         Rela_Error(:,i)=abs(Abso_Error(:,i))./MTs_Vector(:,i);
%         Transform the moment tensor to T-k parameters
        [T_k_Orig]=MT_Transform(MTsRandom_Vector(:,j,i));
        [T_k]=MT_Transform(Inversion_m);
%         Transform the T-k parameters to x-y coordinates
        Tk_Orig_All(:,Count_Num)=T_k_Orig;
        Tk_All(:,Count_Num)=T_k;
        Count_Num=Count_Num+1;
    end
    
%     Plot the original data and inverion data
    Plot_Tk(Tk_Orig_All,Tk_All,1)
    %}
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Plot all the inversed moment tensors by using the P-wave and S-wave or using the S-wave %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%{
FontSize=22;
for model_id=1:Model_Num
    for source_id=1:Sour_Num
        Tk_Orig_All(1,:,source_id)=T_Orig_All(:,model_id,source_id)';
        Tk_Orig_All(2,:,source_id)=k_Orig_All(:,model_id,source_id)';
        
        Tk_PS_All(1,:,source_id)=T_PS_All(:,model_id,source_id)';
        Tk_PS_All(2,:,source_id)=k_PS_All(:,model_id,source_id)';
        
        Tk_P_All(1,:,source_id)=T_P_All(:,model_id,source_id)';
        Tk_P_All(2,:,source_id)=k_P_All(:,model_id,source_id)';
    end
    %
    f1=figure();
    set(f1,'position',[0 0 1400 1200])
    hold on;
    Plot_RandomTks(Tk_Orig_All,Tk_PS_All,2)
    Title=['Inversion Results - Qp=',num2str(Qp(model_id)),', Qs=',num2str(Qs(model_id))];
    %     title(Title,'FontSize',FontSize);
    %     set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 9 7]);
    set(f1,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[0 0 1900 600]);
    print(f1,'-r300','-djpeg',Title);
    %
end
%}
% A new plot code
FontSize=22;
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
    [TkInversion_XY]=Tk_Transform(Tk_PS_All);
    Markersize=6;
    FontSize=22;
    %{
    f1=figure;
    set(f1,'position',[100 100 800 600]);
    axis off;
    hold on
    Plot_SourceTD();
    %             Plot the original data and inverion data on the T-k diagram
    plot(TkOriginal_XY(1,:),TkOriginal_XY(2,:),'ob','Markersize',Markersize,'LineWidth',2);
    t1=title('Original Moment Tensors');
    set(t1,'FontSize',FontSize)
    Title=['Original Moment Tensors'];
    %     title(Title,'FontSize',FontSize);
    %     set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 9 7]);
    set(f1,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[0 0 800 600]);
    print(f1,'-r300','-djpeg',Title);
    %}
    % % % % % % % % % % % % % % % % % % % % % % % %
    f2=figure;
    set(f2,'position',[100 100 800 600]);
    hold on
    axis off;
    Plot_SourceTD();
    %             Plot the original data and inverion data on the T-k diagram
    plot(TkInversion_XY(1,:),TkInversion_XY(2,:),'^r','Markersize',Markersize,'LineWidth',2);
    Title=['Inversed Moment Tensors - Model Id=',num2str(model_id)];
    %     Title=['Inversed Moment Tensors - Radius=',num2str(Radius(model_id))];
    t2=title(Title);
    set(t2,'FontSize',FontSize)
    %         Set the figure propersitie
    %     title(Title,'FontSize',FontSize);
    %     set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 9 7]);
    set(f2,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[0 0 800 600]);
    print(f2,'-r300','-djpeg',Title);
end
f1=figure;
set(f1,'position',[100 100 800 600]);
axis off;
hold on
Plot_SourceTD();
%             Plot the original data and inverion data on the T-k diagram
plot(TkOriginal_XY(1,:),TkOriginal_XY(2,:),'ob','Markersize',Markersize,'LineWidth',2);
t1=title('Original Moment Tensors');
set(t1,'FontSize',FontSize)
Title=['Original Moment Tensors'];
%     title(Title,'FontSize',FontSize);
%     set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 9 7]);
set(f1,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[0 0 800 600]);
print(f1,'-r300','-djpeg',Title);
%}

% Calculate the average error and error variance
AverError_Abso_Tk_PS=zeros(Sour_Num,Model_Num);
ErrorVariance_Abso_Tk_PS=zeros(Sour_Num,Model_Num);
AverError_Abso_Tk_P=zeros(Sour_Num,Model_Num);
ErrorVariance_Abso_Tk_P=zeros(Sour_Num,Model_Num);
for i=1:Sour_Num
    for model_id=1:Model_Num
        % Calculate the average error and error variance by using P-wave
        % and S-wave
        AverError_AbsoTk_PS(i,model_id,1)=mean(Abso_T_Error_PS(:,model_id,i));
        AverError_AbsoTk_PS(i,model_id,2)=mean(Abso_k_Error_PS(:,model_id,i));
        %         AverError_Abso_Tk(i,model_id)=(AverError_AbsoTk(i,model_id,1)+AverError_AbsoTk(i,model_id,2))/2;
        
        ErrorVariance_AbsoTk_PS(i,model_id,1)=var(Abso_T_Error_PS(:,model_id,i));
        ErrorVariance_AbsoTk_PS(i,model_id,2)=var(Abso_k_Error_PS(:,model_id,i));
        %         ErrorVariance_Abso_Tk(i,model_id)=sqrt((ErrorVariance_AbsoTk(i,model_id,1))^2+(ErrorVariance_AbsoTk(i,model_id,1))^2);
        
        % Calculate the average error and error variance by using P-wave
        AverError_AbsoTk_P(i,model_id,1)=mean(Abso_T_Error_P(:,model_id,i));
        AverError_AbsoTk_P(i,model_id,2)=mean(Abso_k_Error_P(:,model_id,i));
        %         AverError_Abso_Tk(i,model_id)=(AverError_AbsoTk(i,model_id,1)+AverError_AbsoTk(i,model_id,2))/2;
        
        ErrorVariance_AbsoTk_P(i,model_id,1)=var(Abso_T_Error_P(:,model_id,i));
        ErrorVariance_AbsoTk_P(i,model_id,2)=var(Abso_k_Error_P(:,model_id,i));
        %         ErrorVariance_Abso_Tk(i,model_id)=sqrt((ErrorVariance_AbsoTk(i,model_id,1))^2+(ErrorVariance_AbsoTk(i,model_id,1))^2);
    end
    %     Plot the absolute inversion error of every kind of source
    %{
    f2=figure();
    hold on
    set(f2,'position',[100 100 500 400])
    errorbar(Model_Id,AverError_AbsoTk(i,:,1),ErrorVariance_AbsoTk(i,:,1),'-k','LineWidth',2.5)
    errorbar(Model_Id,AverError_AbsoTk(i,:,2),ErrorVariance_AbsoTk(i,:,2),':g','LineWidth',2.5)
    %{
    for j=1:RandMT_Num
%         T_Error=Abso_TkError(1,j,:);
%         k_Error=Abso_TkError(1,j,:);
        p1=plot(x,Abso_TkError(j,:,1),'*-r',x,Abso_TkError(j,:,2),'o-b');
    end
    %}
    grid on
    l1=legend('T','k');
    set(l1,'Location','SouthEast');
    xlabel('Model Id','FontSize',12);
    ylabel('Mean','FontSize',12);
    set(gca,'YLim',[-0.8 0.8],'FontSize',12)
    
    MT_Name_Cur=char(MT_Name(i));
    Title=['Absolute Error of T-k (',MT_Name_Cur,' Sources)'];
    title(Title,'FontSize',12);
    print('-r600','-dbmp',Title);
    %}
end

%     


% Plot  the average error  of Tk for all the sources
%{
f3=figure();
hold on
grid on
set(f3,'position',[100 100 500 400])
x=1:Model_Num;
plot(x,AverError_AbsoTk(1,:,1),'-or','LineWidth',2.5)
plot(x,AverError_AbsoTk(2,:,1),'-^b','LineWidth',2.5)
plot(x,AverError_AbsoTk(3,:,1),'-dk','LineWidth',2.5)
plot(x,AverError_AbsoTk(4,:,1),'-sg','LineWidth',2.5)
xlabel('Model Id','FontSize',12);
ylabel('Mean','FontSize',12);
set(gca,'FontSize',12,'YLim',[-1 1],'XLim',[0 7])
l2=legend('T-ISO','T-CLVD','T-LVD','T-DC');
set(l2,'Location','NorthWest');
% MT_Name_Cur=char(MT_Name(i));
Title=['Absolute Error of T (Using P wave)'];
title(Title,'FontSize',12);
print('-r600','-djpeg',Title);

f4=figure();
hold on
grid on
set(f4,'position',[100 100 500 400])
plot(x,AverError_AbsoTk(1,:,2),':or','LineWidth',2.5)
plot(x,AverError_AbsoTk(2,:,2),':^b','LineWidth',2.5)
plot(x,AverError_AbsoTk(3,:,2),':dk','LineWidth',2.5)
plot(x,AverError_AbsoTk(4,:,2),':sg','LineWidth',2.5)
xlabel('Model Id','FontSize',12);
ylabel('Mean','FontSize',12);
set(gca,'YLim',[-1 1],'FontSize',12,'XLim',[0 7])
l3=legend('k-ISO','k-CLVD','k-LVD','k-DC');
set(l3,'Location','SouthEast');
Title=['Absolute Error of k (Using P wave)'];
title(Title,'FontSize',12);
print('-r600','-dbmp',Title);
%}

% Plot  the average error and error variance of Tk for all the sources
%{
f5=figure();
hold on
grid on
set(f5,'position',[100 100 500 400])
x=[10 20 40 60];
errorbar(x,AverError_Abso_Tk(1,:),ErrorVariance_Abso_Tk(1,:),'-.r','LineWidth',2.5)
errorbar(x,AverError_Abso_Tk(2,:),ErrorVariance_Abso_Tk(2,:),'-.b','LineWidth',2.5)
errorbar(x,AverError_Abso_Tk(3,:),ErrorVariance_Abso_Tk(3,:),'-.k','LineWidth',2.5)
errorbar(x,AverError_Abso_Tk(4,:),ErrorVariance_Abso_Tk(4,:),'-.g','LineWidth',2.5)
xlabel('Perturbation Coefficient (%)','FontSize',12);
ylabel('Mean & Variance','FontSize',12);
set(gca,'YLim',[-1 1],'FontSize',12)
l3=legend('k-ISO','k-CLVD','k-LVD','k-DC');
set(l3,'Location','NorthWest');
Title=['Absolute Error of T-k (All Sources)'];
title(Title,'FontSize',12);
print('-r600','-dbmp',Title);
%}

%{
title('Absolute Error of Moment Tensors Inversion ');
subplot(1,2,2)
for i=1:4
    Plot(x,Rela_Error(:,i),'*');
end

title('Relative Error of Moment Tensors Inversion');
% set(h1,'position',[100 100 1600 600]);

%}
% Test the moment tensor inversion (One kind of moment tensor)
% OneMT();
% 
