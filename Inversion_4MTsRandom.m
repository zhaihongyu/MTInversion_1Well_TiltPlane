% Calculate the inversion error of 4 types moment tensor in different Q %
% error model 2015-5-30 %
% In this version, we choose the little interval of the receivers 
clc;
clear all;
close all;


%% Set the geometry 2015-5-30 %
% Set the interface type: 1=>'Horizontal interface', 2=>'Tilt interface'
Interface_Type=2;
[Receivers,Shot,Well_Num,Vp,Vs,Layer_Z,Plane_Function]=Set_Geometry_1Well_V1(Interface_Type);
%% Set the model parameters
Sample_Int=0.00025;
% Set the Q error coefficient 2015-5-30 %
Q_Err=(-10:10:10)/100;
% Q_Err=(-75:15:165)/100;
% Q_Err=(-60:15:150)/100;

% Calculate the model number 2015-5-30 %
Model_Num=size(Q_Err,2);
Model_Id=1:Model_Num;
% [Azimuth,Model_Num]=Cal_Azimuth(Well_Num);

% Generate the ricker wavelet derivative 2015-5-29 %
main_frequency=600;
[Ricker_Derivative]=Gen_Ricker_Der(main_frequency,Sample_Int);

% % % 4 types of seismic moment tensor % % %
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
% 
RandMT_Num=1;
Per_Coe=0.3;
RandMT_ValueOri=rand(RandMT_Num*6,1);

%
MT=zeros(3,3);
% MT_Base=eye(3);
MT_Base=zeros(3,3);

T_Orig_All=zeros(RandMT_Num,Model_Num,Sour_Num);
k_Orig_All=zeros(RandMT_Num,Model_Num,Sour_Num);
T_PS_All=zeros(RandMT_Num,Model_Num,Sour_Num);
k_PS_All=zeros(RandMT_Num,Model_Num,Sour_Num);
T_P_All=zeros(RandMT_Num,Model_Num,Sour_Num);
k_P_All=zeros(RandMT_Num,Model_Num,Sour_Num);
T_S_All=zeros(RandMT_Num,Model_Num,Sour_Num);
k_S_All=zeros(RandMT_Num,Model_Num,Sour_Num);
% Tk_Orig_XY_All=zeros(2,RandMT_Num,Sour_Num);
% Tk_XY_All=zeros(2,RandMT_Num,Sour_Num);
%
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
%% Using the raytracing method to calculate the travel time of directive
% wave 2015-8-27
[TraveTime_DirWav_P,TraveTime_DirWav_S,Coor_RayTrace_P,Coor_RayTrace_S,...
    SRLayers_Vp,SRLayers_Vs]=TravelT_DirWav(Receivers,Shot,Vp,Vs,Layer_Z);
% According to the tilt plane, to calculate the reflect wave travel time 
[Reflection_Points,TravelDistance_RefWave,TravelTime_RefWave_P,TravelTime_RefWave_S]=...
    TravelTime_RefWave(Shot,Receivers,Plane_Function,SRLayers_Vp,SRLayers_Vs);

%% Calculate the direction cosine, travel distance and average velocity for the direct wave 2015-9-15
[DirectionCos_DirP,DirectionCos_DirS,TravelDistance_DirWave,Average_VpVs]=...
    Cal_DirectionCosine(Coor_RayTrace_P,Coor_RayTrace_S,TraveTime_DirWav_P,TraveTime_DirWav_S);
% Calculate the direction cosine for the reflect wave 2015-9-15
[DirectionCos_RefP,DirectionCos_RefS]=Cal_DirectionCos_Ref(Shot,Reflection_Points);

%% Combine the directive and reflective wave information 2015-9-15
% Combine the travel time
[Rho,TravelTime_AllWave,TravelTime_P,TravelTime_S]=Combine_TravelTime...
    (TraveTime_DirWav_P,TraveTime_DirWav_S,TravelTime_RefWave_P,TravelTime_RefWave_S);
% Combine the direction cosine, travel ditance
DirectionCos_P=[DirectionCos_DirP,DirectionCos_RefP];
DirectionCos_S=[DirectionCos_DirS,DirectionCos_RefS];
% 
TravelDistance=[TravelDistance_DirWave,TravelDistance_RefWave];
Average_VpVs_DirRef=[Average_VpVs,Average_VpVs];

