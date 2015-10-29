function [P_Data,S_Data]=ObserData_Noise(PWave_ObsData,SWave_ObsData,SNR)
% In this function, use the attenuated data to generate the observing data matrix
% Get the receiver number, length of the waveform and the number of the component
[Rec_Num,L,Com]=size(PWave_ObsData);
%{
Sam_Interval=0.001;
Max_F=1/Sam_Interval;
FFT_F=zeros(1,L);
F_N=(L+1)/2;
FFT_F(1:F_N)=0:Max_F/2/(F_N-1):Max_F/2;
FFT_F(F_N+1:L)=FFT_F(F_N:-1:2);
% According to the attenutation theory, add attenuation into the observe data
% Add the attenuation in the frequency domain
for l=1:Rec_Num
%     According to the travel time of every layer, add the attenuation layer by layer
    for m=1:Layer_Num(l)
 
        for n=1:Com
            %         FFT
%             PWaveform
            PWave_ObsDataFFT=fft(PWave_ObsData(l,:,n));
            PWave_ObsDataFFT_Att=real(PWave_ObsDataFFT).*exp(-pi*FFT_F*ELayerTime_SR(l,m,1)/Q(m))+...
            imag(PWave_ObsDataFFT).*exp(-pi*FFT_F*ELayerTime_SR(l,m,1)/Q(m))*1i;
            PWave_ObsData(l,:,n)=ifft(PWave_ObsDataFFT_Att);
%             SWaveform
            SWave_ObsDataFFT=fft(SWave_ObsData(l,:,n));
            SWave_ObsDataFFT_Att=real(SWave_ObsDataFFT).*exp(-pi*FFT_F*ELayerTime_SR(l,m,2)/Q(m))+...
            imag(SWave_ObsDataFFT).*exp(-pi*FFT_F*ELayerTime_SR(l,m,2)/Q(m))*1i;
            SWave_ObsData(l,:,n)=ifft(SWave_ObsDataFFT_Att);
        end
    end
end
%}
Noise=rand(1,Rec_Num*L*Com*2);
for l=1:Rec_Num
    Noise1=Noise(1+(l-1)*L*Com*2:L*Com*2*l);
    for m=1:Com
        Noise2=Noise1(1+(m-1)*2*L:2*L+(m-1)*2*L);
        PWave_ObsData(Rec_Num,:,m)=PWave_ObsData(Rec_Num,:,m)+...
            norm(PWave_ObsData(Rec_Num,:,m))/(SNR*sqrt(L))*Noise2(1:L);
        SWave_ObsData(Rec_Num,:,m)=SWave_ObsData(Rec_Num,:,m)+...
            norm(SWave_ObsData(Rec_Num,:,m))/(SNR*sqrt(L))*Noise2(L+1:2*L);
    end
end

% Generate the d matrix
P_Data=zeros(Rec_Num*L*Com,1);
S_Data=zeros(Rec_Num*L*Com,1);

for l=1:Rec_Num
    for m=1:L
        s=(l*m-1)*3+1;
        e=l*m*3;
        P_Data(s:e,1)=PWave_ObsData(l,m,:);
        S_Data(s:e,1)=SWave_ObsData(l,m,:);
    end
end