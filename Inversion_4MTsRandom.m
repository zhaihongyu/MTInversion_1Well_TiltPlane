% Calculate the inversion error of 4 types moment tensor in different Q %
% error model 2015-5-30 %
% In this version, we choose the little interval of the receivers 
clc;
clear all;
close all;


%% Set the geometry 2015-5-30 %
% Set the interface type: 
% 1=>'1 tilt well under horizontal interface', 
% 2=>'1 vertical well under tilt interface',
% 3=>'Rotating 1 vertical well under horizontal interface'
Interface_Type=3;
[Receivers_AllModel,Shot,Vp,Vs,Layer_Z,Plane_Function,Model_Num]=Set_Geometry_1Well_V1(Interface_Type);
%% Set the model parameters
Sample_Int=0.00025;

% Calculate the model number 2015-5-30 %
Model_Id=1:Model_Num;
% [Azimuth,Model_Num]=Cal_Azimuth(Well_Num);

% Generate the ricker wavelet derivative 2015-5-29 %
main_frequency=600;
[Ricker_Derivative]=Gen_Ricker_Der(main_frequency,Sample_Int);

% % % 4 types of basic seismic moment tensor % % %
Sour_Num=4;
%{
M_ISO=[1 0 0;0 1 0;0 0 1];
M_LD=[1 0 0;0 0 0;0 0 0];
M_CLVD=[1 0 0;0 -2 0;0 0 1];
M_DC=[0 1 0;1 0 0;0 0 0];

M=zeros(3,3,4);
M(:,:,1)=M_ISO;
M(:,:,2)=M_CLVD;
M(:,:,3)=M_LD;
M(:,:,4)=M_DC;
%}
% 4 base seismic moment tensors 2015-4-27 %
M_ISO=2/3*[1 0 0;0 1 0;0 0 1];
M_DC=[1 0 0;0 0 0;0 0 -1];
M_CLVD_Neg=2/3*[1 0 0;0 1 0;0 0 -2];
M_CLVD_Pos=2/3*[2 0 0;0 -1 0;0 0 -1];

M=zeros(3,3,4);
M(:,:,1)=M_ISO;
M(:,:,2)=M_DC;
M(:,:,3)=M_CLVD_Neg;
M(:,:,4)=M_CLVD_Pos;

% Identify the random moment tensor number 
RandMT_Num=1;
Per_Coe=0.3;
RandMT_ValueOri=rand(RandMT_Num*6,1);

%
MT=zeros(3,3);
% MT_Base=eye(3);
MT_Base=zeros(3,3);

% Original T-k variable value
T_Orig_All=zeros(RandMT_Num,Model_Num,Sour_Num);
k_Orig_All=zeros(RandMT_Num,Model_Num,Sour_Num);

% Inversed T-k variable value by different wave form
T_PS_All=zeros(RandMT_Num,Model_Num,Sour_Num);
k_PS_All=zeros(RandMT_Num,Model_Num,Sour_Num);
T_P_All=zeros(RandMT_Num,Model_Num,Sour_Num);
k_P_All=zeros(RandMT_Num,Model_Num,Sour_Num);
T_S_All=zeros(RandMT_Num,Model_Num,Sour_Num);
k_S_All=zeros(RandMT_Num,Model_Num,Sour_Num);

% Define the decomposition of single MT
Original_SingleMT_Decom=zeros(RandMT_Num,3);
Inversed_SingleMT_Decom=zeros(RandMT_Num,3);
Original_MTs_Decom=zeros(Sour_Num*RandMT_Num,3,Model_Num);
Inversed_MTs_Decom=zeros(Sour_Num*RandMT_Num,3,Model_Num);

% Inversion Error Parameters
Abso_T_Error_PS=zeros(RandMT_Num,Model_Num,Sour_Num);
Abso_k_Error_PS=zeros(RandMT_Num,Model_Num,Sour_Num);
Abso_T_Error_P=zeros(RandMT_Num,Model_Num,Sour_Num);
Abso_k_Error_P=zeros(RandMT_Num,Model_Num,Sour_Num);
Abso_T_Error_S=zeros(RandMT_Num,Model_Num,Sour_Num);
Abso_k_Error_S=zeros(RandMT_Num,Model_Num,Sour_Num);

