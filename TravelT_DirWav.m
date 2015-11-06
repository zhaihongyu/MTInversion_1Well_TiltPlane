%% 2015-8-26 Calculate the directive wave travel time of every ray trace and
% the coordinates of every ray trace
% TraveTime_DirWave_P/TraveTime_DirWave_S='Travel time of the direct P/S wave in every sediments'
% Coor_RayTrace_P/Coor_RayTrace_S='Coordinate of every transmission point from the shot to every receiver'
% "Select_~" means the data has been selected according to its travel trace
% Eliminate the Q effect 2015-9-16

%%
function [TraveTime_DirWav_P,TraveTime_DirWav_S,Coor_RayTrace_P,Coor_RayTrace_S,...
    Select_Vp_SRs,Select_Vs_SRs]=TravelT_DirWav(Receivers,Shot,Vp,Vs,Layer_Z)
% Identify the basic parameters
% Qp=[340,360,200,340];
% Qs=[90,100,50,100];
Qp=[340,360,200,340]*1000;
Qs=[90,100,50,100]*10000;

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
% According the coordinate of shot and reveivers, identify the layer number
% for every pair of source and receiver
% Allocate the memory for the parameters
Length_EverySR=zeros(Rec_Num_ALL,1);
EverySR_Z=zeros(1,Rec_Num_ALL);
Layers_ZCoor_EverySR=cell(1,Rec_Num_ALL);
LayerNum_EverySR=zeros(1,Rec_Num_ALL);

Select_Vp_SRs=cell(1,Rec_Num_ALL);
Select_Vs_SRs=cell(1,Rec_Num_ALL);
% The Q effect has been eliminate 2015-9-16
Select_Qp_SRs=cell(1,Rec_Num_ALL);
Select_Qs_SRs=cell(1,Rec_Num_ALL);

for i=1:Rec_Num_ALL
    Length_EverySR(i)=norm(Receivers_All(i,:)-Shot);
    %     Length(i)=sqrt((Wells(1,i)-Shot(1))^2+(Wells(2,i)-Shot(2))^2+(Wells(3,i)-Shot(3))^2);
    EverySR_Z(i)=Shot(3)-Receivers_All(i,3);
    %     Calculate the layer number between the shot and receiver
    if EverySR_Z(i)>0
        Layers1_Idx=find(Layer_Z<Shot(3));
        LayersZ1=Layer_Z(Layers1_Idx);
        Layers2_Idx=find(LayersZ1>Receivers_All(i,3));
        Layers1_2_Idx=Layers1_Idx(Layers2_Idx);
        % According the layers' index between the shot and receiver to
        % select the velocity 
        if isempty(Layers1_2_Idx)
            Select_Vp=Vp(Layers1_Idx(size(Layers1_Idx,1)));
            Select_Vs=Vs(Layers1_Idx(size(Layers1_Idx,1)));
            
            Select_Qp=Qp(Layers1_Idx(size(Layers1_Idx,1)));
            Select_Qs=Qs(Layers1_Idx(size(Layers1_Idx,1)));
        else
            V_Idx=[Layers1_2_Idx(1)-1;Layers1_2_Idx];
            Select_Vp=Vp(V_Idx);
            Select_Vs=Vs(V_Idx);
            
            Select_Qp=Qp(V_Idx);
            Select_Qs=Qs(V_Idx);
            %According the direction from shot to receiver to sort the
            %velocity
            Select_Vp=Select_Vp(size(Select_Vp,2):-1:1);
            Select_Vs=Select_Vs(size(Select_Vs,2):-1:1);
            
            Select_Qp=Select_Qp(size(Select_Qp,2):-1:1);
            Select_Qs=Select_Qs(size(Select_Qs,2):-1:1);
        end
        Layers_ZCoor_EverySR{i}=sort(Layer_Z(Layers1_2_Idx),'descend');
        LayerNum_EverySR(i)=size(Layers2_Idx,1)+1;
    else
        Layers1_Idx=find(Layer_Z>Shot(3));
        LayersZ1=Layer_Z(Layers1_Idx);
        Layers2_Idx=find(LayersZ1<Receivers_All(i,3));
        Layers1_2_Idx=Layers1_Idx(Layers2_Idx);
        % According the layers' index between the shot and receiver to
        % select the velocity 
        if isempty(Layers1_2_Idx)
            Select_Vp=Vp(Layers1_Idx(1)-1);
            Select_Vs=Vs(Layers1_Idx(1)-1);
            
            Select_Qp=Qp(Layers1_Idx(1)-1);
            Select_Qs=Qs(Layers1_Idx(1)-1);
        else
            V_Idx=[Layers1_2_Idx(1)-1;Layers1_2_Idx];
            Select_Vp=Vp(V_Idx);
            Select_Vs=Vs(V_Idx);
            
            Select_Qp=Qp(V_Idx);
            Select_Qs=Qs(V_Idx);
        end
        Layers_ZCoor_EverySR{i}=sort(Layer_Z(Layers1_2_Idx),'ascend');
        LayerNum_EverySR(i)=size(Layers2_Idx,1)+1;
    end
    Select_Vp_SRs{i}=Select_Vp;
    Select_Vs_SRs{i}=Select_Vs;
    
    Select_Qp_SRs{i}=Select_Qp;
    Select_Qs_SRs{i}=Select_Qs;
end
%% Using the the RayTracing_DirWav function to calculate the travel time
% Firstly, calculate the travel time of P wave
[TraveTime_DirWav_P,Coor_RayTrace_P]=RayTracing_DirWav...
    (Receivers_All,Shot,Select_Vp_SRs,LayerNum_EverySR,Layers_ZCoor_EverySR);
% Secondly, calculate the travel time of S wave
[TraveTime_DirWav_S,Coor_RayTrace_S]=RayTracing_DirWav...
    (Receivers_All,Shot,Select_Vs_SRs,LayerNum_EverySR,Layers_ZCoor_EverySR);

% TraveTime_DirWav_VpVs={TraveTime_DirWav_P;TraveTime_DirWav_S};
% Coor_RayTrace_VpVs={Coor_RayTrace_P;Coor_RayTrace_S};

%% Check the raytrace result
% figure

% Plot the shot and receivers 
% plot3(Shot,'s','MarkerSize',6);
% plot3(Receivers_All(:,1),Receivers_All(:,2),Receivers_All(:,3),'.','MarkerSize',10)

% Plot the transmission P & S wave ray between shot point and receiver point 
for i=1:Rec_Num_ALL
    % Plot the transmission P wave ray
    Coor_Sin_RayTrace_P=Coor_RayTrace_P{i};
    plot3(Coor_Sin_RayTrace_P(:,1)',Coor_Sin_RayTrace_P(:,2)',Coor_Sin_RayTrace_P(:,3)','r.-');
    % Plot the transmission S wave ray
    Coor_Sin_RayTrace_S=Coor_RayTrace_S{i};
    plot3(Coor_Sin_RayTrace_S(:,1)',Coor_Sin_RayTrace_S(:,2)',Coor_Sin_RayTrace_S(:,3)','rd-');
end
end