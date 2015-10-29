function [P_Data,S_Data]=Inversion_ObserDataV3(PWave_ObsData,SWave_ObsData,Ricker_EffValue_Idx)
% In this function, use the attenuated data to generate the observing data
% matrix in the frequency domain

% Get the receiver number, length of the waveform and the number of the components
[Rec_Num,L,Com]=size(PWave_ObsData);
Ricker_EffValue_L=size(Ricker_EffValue_Idx,2);
% Generate the d matrix
P_Data=zeros(Rec_Num*Ricker_EffValue_L*Com,1);
S_Data=zeros(Rec_Num*Ricker_EffValue_L*Com,1);

PWave_ObsData_FFT=zeros(Rec_Num,L,Com);
SWave_ObsData_FFT=zeros(Rec_Num,L,Com);
for l=1:Rec_Num
    %     Calculate the spectrum of P and S wave
    %{
    PWave_ObsData_FFT(l,:,1)=abs(fft(PWave_ObsData(l,:,1)));
    PWave_ObsData_FFT(l,:,2)=abs(fft(PWave_ObsData(l,:,2)));
    PWave_ObsData_FFT(l,:,3)=abs(fft(PWave_ObsData(l,:,3)));
    
    SWave_ObsData_FFT(l,:,1)=abs(fft(SWave_ObsData(l,:,1)));
    SWave_ObsData_FFT(l,:,2)=abs(fft(SWave_ObsData(l,:,2)));
    SWave_ObsData_FFT(l,:,3)=abs(fft(SWave_ObsData(l,:,3)));
    %}
    PWave_ObsData_FFT(l,:,1)=fft(PWave_ObsData(l,:,1));
    PWave_ObsData_FFT(l,:,2)=fft(PWave_ObsData(l,:,2));
    PWave_ObsData_FFT(l,:,3)=fft(PWave_ObsData(l,:,3));
    
    SWave_ObsData_FFT(l,:,1)=fft(SWave_ObsData(l,:,1));
    SWave_ObsData_FFT(l,:,2)=fft(SWave_ObsData(l,:,2));
    SWave_ObsData_FFT(l,:,3)=fft(SWave_ObsData(l,:,3));
    for m=1:Ricker_EffValue_L
        s=(l-1)*Ricker_EffValue_L*Com+(m-1)*3+1;
        e=(l-1)*Ricker_EffValue_L*Com+(m-1)*3+3;
        P_Data(s:e,1)=real(PWave_ObsData_FFT(l,Ricker_EffValue_Idx(m),:));
        S_Data(s:e,1)=real(SWave_ObsData_FFT(l,Ricker_EffValue_Idx(m),:));
    end
end
