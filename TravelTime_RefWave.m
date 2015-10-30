% Calculate the total travel distance and travel time of reflect wave2015-9-14

function [Reflection_Points,TravelDistance_RefWave,TravelTime_RefWave_P,TravelTIme_RefWave_S]=...
    TravelTime_RefWave(Shot,Receivers,Plane_Function,Vp,Vs)
% Set the basic parameters
[Rec_Num_1Well,Coms,Well_Num]=size(Receivers);
% Layer_Num=size(Vp,2);
Rec_Num_ALL=Rec_Num_1Well*Well_Num;
% Combine all the receivers' coordinate
Receivers_All=zeros(Rec_Num_ALL,Coms);
for i=1:Well_Num
    s=(i-1)*Rec_Num_1Well+1;
    e=i*Rec_Num_1Well;
    Receivers_All(s:e,:)=Receivers(:,:,i);
end

%% According the reflection point, calculate the travel time
Reflection_Points=zeros(Rec_Num_ALL,3);
TravelDistance_RefWave=zeros(2,Rec_Num_ALL);
TravelTime_RefWave_P=cell(1,Rec_Num_ALL);
TravelTIme_RefWave_S=cell(1,Rec_Num_ALL);
for i=1:Rec_Num_ALL
    [Reflection_Point,TravelDistance_SingleRef]=Cal_Reflect_Point(Shot,Receivers_All(i,:),Plane_Function);
    Reflection_Points(i,:)=Reflection_Point;
    TravelDistance_RefWave(1,i)=sum(TravelDistance_SingleRef);
    TravelDistance_RefWave(2,i)=TravelDistance_RefWave(1,i);
    TravelTime_RefWave_P{i}=[TravelDistance_RefWave(1,i)/Vp{i}];
    TravelTIme_RefWave_S{i}=[TravelDistance_RefWave(2,i)/Vs{i}];
    %In this place consider the multi-layers situation
    %{
    Layer_Num=size(TravelDistance_RefWave{i},2);
    TravelTime_P=zeros(1,Layer_Num);
    TravelTIme_S=zeros(1,Layer_Num);
    for j=1:Layer_Num
        TravelTime_P(i)=TravelDistance_SingleRef(j)/Vp(i);
        TravelTIme_S(i)=TravelDistance_SingleRef(j)/Vs(i);
    end
    TravelTime_RefWave_P{i}=TravelTime_P;
    TravelTIme_RefWave_S{i}=TravelTIme_S;
    %}
end
% Plot the reflection points
pot3(Reflection_Points(:,1),Reflection_Points(:,2),Reflection_Points(:,3),'-k');
end