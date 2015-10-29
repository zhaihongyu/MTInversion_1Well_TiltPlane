function [Att_Energy_1Well]=Cal_AttEnergy(Well_Num,PWave_Ori,SWave_Ori,PWave_Q,SWave_Q)
[Rec_Num,Wave_L,Com]=size(PWave_Q);
RecNum_1Well=Rec_Num/Well_Num;

% Calculate the attenuation energy of every wavelet 2015-4-23 %
Att_Energy_EveryCom=zeros(Rec_Num,Com,2);
Att_Energy_EveryRec=zeros(Rec_Num,2);
for i=1:Rec_Num
    for j=1:Com
        Att_Energy_EveryCom(i,j,1)=sum((PWave_Ori(i,:,j)-PWave_Q(i,:,j)).^2);
        Att_Energy_EveryCom(i,j,2)=sum((SWave_Ori(i,:,j)-SWave_Q(i,:,j)).^2);
    end
    Att_Energy_EveryRec(i,1)=sum(Att_Energy_EveryCom(i,:,1));
    Att_Energy_EveryRec(i,2)=sum(Att_Energy_EveryCom(i,:,2));
end

Att_Energy_1Well=zeros(1,2);
% Calculate the total energy of all the wavelets 2015-4-28 %
Att_Energy_1Well(1)=sum(Att_Energy_EveryRec(:,1))+sum(Att_Energy_EveryRec(:,2));
Att_Energy_1Well(2)=sum(Att_Energy_EveryRec(:,2));
% Calculate the total energy of all the wavelets 2015-4-23 %
% Att_Energy_1Well(1)=sum(Att_Energy_EveryRec(:,1))/Well_Num;
% Att_Energy_1Well(2)=sum(Att_Energy_EveryRec(:,2))/Well_Num;
end