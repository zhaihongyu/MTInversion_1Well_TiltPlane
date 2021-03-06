% Calculate the inversion error of 4 types moment tensor in different Q %
% error model 2015-5-30 %
% In this version, we choose the little interval of the receivers 
clc;
clear all;
close all;

%% Identify the random moment tensor number 
Random_Type=1;
% Rand_Type=1: generate 4 kinds of pure moment tensors
% Rand_Type=2: genrate 4 kinds of  single random moment tensors
% Rand_Type=3: generate 4 kinds of multiple random moment tensors
[MTs]=Gen_4MTs(Random_Type);
% 4 types of basic seismic moment tensor % % %
MT_Type_Num=4;
% 4 base seismic moment tensors 2015-4-27 %
M_ISO=2/3*[1 0 0;0 1 0;0 0 1];
M_DC=[1 0 0;0 0 0;0 0 -1];
M_CLVD_Neg=2/3*[1 0 0;0 1 0;0 0 -2];
M_CLVD_Pos=2/3*[2 0 0;0 -1 0;0 0 -1];

Input_MT=zeros(3,3);

% Original T-k variable value
Tk_Original=cell(1,MT_Type_Num);
% Define the decomposition of single MT
Original_MTs_Decom=cell(1,MT_Type_Num);
for i=1:MT_Type_Num
    Current_MTs_6xN=MTs{i};
    % Decompose the original MT and inversed MT
    Original_MTs_Decom{i}=Decompose_MT(Current_MTs_6xN);
    % Transform the vector of moment tensor to T-k parameters 2015-11-9 %
    Tk_Original{i}=MT_To_Tk(Current_MTs_6xN);
end

%% Set the geometry 2015-5-30 %
% Set the interface type: 
% 1=>'1 tilt well under horizontal interface', 
% 2=>'1 vertical well under tilt interface',
% 3=>'Rotating 1 vertical well under horizontal interface'
Interface_Type=3;
[Receivers_AllModel,Shot,Vp,Vs,Layer_Z,Plane_Function,Model_Num]=...
    Set_Geometry_1Well_V1(Interface_Type);
%% Set the model parameters
Sample_Int=0.00025;

% Calculate the model number 2015-5-30 %
Model_Id=1:Model_Num;
% [Azimuth,Model_Num]=Cal_Azimuth(Well_Num);

% Generate the ricker wavelet derivative 2015-5-29 %
main_frequency=600;
[Ricker_Derivative]=Gen_Ricker_Der(main_frequency,Sample_Int);

% Inversed T-k variable value by different wave form
Tk_Inversed_PS=cell(Model_Num,MT_Type_Num);
Tk_Inversed_P=cell(Model_Num,MT_Type_Num);
Tk_Inversed_S=cell(Model_Num,MT_Type_Num);
% Define the decomposition of single MT
Inversed_MTs_Decom=cell(Model_Num,MT_Type_Num);
% Inversion Error Parameters
Abso_Tk_Error_PS=cell(Model_Num,MT_Type_Num);
Abso_Tk_Error_P=cell(Model_Num,MT_Type_Num);
Abso_Tk_Error_S=cell(Model_Num,MT_Type_Num);

% Condition number parameters of the kernel matrix 2015-4-27 %
Kernel_Cond=zeros(Model_Num,2);
% Kernel_Cond_Rand=zeros(2,RandMT_Num);

