function [Direction_Cosine_P,Direction_Cosine_S,Travel_Distance,Average_VpVs]=...
    Cal_DirectionCosine(Coor_RayTrace_P,Coor_RayTrace_S,TravelTime_P,TravelTime_S)

% Set the basic parameters 2015-6-30 %
Rec_Num_All=size(Coor_RayTrace_P,2);

sr_vectors_P=zeros(Rec_Num_All,3);
sr_vectors_S=zeros(Rec_Num_All,3);

Direction_Cosine_P=zeros(3,Rec_Num_All);
Direction_Cosine_S=zeros(3,Rec_Num_All);

Travel_Distance=zeros(2,Rec_Num_All);
Average_VpVs=zeros(2,Rec_Num_All);
for i=1:Rec_Num_All
    RayTrace_CoorP=Coor_RayTrace_P{i};
    RayTrace_CoorS=Coor_RayTrace_S{i};
    % Find the sediments interface number
    Sed_Int_Num=size(RayTrace_CoorP,1);
    sr_vectors_P(i,:)=RayTrace_CoorP(Sed_Int_Num,:)-RayTrace_CoorP(1,:);
    sr_vectors_S(i,:)=RayTrace_CoorS(Sed_Int_Num,:)-RayTrace_CoorS(1,:);
    % Calculate the total travel distance
    for j=1:Sed_Int_Num-1
        Travel_Vector_P=RayTrace_CoorP(j+1,:)-RayTrace_CoorP(j,:);
        Travel_Vector_S=RayTrace_CoorS(j+1,:)-RayTrace_CoorS(j,:);
        Travel_Distance(1,i)=Travel_Distance(1,i)+norm(Travel_Vector_P);
        Travel_Distance(2,i)=Travel_Distance(2,i)+norm(Travel_Vector_S);
    end
    % Calculate the direction cosine
    DS_Vector_P=RayTrace_CoorP(2,:)-RayTrace_CoorP(1,:);
    DS_Vector_S=RayTrace_CoorS(2,:)-RayTrace_CoorS(1,:);
    Direction_Cosine_P(:,i)=DS_Vector_P'/norm(DS_Vector_P);
    Direction_Cosine_S(:,i)=DS_Vector_S'/norm(DS_Vector_S);
    % Calculate the 
    Average_VpVs(1,i)=Travel_Distance(1,i)/sum(TravelTime_P{i});
    Average_VpVs(2,i)=Travel_Distance(2,i)/sum(TravelTime_S{i});
end
% Direction_Cosine={Direction_Cosine_P,Direction_Cosine_S};
end