% Rela_Error=zeros(6,RandMT_Num);
%
MTsRandom_Vector=zeros(6,RandMT_Num,4);
MTs4_Vector=zeros(6,4);
Inversion_MTs_PS=zeros(6,RandMT_Num);
Inversion_MTs_P=zeros(6,RandMT_Num);
Inversion_MTs_S=zeros(6,RandMT_Num);
% Condition number parameters of the kernel matrix 2015-4-27 %
Kernel_Cond=zeros(Model_Num,2);
% Kernel_Cond_Rand=zeros(2,RandMT_Num);

% Sensitivity of the kernel matrix 2015-4-27 %
Sensi_Kernel_Rand=zeros(2,6);
Sensi_Kernel=zeros(Model_Num,6,2);

% Attenuated energy parameters 2015-4-23 %
Attenuated_Energy=zeros(Model_Num,2);
% angle of elevation for every well 2015-4-23 %
Angle_Ele=zeros(1,Model_Num);

%% Generate and plot the P&S-wave field of  CLVD MT
[TravelDistance,TravelTime_AllWave,Average_VpVs_DirRef,...
    DirectionCos_P,DirectionCos_S,Rho]=...
    Cal_WaveTraveling(Receivers_AllModel(:,:,1),Shot,Vp,Vs,Layer_Z,Plane_Function);
dB=60;
% dB=0;
%
Gen_Wavefield(Sample_Int,TravelTime_AllWave,DirectionCos_P,DirectionCos_S,TravelDistance,M_CLVD_Neg,Rho,...
    Average_VpVs_DirRef,Ricker_Derivative,dB)
%}
%%According to different observing well, calculate the inversion error
for model_id=1:Model_Num
    Receivers=Receivers_AllModel(:,:,model_id);
    %Calculate the basic wave traveling parameters
    ff=figure();
    [TravelDistance,TravelTime_AllWave,Average_VpVs_DirRef,...
        DirectionCos_P,DirectionCos_S,Rho]=...
        Cal_WaveTraveling(Receivers,Shot,Vp,Vs,Layer_Z,Plane_Function);
    close(ff) 
    %Using four kinds of MT (one by one) to test the inversion problem
    for i=1:Sour_Num
        %Generate pure MT or random MT by changing the Pre_Coe (0 or non-0)
        RandMT_Value=RandMT_ValueOri*Per_Coe;