%% Generate and plot the P&S-wave field 2015-6-8 % 
% DC Moment tensor
% dB=45;
dB=0;
%
Gen_Wavefield(Sample_Int,TravelTime_AllWave,DirectionCos_P,DirectionCos_S,TravelDistance,M_CLVD_Neg,Rho,...
    Average_VpVs_DirRef,Ricker_Derivative,dB)
%}
%%
for model_id=1:Model_Num
    %     Set the error Q parameters 2015-5-30 %
    %{
    Rec_Num=size(SRLayers_DirRef_Qp,2);
    Qp_Err=cell(1,Rec_Num);
    Qs_Err=cell(1,Rec_Num);
    for i=1:Rec_Num
        Qp_Err{i}=SRLayers_DirRef_Qp{i}*(1+Q_Err(model_id));
        Qs_Err{i}=SRLayers_DirRef_Qs{i}*(1+Q_Err(model_id));
    end
    %}
    
    %Using four kinds of MT (one by one) to test the inversion problem
    for i=1:Sour_Num
        RandMT_Value=RandMT_ValueOri*Per_Coe;
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
            %  Generate the P-wave field with attenuation 2015-5-31 %
            %{
            [PWavefield_xyz1,PWaveform_OriXYZ,PWaveform_XYZ1]=...
                Generate_Pwave_WithQ(Sample_Int,TravelTime_AllWave,DirectionCos_P,...
                TravelDistance,MT,Rho,Average_VpVs_DirRef,Ricker_Derivative,SRLayers_DirRef_Qp,TravelTime_P);
            %}
            %  Generate the P-wave field 2015-9-16 %
            [PWavefield_xyz1,PWaveform_OriXYZ]=...
                Generate_Pwave(Sample_Int,TravelTime_AllWave,DirectionCos_P,...
                TravelDistance,MT,Rho,Average_VpVs_DirRef,Ricker_Derivative);
            
            % Generate the S-wave field with attenuation 2015-5-31 %
            %{
            [SWavefiled_xyz1,SWaveform_OriXYZ,SWaveform_XYZ1]=...
                Generate_Swave_WithQ(Sample_Int,TravelTime_AllWave,DirectionCos_S,...
                TravelDistance,MT,Rho,Average_VpVs_DirRef,Ricker_Derivative,SRLayers_DirRef_Qs,TravelTime_S);
            %}
            % Generate the S-wave field2015-5-31 %
            [SWavefiled_xyz1,SWaveform_OriXYZ]=...
                Generate_Swave(Sample_Int,TravelTime_AllWave,DirectionCos_S,...
                TravelDistance,MT,Rho,Average_VpVs_DirRef,Ricker_Derivative);
                
            % Calculate the attenuated energy of every well 2015-4-23 %
            %{
            [Attenuated_Energy(model_id,:)]=...
                Cal_AttEnergy(Well_Num,PWaveform_OriXYZ,SWaveform_OriXYZ,PWaveform_XYZ1,SWaveform_XYZ1);
            %}
            
            % Generate the observe data and kernel matrix without attenuation 2015-5-31 %
            %{
            [G_P,G_S]=...
                Inversion_CoeNew(Direction_Cosin1,Rho,Vp,Vs,SR_Vec_model1,Ricker_Derivative);
            [PWave_ObsData1,SWave_ObsData1]=...
                Inversion_ObserData(PWaveform_XYZ1,SWaveform_XYZ1);
            
            [G_P,G_S,Ricker_EffValue_Idx]=...
                Inversion_CoefficientV2(Direction_Cosin1,Rho,Vp,Vs,SR_Vec_model1,Ricker_Derivative);
            [PWave_ObsData1,SWave_ObsData1]=...
                Inversion_ObserDataV2(PWaveform_XYZ1,SWaveform_XYZ1,Ricker_EffValue_Idx);
            %}
            
            % Generate the observe data and kernel matrix without attenuation 2015-9-16 %
            %
            [G_P,G_S,Ricker_EffValue_Idx]=Inversion_CoefficientV3...
                (DirectionCos_P,DirectionCos_S,Rho,Average_VpVs_DirRef,TravelDistance,Ricker_Derivative,Sample_Int);
            %}
            
            %Generate the observe data and kernel matrix with attenuation 2015-9-10 %
            %{
            [G_P,G_S,Ricker_EffValue_Idx,PWaveform_XYZ_Q_Test,SWaveform_XYZ_Q_Test]=Inversion_CoefficientV3...
                (DirectionCos_P,DirectionCos_S,Rho,Average_VpVs_DirRef,SRLayers_DirRef_Qp,SRLayers_DirRef_Qs,...
                TravelDistance,Ricker_Derivative,Sample_Int,TravelTime_P,TravelTime_S,MT);
            %}

