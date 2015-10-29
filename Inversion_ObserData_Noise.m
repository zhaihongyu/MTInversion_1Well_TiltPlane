% In this function, use the attenuated data to generate the observing data
% matrix in the frequency domain, meanwhile adding the noise to the
% observing data 2015-6-6 %
function [P_Data,S_Data]=Inversion_ObserData_Noise...
    (PWave_ObsData,SWave_ObsData,Ricker_EffValue_Idx,dB)
% Get the receiver number, length of the waveform and the number of the components
[Rec_Num,L,Com]=size(PWave_ObsData);
Ricker_EffValue_L=size(Ricker_EffValue_Idx,2);
% Firstly, adding the noise to the wavefield data 2015-6-6 %
Noise=rand(Rec_Num,L,Com);
for l=1:Rec_Num
    for m=1:Com
        %Calculate P wave
        Ampli_P=sqrt(10^(dB/10)*norm(PWave_ObsData(l,:,m))/norm(Noise(l,:,m)));
        PWave_ObsData(l,:,m)=PWave_ObsData(l,:,m)+Ampli_P*Noise(l,:,m);
        %Calculate S wave
        Ampli_S=sqrt(10^(dB/10)*norm(SWave_ObsData(l,:,m))/norm(Noise(l,:,m)));
        SWave_ObsData(l,:,m)=SWave_ObsData(l,:,m)+Ampli_S*Noise(l,:,m);
    end
end
% Secondly, generate the d matrix 2015-6-6 %
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
    %Select the effective band of the spectrum data
    for m=1:Ricker_EffValue_L
        s=(l-1)*Ricker_EffValue_L*Com+(m-1)*3+1;
        e=(l-1)*Ricker_EffValue_L*Com+(m-1)*3+3;
        
        P_Data(s:e,1)=real(PWave_ObsData_FFT(l,Ricker_EffValue_Idx(m),:));
        S_Data(s:e,1)=real(SWave_ObsData_FFT(l,Ricker_EffValue_Idx(m),:));
    end
end
% End the function
end