%         RandMT_Value=RandMT_ValueOri*0;
        Count_Num=1;
        
        %     Generate the moment tensor matrix
        MT=M(:,:,i);
        MTs4_Vector(:,i)=[MT(1,1);MT(1,2);MT(1,3);MT(2,2);MT(2,3);MT(3,3);];
        %     Genrate random disturb
        for j=1:RandMT_Num
            %According to the iterarion, changing the MT_Vector and adding the random disturbance into it
            MTsRandom_Vector(1,j,i)=MTs4_Vector(1,i)+RandMT_Value((Count_Num-1)*6+1);
            MTsRandom_Vector(2,j,i)=MTs4_Vector(2,i)+RandMT_Value((Count_Num-1)*6+2);
            MTsRandom_Vector(3,j,i)=MTs4_Vector(3,i)+RandMT_Value((Count_Num-1)*6+3);
            MTsRandom_Vector(4,j,i)=MTs4_Vector(4,i)+RandMT_Value((Count_Num-1)*6+4);
            MTsRandom_Vector(5,j,i)=MTs4_Vector(5,i)+RandMT_Value((Count_Num-1)*6+5);
            MTsRandom_Vector(6,j,i)=MTs4_Vector(6,i)+RandMT_Value((Count_Num-1)*6+6);
            %Generate the moment tensor matrix
            MT(1,:)=[MTsRandom_Vector(1,j,i) MTsRandom_Vector(2,j,i) MTsRandom_Vector(3,j,i)];
            MT(2,:)=[MTsRandom_Vector(2,j,i) MTsRandom_Vector(4,j,i) MTsRandom_Vector(5,j,i)];
            MT(3,:)=[MTsRandom_Vector(3,j,i) MTsRandom_Vector(5,j,i) MTsRandom_Vector(6,j,i)];
            
            %% Forward modeling procedure
            %  Generate the P-wave field without attenuation 2015-9-16 %
            [PWavefield_xyz1,PWaveform_OriXYZ]=...
                Generate_Pwave(Sample_Int,TravelTime_AllWave,DirectionCos_P,...
                TravelDistance,MT,Rho,Average_VpVs_DirRef,Ricker_Derivative);
            % Generate the S-wave field without attenuation 2015-9-16 %
            [SWavefiled_xyz1,SWaveform_OriXYZ]=...
                Generate_Swave(Sample_Int,TravelTime_AllWave,DirectionCos_S,...
                TravelDistance,MT,Rho,Average_VpVs_DirRef,Ricker_Derivative);            
            % Generate the observe data and kernel matrix without attenuation 2015-9-16 %
            [G_P,G_S,Ricker_EffValue_Idx]=Inversion_CoefficientV3...
                (DirectionCos_P,DirectionCos_S,Rho,Average_VpVs_DirRef,TravelDistance,Ricker_Derivative,Sample_Int);
            %}
            % Generate the noisy observedata for the inversion
            [PWave_ObsData1,SWave_ObsData1]=Inversion_ObserData_Noise...
                (PWaveform_OriXYZ,SWaveform_OriXYZ,Ricker_EffValue_Idx,dB);
            
            %  Generate the P-wave field with attenuation 2015-5-31 %
            %{
            [PWavefield_xyz1,PWaveform_OriXYZ,PWaveform_XYZ1]=...
                Generate_Pwave_WithQ(Sample_Int,TravelTime_AllWave,DirectionCos_P,...
                TravelDistance,MT,Rho,Average_VpVs_DirRef,Ricker_Derivative,SRLayers_DirRef_Qp,TravelTime_P);
            
            % Generate the S-wave field with attenuation 2015-5-31 %
            %
            [SWavefiled_xyz1,SWaveform_OriXYZ,SWaveform_XYZ1]=...
                Generate_Swave_WithQ(Sample_Int,TravelTime_AllWave,DirectionCos_S,...
                TravelDistance,MT,Rho,Average_VpVs_DirRef,Ricker_Derivative,SRLayers_DirRef_Qs,TravelTime_S);
            %
            % Generate the observe data and kernel matrix without attenuation 2015-5-31 %
            %
            [G_P,G_S]=...
                Inversion_CoeNew(Direction_Cosin1,Rho,Vp,Vs,SR_Vec_model1,Ricker_Derivative);
            [PWave_ObsData1,SWave_ObsData1]=...
                Inversion_ObserData(PWaveform_XYZ1,SWaveform_XYZ1);
            
            [G_P,G_S,Ricker_EffValue_Idx]=...
                Inversion_CoefficientV2(Direction_Cosin1,Rho,Vp,Vs,SR_Vec_model1,Ricker_Derivative);
            [PWave_ObsData1,SWave_ObsData1]=...
                Inversion_ObserDataV2(PWaveform_XYZ1,SWaveform_XYZ1,Ricker_EffValue_Idx);
            %}

            %Generate the observe data and kernel matrix with attenuation 2015-9-10 %
            %{
            [G_P,G_S,Ricker_EffValue_Idx,PWaveform_XYZ_Q_Test,SWaveform_XYZ_Q_Test]=Inversion_CoefficientV3...
                (DirectionCos_P,DirectionCos_S,Rho,Average_VpVs_DirRef,SRLayers_DirRef_Qp,SRLayers_DirRef_Qs,...
                TravelDistance,Ricker_Derivative,Sample_Int,TravelTime_P,TravelTime_S,MT);
            %}

            
            %% Inverson procedure
            % Using the P-wave to inverse the moment tensor 2015-5-31 %
            Inversion_MTs_P(:,j)=lsqlin(G_P,PWave_ObsData1);
            
            % Using the S-wave to inverse the moment tensor 2015-5-31 %
            Inversion_MTs_S(:,j)=lsqlin(G_S,SWave_ObsData1);
            
            % Using the P & S-wave to inverse the moment tensor %
            % 2015-5-31 %
            G_PS=[G_P;G_S];
            PSWave_ObsData=[PWave_ObsData1;SWave_ObsData1];
            %             Inversion_m_PS=G_PS\PSWave_ObsData;
            Inversion_MTs_PS(:,j)=lsqlin(G_PS,PSWave_ObsData);
            
            %% Inversion results processing procedure
            % Decompose the original MT and inversed MT
            Original_SingleMT_Decom(j,:)=Decompose_MT(MT);
            % Transform the inversed MT vector into matirx
            Inversed_MT_Matrix=[Inversion_MTs_PS(1:3,j)';...
                Inversion_MTs_PS(2,j),Inversion_MTs_PS(4:5,j)';...
                Inversion_MTs_PS(3,j),Inversion_MTs_PS(5:6,j)'];
            Inversed_SingleMT_Decom(j,:)=Decompose_MT(Inversed_MT_Matrix);
            % Transform the moment tensor to T-k parameters 2015-6-7 %
            [T_k_Orig]=MT_To_Tk(MTsRandom_Vector(:,j,i));
            T_Orig_All(j,model_id,i)=T_k_Orig(1);
            k_Orig_All(j,model_id,i)=T_k_Orig(2);
            
            [T_k_PS]=MT_To_Tk(Inversion_MTs_PS(:,j));
            T_PS_All(j,model_id,i)=T_k_PS(1);
            k_PS_All(j,model_id,i)=T_k_PS(2);
            
            [T_k_P]=MT_To_Tk(Inversion_MTs_P(:,j));
            T_P_All(j,model_id,i)=T_k_P(1);
            k_P_All(j,model_id,i)=T_k_P(2);
            
            %             [T_k_S]=MT_Transform(Inversion_m_S);
            %             T_S_All(j,model_id,i)=T_k_S(1);
            %             k_S_All(j,model_id,i)=T_k_S(2);
            
            
            Count_Num=Count_Num+1;
            % Calculate the inversion error 2015-6-7 %
            Abso_T_Error_PS(j,model_id,i)=T_k_PS(1)-T_k_Orig(1);
            Abso_k_Error_PS(j,model_id,i)=T_k_PS(2)-T_k_Orig(2);
            
            Abso_T_Error_P(j,model_id,i)=T_k_P(1)-T_k_Orig(1);
            Abso_k_Error_P(j,model_id,i)=T_k_P(2)-T_k_Orig(2);
            
            %             Abso_T_Error_S(j,model_id,i)=T_k_S(1)-T_k_Orig(1);
            %             Abso_k_Error_S(j,model_id,i)=T_k_S(2)-T_k_Orig(2);
        end
        % Combine the decomposotion of original and inversed MT 
        Original_MTs_Decom((i-1)*RandMT_Num+1:i*RandMT_Num,:,model_id)=Original_SingleMT_Decom;
        Inversed_MTs_Decom((i-1)*RandMT_Num+1:i*RandMT_Num,:,model_id)=Inversed_SingleMT_Decom;
    end
    %Calculate the average condition number of kernel matrix
    % 2015-4-10 %
    Kernel_Cond(model_id,1)=cond(G_PS);
    Kernel_Cond(model_id,2)=cond(G_P);
    %{
    Kernel_Cond(model_id,1)=cond(G_PS'*G_PS);
    Kernel_Cond(model_id,2)=cond(G_P'*G_P);
    %}
    
    %Calculate the sensitivity of kernel matrix 2015-4-27 %
    %{
    [U1,S1,V1]=svd(G_PS); 
    [U2,S2,V2]=svd(G_P);
    [U1,S1,V1]=svd(G_PS'*G_PS);
    [U2,S2,V2]=svd(G_P'*G_P);
    Sensi_Kernel(model_id,:,1)=diag(S1);
    Sensi_Kernel(model_id,:,2)=diag(S2);
    %}
end
%%
% Plot the only one inversed moment tensor by using the P & S-wave or
% only using the P-wave in the order of MT type 2015-7-15 %
%{
Plot_InvRes_4MTs_1Eve(Model_Num,RandMT_Num,Sour_Num,Q_Err,T_Orig_All,k_Orig_All,...
    T_PS_All,k_PS_All,T_P_All,k_P_All,T_S_All,k_S_All)
%}

% Plot all the inversed moment tensors by using the P & S-wave or
% only using the P-wave in the order of MT type 2015-7-14 %
%
Plot_InvRes_4MTs_Eves(Model_Num,RandMT_Num,Sour_Num,Model_Id,T_Orig_All,k_Orig_All,...
    T_PS_All,k_PS_All,T_P_All,k_P_All,T_S_All,k_S_All)
%}

% Plot all the inversed moment tensors by using the P-wave and S-wave or
% using the S-wave in the order of Q error 2015-7-14 %
%{
Plot_InvRes_4Mts_QErrs(Model_Num,RandMT_Num,Sour_Num,Q_Err,T_Orig_All,k_Orig_All,...
    T_PS_All,k_PS_All,T_P_All,k_P_All,T_S_All,k_S_All);
%}

% Generate the new results 2015-7-8 %
%{
Tk_Orig_All=zeros(2,RandMT_Num,Sour_Num);
Tk_All_New=zeros(2,RandMT_Num,Sour_Num);
FontSize=9;
for model_id=1:Model_Num
    for source_id=1:4
        Tk_Orig_All(1,:,source_id)=T_Orig_All(:,model_id,source_id)';
        Tk_Orig_All(2,:,source_id)=k_Orig_All(:,model_id,source_id)';
    end
    %  Generate the new inversion results of 4 basic MTs 2015-7-8 %
    % ISO
    Tk_All_New(1,:,1)=T_PS_All(:,model_id,1)';
    Tk_All_New(2,:,1)=k_PS_All(:,model_id,1)';
    % DC
    Tk_All_New(1,:,2)=T_PS_All(:,model_id,2)';
    Tk_All_New(2,:,2)=k_P_All(:,model_id,2)';
    % -CLVD
    Tk_All_New(1,:,3)=T_PS_All(:,model_id,3)';
    Tk_All_New(2,:,3)=k_P_All(:,model_id,3)';
    % +CLVD
    Tk_All_New(1,:,4)=T_PS_All(:,model_id,4)';
    Tk_All_New(2,:,4)=k_P_All(:,model_id,4)';
    %     Plot the Results 2015-7-8 %
    f1=figure();
    set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 8 6]);
    hold on;
    Title=['New Results Q Error=',num2str(Q_Err(model_id)*100),'%'];
    %     Title=['Inversion Results (Q Error=',num2str(Q_Err(model_id)*100),'%)'];
    title(Title,'FontSize',FontSize);
    Plot_Tk(Tk_Orig_All,Tk_All_New,3)
    %     set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 9 7]);
    %     set(f1,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[0 0 1200 1000]);
    print(f1,'-r300','-dtiff',Title);
end
%}
% Plot the legend figure 2015-6-24 %
% Plot_Tk_Legend(Tk_Orig_All,Tk_PS_All);