%             [PWave_ObsData1,SWave_ObsData1]=Inversion_ObserDataV3...
%                 (PWaveform_XYZ1,SWaveform_XYZ1,Ricker_EffValue_Idx);
            % Generate the noisy observedata for the inversion
            [PWave_ObsData1,SWave_ObsData1]=Inversion_ObserData_Noise...
                (PWaveform_OriXYZ,SWaveform_OriXYZ,Ricker_EffValue_Idx,dB);

            % Using the P-wave to inverse the moment tensor 2015-5-31 %
            %             Inversion_m_P=G_P\PWave_ObsData1;
            Inversion_m_P=lsqlin(G_P,PWave_ObsData1);
            Inversion_MTs_P(:,i)=Inversion_m_P;
            
            % Using the S-wave to inverse the moment tensor 2015-5-31 %
            %             Inversion_m_P=G_P\PWave_ObsData1;
            %             Inversion_m_S=lsqlin(G_S,SWave_ObsData1);
            %             Inversion_MTs_S(:,i)=Inversion_m_S;
            
            % Using the P & S-wave to inverse the moment tensor %
            % 2015-5-31 %
            G_PS=[G_P;G_S];
            PSWave_ObsData=[PWave_ObsData1;SWave_ObsData1];
            %             Inversion_m_PS=G_PS\PSWave_ObsData;
            Inversion_m_PS=lsqlin(G_PS,PSWave_ObsData);
            Inversion_MTs_PS(:,i)=Inversion_m_PS;
            
            % Transform the moment tensor to T-k parameters 2015-6-7 %
            [T_k_Orig]=MT_Transform(MTsRandom_Vector(:,j,i));
            T_Orig_All(j,model_id,i)=T_k_Orig(1);
            k_Orig_All(j,model_id,i)=T_k_Orig(2);
            
            [T_k_PS]=MT_Transform(Inversion_m_PS);
            T_PS_All(j,model_id,i)=T_k_PS(1);
            k_PS_All(j,model_id,i)=T_k_PS(2);
            
            [T_k_P]=MT_Transform(Inversion_m_P);
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
Plot_InvRes_4MTs_Eves(Model_Num,RandMT_Num,Sour_Num,Q_Err,T_Orig_All,k_Orig_All,...
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
%%

%Plot the absolute inversion error of every kind of source by using P&S, P and S wave respectivly 2015-7-1 %
% Plot_TkErr(Q_Err,AverError_AbsoTk_PS,AverError_AbsoTk_P,AverError_AbsoTk_S);

%Plot the absolute inversion error of every kind of source by using P&S and P wave respectivly 2015-6-7 %
Plot_TkErr_VariousGeometry(Q_Err,AverError_AbsoTk_PS,ErrorVariance_AbsoTk_PS,...
    AverError_AbsoTk_P,ErrorVariance_AbsoTk_P)

%Plot the absolute inversion error of every kind of source 2015-4-23 %
% Plot_TkErrorV4(Model_Num,Azimuth(1,:),AverError_AbsoTk_PS,ErrorVariance_AbsoTk_PS,AverError_AbsoTk_P,ErrorVariance_AbsoTk_P)

%Plot the absolute inversion error of every kind of source 2015-4-28 %
% Attenuated_Energy=log(Attenuated_Energy);
% Plot_TkErrorV4(Model_Num,Attenuated_Energy,AverError_AbsoTk_PS,ErrorVariance_AbsoTk_PS,AverError_AbsoTk_P,ErrorVariance_AbsoTk_P)



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
