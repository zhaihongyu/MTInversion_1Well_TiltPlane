function [Travel_T,Direction_Cosin,SR_Vec_model]=Cal_TraT_DirCosV3(Vp,Vs,Recs_Cor,Shot_Cor)
% The 1st line of Well_Cor are X coordinates
% The 2nd line of Well_Cor are Y coordinates
% The 3rd line of Well_Cor are Z coordinates
% Set the basic parameters 2015-6-30 %
[Rec_Num_1Well,Coms,Well_Num]=size(Recs_Cor);
Rec_Num_All=Rec_Num_1Well*Well_Num;
% Merge the receivers' coordinates 2015-6-30 %
Well_Cor=zeros(Rec_Num_1Well*Well_Num,Coms);
for i=1:Well_Num
    s=(i-1)*Rec_Num_1Well+1;
    e=i*Rec_Num_1Well;
    Well_Cor(s:e,:)=Recs_Cor(:,:,i);
end

sr_vector=zeros(Rec_Num_All,3);
for i=1:Rec_Num_All
    sr_vector(i,:)=Well_Cor(i,:)-Shot_Cor;
end
Direction_Cosin=zeros(3,Rec_Num_All);
SR_Vec_model=zeros(1,Rec_Num_All);
% The 1st line data are the travel time in Vp
% The 2nd line data are the travel time in Vs
Travel_T=zeros(2,Rec_Num_All);
% Calculate the travel time
for i=1:Rec_Num_All
    SR_Vec_model(i)=norm(sr_vector(i,:));
    Travel_T(1,i)=SR_Vec_model(i)/Vp;
    Travel_T(2,i)=SR_Vec_model(i)/Vs;
    
    Direction_Cosin(:,i)=sr_vector(i,:)'/SR_Vec_model(i);
    %{
    for j=1:3
        Direction_Cosin(j,i)=sr_vector(i,j)/SR_Vec_model(i);
    end
    %}
end

% T_Interval_PS=1:round(max(Travel_T)/Sample_Interval)+100;