%}
%%
% Calculate the average error and error variance 2015-6-7 %
% ???
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
for i=1:4
    for model_id=1:Model_Num
        % Calculate the average error and error variance by using P&S-wave
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
        
        % Calculate the average error and error variance by using S-wave
        %         AverError_AbsoTk_S(i,model_id,1)=mean(Abso_T_Error_S(:,model_id,i));
        %         AverError_AbsoTk_S(i,model_id,2)=mean(Abso_k_Error_S(:,model_id,i));
        %         AverError_Abso_Tk(i,model_id)=(AverError_AbsoTk(i,model_id,1)+AverError_AbsoTk(i,model_id,2))/2;
        
        %         ErrorVariance_AbsoTk_S(i,model_id,1)=var(Abso_T_Error_S(:,model_id,i));
        %         ErrorVariance_AbsoTk_S(i,model_id,2)=var(Abso_k_Error_S(:,model_id,i));
        %         ErrorVariance_Abso_Tk(i,model_id)=sqrt((ErrorVariance_AbsoTk(i,model_id,1))^2+(ErrorVariance_AbsoTk(i,model_id,1))^2);
    end
end
%%

%Plot the absolute inversion error of every kind of source by using P&S, P and S wave respectivly 2015-7-1 %
% Plot_TkErr(Q_Err,AverError_AbsoTk_PS,AverError_AbsoTk_P,AverError_AbsoTk_S);

%Plot the absolute inversion error of every kind of source by using P&S and P wave respectivly 2015-6-7 %
% Plot_TkErr_VariousGeometry(Model_Id,AverError_AbsoTk_PS,ErrorVariance_AbsoTk_PS,...
%     AverError_AbsoTk_P,ErrorVariance_AbsoTk_P)

% According to the original and inversed MT, plot the decomposition results
% and the inversion error 2015-11-4
Plot_Decomposed_MT(Original_MTs_Decom,Inversed_MTs_Decom)