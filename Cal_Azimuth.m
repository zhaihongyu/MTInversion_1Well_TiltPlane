function [Azimuth,Model_Num]=Cal_Azimuth(Well_Num)
% % % % % % % % % % % 2015-4-24 % % % % % % % % % % %
% According to the azimuth interval, Identify the model number %
% % % % % % % % % % % % % % % % % % % % % % % % % % % 
Azimuth_Ave=pi/(Well_Num*4);
% 2Using 2 pi azimuth 015-4-24 %
%{
Azimuth_Int=2*pi/36;
Model_Num=2*pi/Azimuth_Int+1;
%}
% Only using pi azimuth2015-4-27 %
Azimuth_Int=pi/36;
Model_Num=pi/Azimuth_Int+1;
Azimuth=zeros(Well_Num,Model_Num);
for i=1:Model_Num
    for j=1:Well_Num
        Azimuth(j,i)=(j-1)*Azimuth_Ave+(i-1)*Azimuth_Int;
    end
end
end