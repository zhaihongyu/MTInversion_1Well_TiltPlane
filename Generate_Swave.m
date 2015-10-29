%% Generate the S-wave field
% Travel_T='Travel time of direct P & S wave for every receiver'
% SR_Vec_model='Travel distance of direct P&S wave for every receiver'
% "S_wave_xyz"="3 components of S wave field"
% "SWaveform_XYZ"="3 components of S waveform"
% "SWaveform_Q_XYZ"="3 components of S waveform with attenuation"
% Eliminate the Q effect 2015-9-16
%%
function [SWavefield_XYZ,SWaveform_XYZ]=Generate_Swave...
    (Sample_Interval,Travel_T,Direction_Cosin,SR_Vec_model,MT,Rho,Average_VpVs,Ricker_Der)

% Calculate the travel time and direction cosin (version 1.0)
%{
sr_vector=zeros(3,Rec_Num);
for i=1:Rec_Num
    sr_vector(1,i)=Well_Cor(1,i)-Shot_Cor(1);
    sr_vector(2,i)=Well_Cor(2,i)-Shot_Cor(2);
    sr_vector(3,i)=Well_Cor(3,i)-Shot_Cor(3);
end
Direction_Cosin=zeros(3,Rec_Num);
SR_Vec_model=zeros(1,Rec_Num);
% The 1st line data are the travel time in Vs
Travel_T=zeros(1,Rec_Num);
% Calculate the travel time
for i=1:Rec_Num
    SR_Vec_model(i)=sqrt(sr_vector(1,i)^2+sr_vector(2,i)^2+sr_vector(3,i)^2);
%     Travel_T(1,i)=SR_Vec_model(i)/Vp;
    Travel_T(i)=SR_Vec_model(i)/Vs;
    for j=1:3
        Direction_Cosin(j,i)=sr_vector(j,i)/SR_Vec_model(i);
    end
end
%}

% Generate the S-wave field
Rec_Num=size(SR_Vec_model,2);
Ricker_DerL=size(Ricker_Der,2);
% Set the basic paramters
%{
Layer_Num=zeros(1,Rec_Num);
for i=1:Rec_Num
    Layer_Num(i)=size(ELayerTime_SR{i},2);
end
%}
T_Interval_PS=1:round(max(max(Travel_T))/Sample_Interval)+Ricker_DerL;
SWave_L=size(T_Interval_PS,2);
S_wave=zeros(Rec_Num,SWave_L);
S_RadiationPattern=zeros(3,Rec_Num);
SWavefield_XYZ=zeros(Rec_Num,SWave_L,3);
S_wave_single=zeros(Rec_Num,Ricker_DerL);
SWaveform_XYZ=zeros(Rec_Num,Ricker_DerL,3);
SWaveform_Q_XYZ=zeros(Rec_Num,Ricker_DerL,3);

S_A=zeros(3*Rec_Num,6);
MT_Vector=zeros(6,1);
MT_Vector(1:3)=MT(1,:);
MT_Vector(4:5)=MT(2,2:3);
MT_Vector(6)=MT(3,3);
% FFT and IFFT parameters
% Sample_Interval=0.001;
Max_F=0.5/Sample_Interval;
FFT_F=zeros(1,Ricker_DerL);
F_N=Ricker_DerL/2;
FFT_F(1:F_N+1)=0:Max_F/(F_N):Max_F;
FFT_F(F_N+2:Ricker_DerL)=FFT_F(F_N:-1:2);
for l=1:Rec_Num
%     Generate the first line of S-wave matrix A
    S_A11=Direction_Cosin(1,l)^3-Direction_Cosin(1,l);
    S_A12=2*Direction_Cosin(1,l)^2*Direction_Cosin(2,l)-Direction_Cosin(2,l);
    S_A13=2*Direction_Cosin(1,l)^2*Direction_Cosin(3,l)-Direction_Cosin(3,l);
    S_A14=Direction_Cosin(1,l)*Direction_Cosin(2,l)^2;
    S_A15=2*Direction_Cosin(1,l)*Direction_Cosin(2,l)*Direction_Cosin(3,l);
    S_A16=Direction_Cosin(1,l)*Direction_Cosin(3,l)^2;
    S_A(3*(l-1)+1,:)=-[S_A11 S_A12 S_A13 S_A14 S_A15 S_A16];
%     Generate the second line of S-wave matrix A
    S_A21=Direction_Cosin(1,l)^2*Direction_Cosin(2,l);
    S_A22=2*Direction_Cosin(1,l)*Direction_Cosin(2,l)^2-Direction_Cosin(1,l);
    S_A23=2*Direction_Cosin(1,l)*Direction_Cosin(2,l)*Direction_Cosin(3,l);
    S_A24=Direction_Cosin(2,l)^3-Direction_Cosin(2,l);
    S_A25=2*Direction_Cosin(2,l)^2*Direction_Cosin(3,l)-Direction_Cosin(3,l);
    S_A26=Direction_Cosin(2,l)*Direction_Cosin(3,l)^2;
    S_A(3*(l-1)+2,:)=-[S_A21 S_A22 S_A23 S_A24 S_A25 S_A26];
