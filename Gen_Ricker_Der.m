function [Ricker_Der]=Gen_Ricker_Der(Main_F,Sample_Interval)

% Generate the ricker wavelet
% Sample interval 0.25ms
% Sample_Interval=0.00025;
% Main_F=600;
t=-0.05:Sample_Interval:0.05;
ricker=(1-2*(pi*Main_F*t).^2).*exp(-(pi*Main_F*t).^2);
Ricker_Derivative=zeros(1,size(t,2));
for i=1:size(t,2)-1
    Ricker_Derivative(i)=6*10^18*(ricker(i+1)-ricker(i))/(t(i+1)-t(i));
end
[Max_Ricker_Id]=find(abs(Ricker_Derivative)>1E-13);
Ricker_Der=Ricker_Derivative(Max_Ricker_Id);
% ricker_derivative=(-10*(pi*main_frequency)^2*t+8*(pi*main_frequency)^4*t.^3).*exp(-(pi*main_frequency*t).^2);

% plot(t,ricker,t,ricker_derivative);