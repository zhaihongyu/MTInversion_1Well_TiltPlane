%% Generate the P-wave field
% Travel_T='Travel time of direct P & S wave for every receiver'
% SR_Vec_model='Travel distance of direct P wave for every receiver'
% "P_wave_xyz"="3 components of P wave field"
% "PWaveform_XYZ"="3 components of P waveform"
% "PWaveform_Q_XYZ"="3 components of P waveform with attenuation"
% Eliminate the Q effect 2015-9-16
%%
function [PWavefield_XYZ,PWaveform_XYZ]=Generate_Pwave...
    (Sample_Interval,Travel_T,Direction_Cosin,SR_Vec_model,MT,Rho,Average_VpVs,Ricker_Der)
% Set the basic parameters
Rec_Num=size(SR_Vec_model,2);
Ricker_DerL=size(Ricker_Der,2);
%{
Layer_Num=zeros(1,Rec_Num);
for i=1:Rec_Num
    Layer_Num(i)=size(ELayerTime_SR_P{i},2);
end
%}
% [Ricker_Max,Max_Id]=max(Ricker_Der);

T_Interval_PS=1:round(max(max(Travel_T))/Sample_Interval)+Ricker_DerL;
PWaveField_L=size(T_Interval_PS,2);
P_wave=zeros(Rec_Num,PWaveField_L);
P_RadiationPattern=zeros(3,Rec_Num);
PWavefield_XYZ=zeros(Rec_Num,PWaveField_L,3);
P_wave_single=zeros(Rec_Num,Ricker_DerL);
PWaveform_XYZ=zeros(Rec_Num,Ricker_DerL,3);
PWaveform_Q_XYZ=zeros(Rec_Num,Ricker_DerL,3);
% FFT and IFFT parameters
% Sam_Interval=0.001;
Max_F=0.5/Sample_Interval;
FFT_F=zeros(1,Ricker_DerL);
F_N=Ricker_DerL/2;
FFT_F(1:F_N+1)=0:Max_F/(F_N):Max_F;
FFT_F(F_N+2:Ricker_DerL)=FFT_F(F_N:-1:2);
for l=1:Rec_Num
    P_RadiationPattern(:,l)=Direction_Cosin(:,l)*(Direction_Cosin(:,l)'*MT*Direction_Cosin(:,l));
    
    P_wave_single(l,:)=1/(4*pi*SR_Vec_model(1,l)*Rho*Average_VpVs(1,l)^3)*(Direction_Cosin(:,l)'*MT*Direction_Cosin(:,l))*Ricker_Der;
    PWaveform_XYZ(l,:,1)=P_wave_single(l,:)*Direction_Cosin(1,l);
    PWaveform_XYZ(l,:,2)=P_wave_single(l,:)*Direction_Cosin(2,l);
    PWaveform_XYZ(l,:,3)=P_wave_single(l,:)*Direction_Cosin(3,l);
    %     According to the travel time of every layer, add the attenuation layer by layer
    %{
    SRec_Qp=SRecs_Qp{l};
    SRec_TravelT=ELayerTime_SR_P{l};
    for n=1:3
        PWave_ObsDataFFT=fft(PWaveform_XYZ(l,:,n));
        for m=1:Layer_Num(l)
            %             Using FFT and IFFT to add attenuation
            
            PWave_ObsDataFFT_Att=real(PWave_ObsDataFFT).*exp(-pi*FFT_F*SRec_TravelT(m)/SRec_Qp(m))+...
                imag(PWave_ObsDataFFT).*exp(-pi*FFT_F*SRec_TravelT(m)/SRec_Qp(m))*1i;
            PWave_ObsDataFFT=PWave_ObsDataFFT_Att;
        end
        PWaveform_Q_XYZ(l,:,n)=ifft(PWave_ObsDataFFT_Att);
    end
    %}
    %     Generate the P-wave Field
    start_id=round(Travel_T(1,l)/Sample_Interval);
    %     P_wave(l,:)=P_wave(l,:)+10*l;
    %     P_wave_xyz(l,:,:)=P_wave_xyz(l,:,:)+10*l;
    for j=1:Ricker_DerL
        P_wave(l,start_id+j)=P_wave(l,start_id+j)+P_wave_single(l,j);
        %         The 3rd dimension of P_wave_xyz relate to X, Y & Z direction of receiver
        %{
        PWavefield_XYZ(l,start_id+j,1)=PWavefield_XYZ(l,start_id+j,1)+PWaveform_Q_XYZ(l,j,1);
        PWavefield_XYZ(l,start_id+j,2)=PWavefield_XYZ(l,start_id+j,2)+PWaveform_Q_XYZ(l,j,2);
        PWavefield_XYZ(l,start_id+j,3)=PWavefield_XYZ(l,start_id+j,3)+PWaveform_Q_XYZ(l,j,3);
        %}
        % Eliminate the Q effect 2015-9-16
        PWavefield_XYZ(l,start_id+j,1)=PWavefield_XYZ(l,start_id+j,1)+PWaveform_XYZ(l,j,1);
        PWavefield_XYZ(l,start_id+j,2)=PWavefield_XYZ(l,start_id+j,2)+PWaveform_XYZ(l,j,2);
        PWavefield_XYZ(l,start_id+j,3)=PWavefield_XYZ(l,start_id+j,3)+PWaveform_XYZ(l,j,3);
    end
end
end