%% Generate the direct and reflect P&S wavefield with attenuation and noise 2015-9-15 %
% Eliminate the Q effect 2015-9-16
%%
function Gen_Wavefield(Sample_Interval,Travel_T,Direction_Cosin_P,Direction_Cosin_S,SR_Vec_model,MT,Rho,...
    Average_VpVs,Ricker_Der,dB)
% Set the basic parameters 2015-6-8 %
Per_Coe=0.0;
Com=3;
RandMT_Value=rand(1,6)*Per_Coe;
%
MT=MT+[RandMT_Value(1),RandMT_Value(2),RandMT_Value(3);...
    RandMT_Value(2),RandMT_Value(4),RandMT_Value(5);
    RandMT_Value(3),RandMT_Value(5),RandMT_Value(6);];
%}
%% Generate the P wavefield 2015-6-8%
% Set the P-wave's basic parameters 2015-6-8 %
Rec_Num=size(SR_Vec_model,2);
Ricker_DerL=size(Ricker_Der,2);
%{
Layer_Num=zeros(1,Rec_Num);
for i=1:Rec_Num
    Layer_Num(i)=size(ELayerTime_P{i},2);
end
%}

T_Interval_PS=1:round(max(max(Travel_T))/Sample_Interval)+Ricker_DerL;
PWaveField_L=size(T_Interval_PS,2);
P_wave=zeros(Rec_Num,PWaveField_L);
P_RadiationPattern=zeros(Com,Rec_Num);
PWavefield_XYZ=zeros(Rec_Num,PWaveField_L,Com);
P_wave_single=zeros(Rec_Num,Ricker_DerL);
PWaveform_XYZ=zeros(Rec_Num,Ricker_DerL,Com);
PWaveform_Q_XYZ=zeros(Rec_Num,Ricker_DerL,Com);
% Set the FFT and IFFT parameters
Max_F=0.5/Sample_Interval;
FFT_F=zeros(1,Ricker_DerL);
F_N=Ricker_DerL/2;
FFT_F(1:F_N+1)=0:Max_F/(F_N):Max_F;
FFT_F(F_N+2:Ricker_DerL)=FFT_F(F_N:-1:2);
for l=1:Rec_Num
    P_RadiationPattern(:,l)=Direction_Cosin_P(:,l)*(Direction_Cosin_P(:,l)'*MT*Direction_Cosin_P(:,l));
    
    P_wave_single(l,:)=1/(4*pi*SR_Vec_model(1,l)*Rho*Average_VpVs(1,l)^3)*(Direction_Cosin_P(:,l)'*MT*Direction_Cosin_P(:,l))*Ricker_Der;
    PWaveform_XYZ(l,:,1)=P_wave_single(l,:)*Direction_Cosin_P(1,l);
    PWaveform_XYZ(l,:,2)=P_wave_single(l,:)*Direction_Cosin_P(2,l);
    PWaveform_XYZ(l,:,3)=P_wave_single(l,:)*Direction_Cosin_P(3,l);
    %     According to the travel time of every layer, add the attenuation layer by layer
    %{
    SRec_Qp=SRecs_Qp{i};
    SRec_TravelT_P=ELayerTime_P{i};
    for n=1:3
        PWave_ObsDataFFT=fft(PWaveform_XYZ(l,:,n));
        for m=1:Layer_Num(l)
            %             Using FFT and IFFT to add attenuation
            
            PWave_ObsDataFFT_Att=real(PWave_ObsDataFFT).*exp(-pi*FFT_F*SRec_TravelT_P(m)/SRec_Qp(m))+...
            imag(PWave_ObsDataFFT).*exp(-pi*FFT_F*SRec_TravelT_P(m)/SRec_Qp(m))*1i;
            PWave_ObsDataFFT=PWave_ObsDataFFT_Att;
            PWaveform_Q_XYZ(l,:,n)=ifft(PWave_ObsDataFFT_Att);
        end
    end
    %}
    
    %     Generate the P-wave Field
    start_id=round(Travel_T(1,l)/Sample_Interval);
    %     P_wave(l,:)=P_wave(l,:)+10*l;
    %     P_wave_xyz(l,:,:)=P_wave_xyz(l,:,:)+10*l;
    for j=1:Ricker_DerL
        P_wave(l,start_id+j)=P_wave(l,start_id+j)+P_wave_single(l,j);
        % The 3rd dimension of P_wave_xyz relate to X, Y & Z direction of receiver
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
%% Generate the S-wave field 2015-6-8 %
SWavefield_L=size(T_Interval_PS,2);
S_wave=zeros(Rec_Num,SWavefield_L);
S_RadiationPattern=zeros(Com,Rec_Num);
SWavefield_XYZ=zeros(Rec_Num,SWavefield_L,Com);
S_wave_single=zeros(Rec_Num,Ricker_DerL);
SWaveform_XYZ=zeros(Rec_Num,Ricker_DerL,Com);
SWaveform_Q_XYZ=zeros(Rec_Num,Ricker_DerL,Com);

S_A=zeros(3*Rec_Num,6);
MT_Vector=zeros(6,1);
MT_Vector(1:3)=MT(1,:);
MT_Vector(4:5)=MT(2,2:3);
MT_Vector(6)=MT(3,3);

% Set the FFT and IFFT parameters
Max_F=0.5/Sample_Interval;
FFT_F=zeros(1,Ricker_DerL);
F_N=Ricker_DerL/2;
FFT_F(1:F_N+1)=0:Max_F/(F_N):Max_F;
FFT_F(F_N+2:Ricker_DerL)=FFT_F(F_N:-1:2);
for l=1:Rec_Num
%     Generate the first line of S-wave matrix A
    S_A11=Direction_Cosin_S(1,l)^3-Direction_Cosin_S(1,l);
    S_A12=2*Direction_Cosin_S(1,l)^2*Direction_Cosin_S(2,l)-Direction_Cosin_S(2,l);
    S_A13=2*Direction_Cosin_S(1,l)^2*Direction_Cosin_S(3,l)-Direction_Cosin_S(3,l);
    S_A14=Direction_Cosin_S(1,l)*Direction_Cosin_S(2,l)^2;
    S_A15=2*Direction_Cosin_S(1,l)*Direction_Cosin_S(2,l)*Direction_Cosin_S(3,l);
    S_A16=Direction_Cosin_S(1,l)*Direction_Cosin_S(3,l)^2;
    S_A(3*(l-1)+1,:)=-[S_A11 S_A12 S_A13 S_A14 S_A15 S_A16];
%     Generate the second line of S-wave matrix A
    S_A21=Direction_Cosin_S(1,l)^2*Direction_Cosin_S(2,l);
    S_A22=2*Direction_Cosin_S(1,l)*Direction_Cosin_S(2,l)^2-Direction_Cosin_S(1,l);
    S_A23=2*Direction_Cosin_S(1,l)*Direction_Cosin_S(2,l)*Direction_Cosin_S(3,l);
    S_A24=Direction_Cosin_S(2,l)^3-Direction_Cosin_S(2,l);
    S_A25=2*Direction_Cosin_S(2,l)^2*Direction_Cosin_S(3,l)-Direction_Cosin_S(3,l);
    S_A26=Direction_Cosin_S(2,l)*Direction_Cosin_S(3,l)^2;
    S_A(3*(l-1)+2,:)=-[S_A21 S_A22 S_A23 S_A24 S_A25 S_A26];
%     Generate the second line of S-wave matrix A
    S_A31=Direction_Cosin_S(1,l)^2*Direction_Cosin_S(3,l);
    S_A32=2*Direction_Cosin_S(1,l)*Direction_Cosin_S(2,l)*Direction_Cosin_S(3,l);
    S_A33=2*Direction_Cosin_S(1,l)*Direction_Cosin_S(3,l)^2-Direction_Cosin_S(1,l);
    S_A34=Direction_Cosin_S(2,l)^2*Direction_Cosin_S(3,l);
    S_A35=2*Direction_Cosin_S(2,l)*Direction_Cosin_S(3,l)^2-Direction_Cosin_S(2,l);
    S_A36=Direction_Cosin_S(3,l)^3-Direction_Cosin_S(3,l);
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
    SRec_Qs=SRecs_Qs{i};
    SRec_TravelT_S=ELayerTime_S{i};
    for n=1:3
        SWave_ObsDataFFT=fft(SWaveform_XYZ(l,:,n));
        for m=1:Layer_Num(l)
%             Using FFT and IFFT to add attenuation
            
            SWave_ObsDataFFT_Att=real(SWave_ObsDataFFT).*exp(-pi*FFT_F*SRec_TravelT_S(m)/SRec_Qs(m))+...
            imag(SWave_ObsDataFFT).*exp(-pi*FFT_F*SRec_TravelT_S(m)/SRec_Qs(m))*1i;
            SWave_ObsDataFFT=SWave_ObsDataFFT_Att;
            SWaveform_Q_XYZ(l,:,n)=ifft(SWave_ObsDataFFT_Att);
        end
    end
    %}
    
    %     Generate the S-wave Field
    start_id=round(Travel_T(2,l)/Sample_Interval);
    %     S_wave(l,:)=S_wave(l,:)+10*l;
    %     S_wave_xyz(l,:,:)=S_wave_xyz(l,:,:)+10*l;
    for j=1:size(Ricker_Der,2)
        S_wave(l,start_id+j)=S_wave(l,start_id+j)+S_wave_single(l,j);
        %Generate the S wavefield with attenuation
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
%% Combine the P and S wavefield, meanwhile display the direct wave and reflect wave in one trace
% Firstly, generate the P&S-wave field 2015-6-8 %
PS_Wavefield_XYZ=PWavefield_XYZ+SWavefield_XYZ;
% 
% Secondly, adding the noise to the wavefield data 2015-6-8 %
Noise=rand(Rec_Num,SWavefield_L,Com);
%{
Norm_PS=zeros(1,Com);
Norm_Noise=zeros(1,Com);
Ampli=zeros(1,Com);
for m=1:Com
    Norm_PS(m)=norm(PS_Wave_XYZ(:,:,m));
    Norm_Noise(m)=norm(Noise(:,:,m));
    Ampli(m)=sqrt(10^(dB/10)*Norm_PS(m)/Norm_Noise(m));
end
% Ampli=sqrt(10^(SNR/10)*sum(Norm_PS)/sum(Norm_Noise));
%}
for l=1:Rec_Num
    for m=1:Com
%         PS_Wave_XYZ(l,:,m)=PS_Wave_XYZ(l,:,m)+...
%             sqrt(norm(PS_Wave_XYZ(l,:,m))/(SNR*norm(Noise(l,:,m))))*Noise(l,:,m);
        
%         PS_Wave_XYZ(l,:,m)=PS_Wave_XYZ(l,:,m)+Ampli(m)*Noise(l,:,m);
        Ampli=sqrt(10^(dB/10)*norm(PS_Wavefield_XYZ(l,:,m))/norm(Noise(l,:,m)));
        PS_Wavefield_XYZ(l,:,m)=PS_Wavefield_XYZ(l,:,m)+Ampli*Noise(l,:,m);
    end
end
% Combine the direct wave and reflect wave in one trace
Rec_Num_DirRef=Rec_Num/2;
Wavefiele_DirRef=PS_Wavefield_XYZ(1:Rec_Num_DirRef,:,:)+PS_Wavefield_XYZ(Rec_Num_DirRef+1:Rec_Num,:,:);
%% Plot the P&S-wave field for the direct and reflect wave 2015-6-8 %
Fontsize=9;
YTick=0:20:SWavefield_L;
YTickLabel=[0:20:SWavefield_L]*Sample_Interval*1000;
f1=figure;
set(f1,'Position',[100 100 1400 800])
%
subplot(1,3,1)
wigb(Wavefiele_DirRef(:,:,1)');
set(gca,'YTick',YTick,'YTickLabel',YTickLabel,'FontSize',Fontsize);
title('X Component','FontSize',Fontsize)
xlabel('Trace','FontSize',Fontsize);
ylabel('Time/ms','FontSize',Fontsize);
%
subplot(1,3,2)
wigb(Wavefiele_DirRef(:,:,2)');
set(gca,'YTick',YTick,'YTickLabel',YTickLabel,'FontSize',Fontsize);
title('Y Component','FontSize',Fontsize)
xlabel('Trace','FontSize',Fontsize);
ylabel('Time/ms','FontSize',Fontsize);
%
subplot(1,3,3)
wigb(Wavefiele_DirRef(:,:,3)');
set(gca,'YTick',YTick,'YTickLabel',YTickLabel,'FontSize',Fontsize);
title('Z Component','FontSize',Fontsize)
xlabel('Trace','FontSize',Fontsize);
ylabel('Time/ms','FontSize',Fontsize);

set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 16 8]);
print(f1,'-r300','-dtiff','Wavefield-DC');

%% Plot the P&S-wave field for the reflect wave 2015-6-8 %
Fontsize=9;
YTick=0:20:SWavefield_L;
YTickLabel=[0:20:SWavefield_L]*Sample_Interval*1000;
f2=figure;
set(f2,'Position',[100 100 1400 800])
%
subplot(1,3,1)
wigb(PS_Wavefield_XYZ(Rec_Num_DirRef+1:Rec_Num,:,1)');
set(gca,'YTick',YTick,'YTickLabel',YTickLabel,'FontSize',Fontsize);
title('X Component','FontSize',Fontsize)
xlabel('Trace','FontSize',Fontsize);
ylabel('Time/ms','FontSize',Fontsize);
%
subplot(1,3,2)
wigb(PS_Wavefield_XYZ(Rec_Num_DirRef+1:Rec_Num,:,2)');
set(gca,'YTick',YTick,'YTickLabel',YTickLabel,'FontSize',Fontsize);
title('Y Component','FontSize',Fontsize)
xlabel('Trace','FontSize',Fontsize);
ylabel('Time/ms','FontSize',Fontsize);
%
subplot(1,3,3)
wigb(PS_Wavefield_XYZ(Rec_Num_DirRef+1:Rec_Num,:,3)');
set(gca,'YTick',YTick,'YTickLabel',YTickLabel,'FontSize',Fontsize);
title('Z Component','FontSize',Fontsize)
xlabel('Trace','FontSize',Fontsize);
ylabel('Time/ms','FontSize',Fontsize);

set(f2,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 16 8]);
print(f2,'-r300','-dtiff','Wavefield-DC');

end