% Sensitivity of the kernel matrix 2015-4-27 %
Sensi_Kernel_Rand=zeros(2,6);
Sensi_Kernel=zeros(Model_Num,6,2);

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
    
    for mt_type_id=1:MT_Type_Num
        %Generate pure MT or random MT by changing the Pre_Coe (0 or non-0)
        Current_MTs_6xN=MTs{mt_type_id};
        RandMT_Num=size(Current_MTs_6xN,2);
        
        Inversion_MTs_P=zeros(6,RandMT_Num);
        Inversion_MTs_S=zeros(6,RandMT_Num);
        Inversion_MTs_PS=zeros(6,RandMT_Num);
        %     Generate the moment tensor matrix
        Input_MT=zeros(3,3);
        for j=1:RandMT_Num
            %% Generate the moment tensor matrix
            Input_MT=[Current_MTs_6xN(1:3,j)';...
                Current_MTs_6xN(2,j),Current_MTs_6xN(4:5,j)';...
                Current_MTs_6xN(3,j),Current_MTs_6xN(5,j),Current_MTs_6xN(6,j)];
            %% Forward modeling procedure
            %  Generate the P-wave field without attenuation 2015-9-16 %
            [PWavefield_xyz1,PWaveform_OriXYZ]=...
                Generate_Pwave(Sample_Int,TravelTime_AllWave,DirectionCos_P,...
                TravelDistance,Input_MT,Rho,Average_VpVs_DirRef,Ricker_Derivative);
            % Generate the S-wave field without attenuation 2015-9-16 %
            [SWavefiled_xyz1,SWaveform_OriXYZ]=...
                Generate_Swave(Sample_Int,TravelTime_AllWave,DirectionCos_S,...
                TravelDistance,Input_MT,Rho,Average_VpVs_DirRef,Ricker_Derivative);            
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
            
            % Using the P & S-wave to inverse the moment tensor 2015-5-31 %
            G_PS=[G_P;G_S];
            PSWave_ObsData=[PWave_ObsData1;SWave_ObsData1];
            %             Inversion_m_PS=G_PS\PSWave_ObsData;
            Inversion_MTs_PS(:,j)=lsqlin(G_PS,PSWave_ObsData);
            
            
        end
        %% Inversion results processing procedure
        
        % Decompose the  inversed MT
        Inversed_MTs_Decom{model_id,mt_type_id}=Decompose_MT(Inversion_MTs_PS);
        
        % Transform the vector of moment tensor to T-k parameters 2015-11-9 %
        [Tk_Inversed_CurrMTs_PS]=MT_To_Tk(Inversion_MTs_PS);
        [Tk_Inversed_CurrMTs_P]=MT_To_Tk(Inversion_MTs_P);
        %         [Tk_Inversed_CurrMTs_S]=MT_To_Tk(Inversion_MTs_S);  
        % Combine the Tk coordinates of inversed MT 2015-11-9 %
        Tk_Inversed_PS{model_id,mt_type_id}=Tk_Inversed_CurrMTs_PS;
        Tk_Inversed_P{model_id,mt_type_id}=Tk_Inversed_CurrMTs_P;
        
        % Calculate the inversion error 2015-6-7 %
        Abso_Tk_Error_PS{model_id,mt_type_id}=Tk_Inversed_CurrMTs_PS-Tk_Original{mt_type_id};
        Abso_Tk_Error_P{model_id,mt_type_id}=Tk_Inversed_CurrMTs_P-Tk_Original{mt_type_id};
        %         Abso_Tk_Error_S(j,model_id,mt_type_id)=Tk_Inversed_CurrMTs_S-Tk_Original_CurrMTs;
        
    end
    %Calculate the average condition number of kernel matrix 2015-4-10 %
    %{
    Kernel_Cond(model_id,1)=cond(G_PS);
    Kernel_Cond(model_id,2)=cond(G_P);
    %}
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
Plot_InvRes_4MTs_Eves(Tk_Original,Tk_Inversed_PS,Tk_Inversed_P,Tk_Inversed_S)
%}

% Plot all the inversed moment tensors by using the P-wave and S-wave or
% using the S-wave in the order of Q error 2015-7-14 %
%{
Plot_InvRes_4Mts_QErrs(Model_Num,RandMT_Num,Sour_Num,Q_Err,T_Orig_All,k_Orig_All,...
    T_PS_All,k_PS_All,T_P_All,k_P_All,T_S_All,k_S_All);
%}

%Plot the absolute inversion error of every kind of source by using P&S, P and S wave respectivly 2015-7-1 %
% Plot_TkErr(Q_Err,AverError_AbsoTk_PS,AverError_AbsoTk_P,AverError_AbsoTk_S);

%Plot the absolute inversion error of every kind of source by using P&S and P wave respectivly 2015-6-7 %
% Plot_TkErr_VariousGeometry(Model_Id,AverError_AbsoTk_PS,ErrorVariance_AbsoTk_PS,...
%     AverError_AbsoTk_P,ErrorVariance_AbsoTk_P)

% According to the original and inversed MT, plot the decomposition results
% and the inversion error 2015-11-4
Plot_Decomposed_MT(Original_MTs_Decom,Inversed_MTs_Decom)