%     Generate the second line of S-wave matrix A
    S_A31=Direction_Cosin(1,l)^2*Direction_Cosin(3,l);
    S_A32=2*Direction_Cosin(1,l)*Direction_Cosin(2,l)*Direction_Cosin(3,l);
    S_A33=2*Direction_Cosin(1,l)*Direction_Cosin(3,l)^2-Direction_Cosin(1,l);
    S_A34=Direction_Cosin(2,l)^2*Direction_Cosin(3,l);
    S_A35=2*Direction_Cosin(2,l)*Direction_Cosin(3,l)^2-Direction_Cosin(2,l);
    S_A36=Direction_Cosin(3,l)^3-Direction_Cosin(3,l);
    S_A(3*(l-1)+3,:)=-[S_A31 S_A32 S_A33 S_A34 S_A35 S_A36];
    
    S_RadiationPattern(1,l)=S_A(3*(l-1)+1,:)*MT_Vector;
    S_RadiationPattern(2,l)=S_A(3*(l-1)+2,:)*MT_Vector;
    S_RadiationPattern(3,l)=S_A(3*(l-1)+3,:)*MT_Vector;

    SWaveform_XYZ(l,:,1)=1/(4*pi*SR_Vec_model(2,l)*Rho*Average_VpVs(2,l)^3)*S_RadiationPattern(1,l)*Ricker_Der;
    SWaveform_XYZ(l,:,2)=1/(4*pi*SR_Vec_model(2,l)*Rho*Average_VpVs(2,l)^3)*S_RadiationPattern(2,l)*Ricker_Der;
    SWaveform_XYZ(l,:,3)=1/(4*pi*SR_Vec_model(2,l)*Rho*Average_VpVs(2,l)^3)*S_RadiationPattern(3,l)*Ricker_Der;
%     may have some problems about the shear wave compond    %
    S_wave_single(l,:)=sqrt((SWaveform_XYZ(l,:,1).^2+SWaveform_XYZ(l,:,2).^2+SWaveform_XYZ(l,:,3).^2));
    
    %     According to the travel time of every layer, add the attenuation layer by layer
    %{
    SRec_Qs=SRecs_Qs{l};
    SRec_TravelT=ELayerTime_SR{l};
    for n=1:3
        SWave_ObsDataFFT=fft(SWaveform_XYZ(l,:,n));
        for m=1:Layer_Num(l)
            % Using FFT and IFFT to add attenuation
            
            SWave_ObsDataFFT_Att=real(SWave_ObsDataFFT).*exp(-pi*FFT_F*SRec_TravelT(m)/SRec_Qs(m))+...
                imag(SWave_ObsDataFFT).*exp(-pi*FFT_F*SRec_TravelT(m)/SRec_Qs(m))*1i;
            SWave_ObsDataFFT=SWave_ObsDataFFT_Att;
            
        end
        SWaveform_Q_XYZ(l,:,n)=ifft(SWave_ObsDataFFT_Att);
    end
    %}
    
    %     Generate the S-wave Field
    start_id=round(Travel_T(2,l)/Sample_Interval);
    %     S_wave(l,:)=S_wave(l,:)+10*l;
    %     S_wave_xyz(l,:,:)=S_wave_xyz(l,:,:)+10*l;
    for j=1:size(Ricker_Der,2)
        S_wave(l,start_id+j)=S_wave(l,start_id+j)+S_wave_single(l,j);
        %{
        SWavefield_XYZ(l,start_id+j,1)=SWavefield_XYZ(l,start_id+j,1)+SWaveform_Q_XYZ(l,j,1);
        SWavefield_XYZ(l,start_id+j,2)=SWavefield_XYZ(l,start_id+j,2)+SWaveform_Q_XYZ(l,j,2);
        SWavefield_XYZ(l,start_id+j,3)=SWavefield_XYZ(l,start_id+j,3)+SWaveform_Q_XYZ(l,j,3);
        %}
        % Eliminate the Q effect 2015-9-16
        SWavefield_XYZ(l,start_id+j,1)=SWavefield_XYZ(l,start_id+j,1)+SWaveform_XYZ(l,j,1);
        SWavefield_XYZ(l,start_id+j,2)=SWavefield_XYZ(l,start_id+j,2)+SWaveform_XYZ(l,j,2);
        SWavefield_XYZ(l,start_id+j,3)=SWavefield_XYZ(l,start_id+j,3)+SWaveform_XYZ(l,j,3);
    end
end
end