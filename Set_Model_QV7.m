function [Vp,Vs,Rho,Layer_Num,ELayerTime_SR,Qp,Qs]=Set_Model_QV7(Wells,Shot)
% % % Set the model parameters (Version 1)
% In this version, we choose the circle geometry around the event
Layer_Num=1;
Qs=50;
Qp=200;
% Set Q Value
%{
Qs_Min=10;
Qp_Min=20;

%}
%{
Qp=Qp_Min:Qp_Int:Qp_Min+Qp_Int*(Model_Num-1);
Qs=Qs_Min:Qs_Int:Qs_Min+Qs_Int*(Model_Num-1);

% Q Parameters
Q_Value=[Qp;Qs];
Q_Idx=1:Model_Num;
% Plot the Q value 
Fq=figure();
set(Fq,'Position',[100 100 600 1000]);
hold on
plot(Q_Idx,Q_Value,'-*','Linewidth',3,'Markersize',8);
set(gca,'YTick',[0:200:1200],'YTickLabel',{'0','200','400','600','800','1000','Infinite'});
set(gca,'XAxisLocation','top','Fontsize',14);
% set(gca,'XAxisLocation','top','Xlim',[0 8],'Fontsize',14);
grid on
xlabel('Model Index')
ylabel('Q Value');
legend('Qp','Qs','Location','Northwest');
set(gcf,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[100 100 600 1000]);
print('-r300','-djpeg','QModel');

Qp=[Qp_Min:Qp_Int:Qp_Min+Qp_Int*(Model_Num-2),5000];
Qs=[Qs_Min:Qs_Int:Qs_Min+Qs_Int*(Model_Num-2),6000];
%}
% Set Model Parameters
Deep_Initial=3000;
Layer_Int=-2000;
Vp=3900;
Vs=2100;
Rho=1.5;

% Shot point coordinates
%{
Shot_xyz=[0; 0; 2000];

Radius_Int=5;
Radius=1:Radius_Int:Radius_Int*Model_Num;
Well_Num=8;
Rec_Num_1Well=10;

Azimuth=2*pi/Well_Num;
Depth_Int=10;
Wells=zeros(Well_Num,Rec_Num_1Well,3);
% Accoding the azimuth, calculate the receivers' coordinate
for i=1:Well_Num
    for j=1:Rec_Num_1Well
        
    end
end
%}
% % coordinates of receivers in the observation Wells 
% There are 3 observe wells, and 12 receivers in each Wells. 
%{
% Slant Wells 1 coordinates
Well1_XS=-400;
Well1_XE=400;
Well1_X=Well1_XE-Well1_XS;
well1_Rx=Well1_XS:Well1_X/(Rec_Num-1):Well1_XE;

Well1_YS=800;
Well1_YE=-100;
Well1_Y=Well1_YE-Well1_YS;
well1_Ry=Well1_YS:Well1_Y/(Rec_Num-1):Well1_YE;

Well1_ZS=1400;
Well1_ZE=1700;
Well1_Z=Well1_ZE-Well1_ZS;
well1_Rz=Well1_ZS:Well1_Z/(Rec_Num-1):Well1_ZE;
% Vertical Wells 2 coordinates
well2_Rx=ones(Rec_Num,1);
well2_Rx=well2_Rx*500;
well2_Ry=ones(Rec_Num,1);
well2_Ry=well2_Ry*700;

Well2_ZS=2200;
Well2_ZE=2800;
Well2_Z=Well2_ZE-Well2_ZS;
well2_Rz=Well2_ZS:Well2_Z/(Rec_Num-1):Well2_ZE;

% Vertical Wells 3 coordinates
well3_Rx=ones(Rec_Num,1);
well3_Rx=well3_Rx*-500;
well3_Ry=ones(Rec_Num,1);
well3_Ry=well3_Ry*400;

Well3_ZS=2200;
Well3_ZE=2800;
Well3_Z=Well3_ZE-Well3_ZS;
well3_Rz=Well3_ZS:Well3_Z/(Rec_Num-1):Well3_ZE;

% Vertical Wells 4 coordinates
well4_Rx=ones(Rec_Num,1);
well4_Rx=well4_Rx*450;
well4_Ry=ones(Rec_Num,1);
well4_Ry=well4_Ry*-300;

Well4_ZS=1800;
Well4_ZE=2400;
Well4_Z=Well4_ZE-Well4_ZS;
well4_Rz=Well4_ZS:Well4_Z/(Rec_Num-1):Well4_ZE;

% Vertical Wells 5 coordinates
well5_Rx=ones(Rec_Num,1);
well5_Rx=well5_Rx*-700;
well5_Ry=ones(Rec_Num,1);
well5_Ry=well5_Ry*-800;

Well5_ZS=1800;
Well5_ZE=2400;
Well5_Z=Well5_ZE-Well5_ZS;
well5_Rz=Well5_ZS:Well5_Z/(Rec_Num-1):Well5_ZE;

% Slant Wells 6 coordinates
Well6_XS=350;
Well6_XE=-600;
Well6_X=Well6_XE-Well6_XS;
well6_Rx=Well6_XS:Well6_X/(Rec_Num-1):Well6_XE;

Well6_YS=700;
Well6_YE=-200;
Well6_Y=Well6_YE-Well6_YS;
well6_Ry=Well6_YS:Well6_Y/(Rec_Num-1):Well6_YE;

Well6_ZS=2600;
Well6_ZE=2800;
Well6_Z=Well6_ZE-Well6_ZS;
well6_Rz=Well6_ZS:Well6_Z/(Rec_Num-1):Well6_ZE;
%
%
Well1=[well1_Rx;well1_Ry;well1_Rz];
Well2=[well2_Rx';well2_Ry';well2_Rz];
Well3=[well3_Rx';well3_Ry';well3_Rz];
Well4=[well4_Rx';well4_Ry';well4_Rz];
Well5=[well5_Rx';well5_Ry';well5_Rz];
Well6=[well6_Rx;well6_Ry;well6_Rz];

% Wells=[Well1,Well2,Well3,Well4,Well5,Well6];
% Wells=[Well1,Well2,Well3,Well4,Well5];
Wells=[Well1,Well2,Well3,Well4];
Well_Num=4;
%}
% % % Set the model parameters (Version 2)
%{
Layer_Num=5;
Qp_Max=120;
Qs_Max=180;
Q_Int=10;
Qs_Int=6;

Qp=Qp_Max:-Q_Int:Qp_Max-Q_Int*(Layer_Num-1);
Qs=Qs_Max:-Qs_Int:Qs_Max-Qs_Int*(Layer_Num-1);

%
Deep_Initial=1550;
Layer_Int=-200;
Vp=4500;
Vs=2600;
Rho=2;
Rec_Num=8;

Model_X=[-500,500];
Model_Y=[-500,500];
% Shot point coordinates
Shot_xyz=[0 0 1550];

% % coordinates of receivers in the observation Wells 
% There are 3 observe wells, and 12 receivers in each Wells. 
% Slant Wells 1 coordinates
Well1_XS=-300;
Well1_XE=300;
Well1_X=Well1_XE-Well1_XS;
well1_Rx=Well1_XS:Well1_X/(Rec_Num-1):Well1_XE;

Well1_YS=250;
Well1_YE=-300;
Well1_Y=Well1_YE-Well1_YS;
well1_Ry=Well1_YS:Well1_Y/(Rec_Num-1):Well1_YE;

Well1_ZS=700;
Well1_ZE=900;
Well1_Z=Well1_ZE-Well1_ZS;
well1_Rz=Well1_ZS:Well1_Z/(Rec_Num-1):Well1_ZE;
% Vertical Wells 2 coordinates
well2_Rx=ones(Rec_Num,1);
well2_Rx=well2_Rx*250;
well2_Ry=ones(Rec_Num,1);
well2_Ry=well2_Ry*350;

Well2_ZS=800;
Well2_ZE=1300;
Well2_Z=Well2_ZE-Well2_ZS;
well2_Rz=Well2_ZS:Well2_Z/(Rec_Num-1):Well2_ZE;

% Vertical Wells 3 coordinates
well3_Rx=ones(Rec_Num,1);
well3_Rx=well3_Rx*-250;
well3_Ry=ones(Rec_Num,1);
well3_Ry=well3_Ry*200;

Well3_ZS=900;
Well3_ZE=1200;
Well3_Z=Well3_ZE-Well3_ZS;
well3_Rz=Well3_ZS:Well3_Z/(Rec_Num-1):Well3_ZE;
%}
% Plot the Geometry
%{
figure
hold on
% Plot the receivers and shot point 
plot3(well1_Rx,well1_Ry,well1_Rz,'bv-.','MarkerSize',10,'Linewidth',2);
plot3(well2_Rx,well2_Ry,well2_Rz,'bv-.','MarkerSize',10,'Linewidth',2);
plot3(well3_Rx,well3_Ry,well3_Rz,'bv-.','MarkerSize',10,'Linewidth',2);
plot3(well4_Rx,well4_Ry,well4_Rz,'bv-.','MarkerSize',10,'Linewidth',2);
plot3(well5_Rx,well5_Ry,well5_Rz,'bv-.','MarkerSize',10,'Linewidth',2);
plot3(well6_Rx,well6_Ry,well6_Rz,'bv-.','MarkerSize',10,'Linewidth',2);
plot3(Shot_xyz(1),Shot_xyz(2),Shot_xyz(3),'r*','MarkerSize',14,'Linewidth',2);
%}

% Plot the model surface
%{
Model_X=[-900,900];
Model_Y=[-900,900];
% Plot the Layer and layer face
Layer_x=[Model_X(1);Model_X(2);Model_X(2);Model_X(1);];
Layer_y=[Model_Y(1);Model_Y(1);Model_Y(2);Model_Y(2);];
Layer_Z=zeros(Layer_Num+1,1);

Layer_Color=[0.5,1,0.5];
for i=1:Layer_Num+1
    Layer_z=ones(4,1);
    Layer_Z(i)=Deep_Initial+(i-1)*Layer_Int;
    Layer_z=Layer_z*Layer_Z(i);
%     [Layer_X,Layer_Y,Layer_Z]=meshgrid(Layer_x,Layer_y,Layer_z);
    
    h1=patch(Layer_x,Layer_y,Layer_z,Layer_Color);
    set(h1,'EdgeAlpha',0.6,'FaceAlpha',0.3);
end

Face1_x=[Model_X(1);Model_X(1);Model_X(2);Model_X(2);];
Face1_y=[Model_Y(1);Model_Y(1);Model_Y(1);Model_Y(1);];

Face2_x=[Model_X(2);Model_X(2);Model_X(2);Model_X(2);];
Face2_y=[Model_Y(1);Model_Y(1);Model_Y(2);Model_Y(2);];

Face3_x=[Model_X(1);Model_X(1);Model_X(2);Model_X(2);];
Face3_y=[Model_Y(2);Model_Y(2);Model_Y(2);Model_Y(2);];

Face4_x=[Model_X(1);Model_X(1);Model_X(1);Model_X(1);];
Face4_y=[Model_Y(1);Model_Y(1);Model_Y(2);Model_Y(2);];

for i=1:Layer_Num
    Deep(1)=Deep_Initial+(i-1)*Layer_Int;
    Deep(2)=Deep_Initial+i*Layer_Int;
    Face_z=[Deep(2);Deep(1);Deep(1);Deep(2);];
%     Plot the Face 1

    h1=patch(Face1_x,Face1_y,Face_z,Layer_Color);
    set(h1,'EdgeAlpha',0.6,'FaceAlpha',0.3);
%     Plot the Face 2

    h1=patch(Face2_x,Face2_y,Face_z,Layer_Color);
    set(h1,'EdgeAlpha',0.6,'FaceAlpha',0.3);
%     Plot the Face 3

    h1=patch(Face3_x,Face3_y,Face_z,Layer_Color);
    set(h1,'EdgeAlpha',0.6,'FaceAlpha',0.3);
%     Plot the Face 4

    h1=patch(Face4_x,Face4_y,Face_z,Layer_Color);
    set(h1,'EdgeAlpha',0.6,'FaceAlpha',0.3);
end


set(gca,'ZDir','reverse','FontSize',14);
axis([-1000 1000 -1000 1000 1000 3000]);
grid on
view(-30.5,12);
xlabel('X');
ylabel('Y');
zlabel('Depth/m');
set(gcf,'position',[400 100 600 1000])
set(gcf,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[400 100 600 1000]);
print('-r300','-djpeg','Model');
%}

Rec_Num=size(Wells,1);
% Calculate the attenuation time of different Q
Layer_Z=zeros(Layer_Num+1,1);
for i=1:Layer_Num+1
    Layer_Z(i)=Deep_Initial+(i-1)*Layer_Int;
end
Length=zeros(Rec_Num,1);
Layer_Num=zeros(Rec_Num,1);
Layers_ShotRec=cell(Rec_Num,1);
SR_Z=zeros(1,Rec_Num);
%     According the z coordinate of receiver, identify the Q index  in every layer
for i=1:Rec_Num
    Length(i)=norm(Wells(i,:)-Shot);
    %     Length(i)=sqrt((Wells(1,i)-Shot(1))^2+(Wells(2,i)-Shot(2))^2+(Wells(3,i)-Shot(3))^2);
    SR_Z(i)=Shot(3)-Wells(i,3);
    %     Calculate the layer number between the shot and receiver
    if SR_Z(i)>0
        Layers1=find(Layer_Z<Shot(3));
        Layers2=find(Layer_Z(Layers1)>Wells(i,3));
        Layers_ShotRec{i}=sort(Layer_Z(Layers2),'descend');
        Layer_Num(i)=size(Layers2,1)+1;
    else
        Layers1=find(Layer_Z>Shot(3));
        Layers2=find(Layer_Z(Layers1)<Wells(i,3));
        Layers_ShotRec{i}=sort(Layer_Z(Layers2),'ascend');
        Layer_Num(i)=size(Layers2,1)+1;
    end
end

% According the z coordinate of receiver, identify the  attenuation time in every layer

Layer_Num_Max=max(Layer_Num);
ELayerTime_SR=zeros(Rec_Num,Layer_Num_Max,2);
for i=1:Rec_Num
    ELayerTime_SR(i,1,1)=Length(i)/Vp;
    ELayerTime_SR(i,1,2)=Length(i)/Vs;
    % This method have bug, when the reveivers and source are on the same
    % horizontal plane
    %{
    for j=1:Layer_Num(i)
        Layer_Z=abs(Layer_Int);
        if Layer_Z*j>SR_Z(i)
            Layer_Z=SR_Z(i)-Layer_Z*(j-1);
        end
        ELayerTime_SR(i,j,1)=Length(i)*(Layer_Z/SR_Z(i))/Vp;
        ELayerTime_SR(i,j,2)=Length(i)*(Layer_Z/SR_Z(i))/Vs;
    end
    %}
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% According to the ray tracing method, identify the  attenuation time in
% every layer (Version 3.0 - Succuss)
%{
Layer_Num_Max=max(Layer_Num);
Layers_R=zeros(Rec_Num,Layer_Num_Max);
ELayerTime_SR=zeros(Rec_Num,Layer_Num_Max,2);
ShotRec_Vector=zeros(3,Rec_Num);

for i=1:Rec_Num
    %     Calculate the sphere coordinate
    ShotRec_Vector(:,i)=Wells(:,i)-Shot;
    R_ShotRec=Length(i);
    Rxy_ShotRec=sqrt(ShotRec_Vector(1,i)^2+ShotRec_Vector(2,i)^2);
    Theta=acos(ShotRec_Vector(3,i)/R_ShotRec);
    if ShotRec_Vector(2,i)>0
        Phi=acos(ShotRec_Vector(1,i)/Rxy_ShotRec);
    else
        Phi=acos(ShotRec_Vector(1,i)/Rxy_ShotRec)+pi;
    end
    %     According the sphere coordinate, using ray tracing method
    switch Layer_Num(i)
        case 1
            %%%%%%%%%%%%%%%%%%
            %         When the layer number is 1
            ELayerTime_SR(i,1,1)=Length(i)/Vp;
            ELayerTime_SR(i,1,2)=Length(i)/Vs;
        otherwise
            %%%%%%%%%%%%%%%%%%%%%%
            %         When the layer number >= 2
            Layers_XYZ=zeros(3,Layer_Num(i)+1);
            Layers_XYZ(:,1)=Shot;
            Layers_XYZ(:,Layer_Num(i)+1)=Wells(:,i);
            
            ShotRec_Layers=Layers_ShotRec{i};
            Layers_XYZ(3,2:Layer_Num(i))=ShotRec_Layers;
            Delta_Theta=Theta/3;
            while 1
                %                 %            Firstly, calculate the fisrt layer
                SingleLayer_Z1=ShotRec_Layers(1)-Shot(3);
                SingleLayer_R1=abs(SingleLayer_Z1/cos(Theta+Delta_Theta));
                SingleLayer_X1=SingleLayer_R1*sin(Theta+Delta_Theta)*cos(Phi);
                SingleLayer_Y1=SingleLayer_R1*sin(Theta+Delta_Theta)*sin(Phi);
                Layers_XYZ(:,2)=[SingleLayer_X1+Shot(1);SingleLayer_Y1+Shot(2);ShotRec_Layers(1)];
                %                 Calculate the transmission angle
                if Theta>pi/2
                    Theta2=asin(sin(Theta)*V(1)/V(2));
                    Theta_Sphere=pi-Theta2;
                else
                    %                     Also need to correct%
                    Theta2=asin(sin(Theta)*V(2)/V(1));
                    Theta_Sphere=Theta2;
                end
                
                %                 %             Then, calculate the intermediate layers
                for j=2:Layer_Num(i)
                    SingleLayer_ZInter=Layers_XYZ(3,j+1)-Layers_XYZ(3,j);
                    SingleLayer_RInter=abs(SingleLayer_ZInter/cos(Theta_Sphere));
                    SingleLayer_XInter=SingleLayer_RInter*sin(Theta_Sphere)*cos(Phi);
                    SingleLayer_YInter=SingleLayer_RInter*sin(Theta_Sphere)*sin(Phi);
                    Layers_XYZ(:,j+1)=[SingleLayer_XInter+Layers_XYZ(1,j);SingleLayer_YInter+Layers_XYZ(2,j);Layers_XYZ(3,j+1)];
                    %                 Calculate the transmission angle
                    if Theta>pi/2
                        Theta2=asin(sin(Theta)*V(1)/V(2));
                        Theta_Sphere=pi-Theta2;
                    else
                        %                         Also need to correct%
                        Theta2=asin(sin(Theta)*V(2)/V(1));
                        Theta_Sphere=Theta2;
                    end
                end
                %                 According the result, adjust the Theta
                Error_Vector=Layers_XYZ(:,Layer_Num(i)+1)-Wells(:,i);
                if Error_Vector(1)*ShotRec_Vector(1,i)>0
                    Delta_Theta=-Delta_Theta/2;
                else
                    Delta_Theta=Delta_Theta/2;
                end
                %                 According the distance between the receiver and
                %                 calculating result, idenfy the loop whether need breaking
                Error_Distance=norm(Error_Vector);
                if Error_Distance<=10^(-4)
                    %                     Calculate the traveling time
                    for j=1:Layer_Num(i)
                        SingleLayer_Vector=Layers_XYZ(:,j+1)-Layers_XYZ(:,j);
                        Layers_R(i,j)=norm(SingleLayer_Vector);
                        ELayerTime_SR(i,j,1)=Layers_R(i,j)/Vp;
                        ELayerTime_SR(i,j,2)=Layers_R(i,j)/Vs;
                    end
                    break;
                end
            end
    end
end
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% According to the ray tracing method, identify the  attenuation time in
% every layer (Version 2.0)
%{
Layer_Num_Max=max(Layer_Num);
Layers_R=zeros(Rec_Num,Layer_Num_Max);
ELayerTime_SR=zeros(Rec_Num,Layer_Num_Max,2);
ShotRec_Vector=zeros(3,Rec_Num);
for i=1:Rec_Num
    %     Calculate the sphere coordinate
    ShotRec_Vector(:,i)=Wells(:,i)-Shot;
    R_ShotRec=Length(i);
    Rxy_ShotRec=sqrt(ShotRec_Vector(1,i)^2+ShotRec_Vector(2,i)^2);
    Theta=acos(ShotRec_Vector(3,i)/R_ShotRec);
    if ShotRec_Vector(2,i)>0
        Phi=acos(ShotRec_Vector(1,i)/Rxy_ShotRec);
    else
        Phi=acos(ShotRec_Vector(1,i)/Rxy_ShotRec)+pi;
    end
    %     According the sphere coordinate, using ray tracing method
    switch Layer_Num(i)
        case 1
            %%%%%%%%%%%%%%%%%%
            %         When the layer number is 1
            ELayerTime_SR(i,1,1)=Length(i)/Vp;
            ELayerTime_SR(i,1,2)=Length(i)/Vs;
            
        case 2
            %%%%%%%%%%%%%%%%%%
            %         When the layer number is 2
            Layers_XYZ=zeros(3,Layer_Num(i)+1);
            Layers_XYZ(:,1)=Shot;
            Layers_XYZ(:,Layer_Num(i)+1)=Wells(:,i);
            ShotRec_Layers=Layers_ShotRec{i};
            Delta_Theta=Theta/3;
            while 1
                %             Firstly, calculate the fisrt layer
                SingleLayer_Z1=ShotRec_Layers(1)-Shot(3);
                SingleLayer_R1=abs(SingleLayer_Z1/cos(Theta+Delta_Theta));
                SingleLayer_X1=SingleLayer_R1*sin(Theta+Delta_Theta)*cos(Phi);
                SingleLayer_Y1=SingleLayer_R1*sin(Theta+Delta_Theta)*sin(Phi);
                Layers_XYZ(:,2)=[SingleLayer_X1+Shot(1);SingleLayer_Y1+Shot(2);ShotRec_Layers(1)];
                %                 Calculate the transmission angle
                if Theta>pi/2
                    Theta2=asin(sin(Theta)*V(1)/V(2));
                    Theta_Sphere=pi-Theta2;
                else
                    Theta2=asin(sin(Theta)*V(2)/V(1));
                    Theta_Sphere=Theta2;
                end
                %             Then, calculate the next layer
                SingleLayer_Z2=Wells(3,i)-ShotRec_Layers(1);
                SingleLayer_R2=abs(SingleLayer_Z2/cos(Theta_Sphere));
                SingleLayer_X2=SingleLayer_R2*sin(Theta_Sphere)*cos(Phi);
                SingleLayer_Y2=SingleLayer_R2*sin(Theta_Sphere)*sin(Phi);
                ErrorLayer_XYZ=[SingleLayer_X2+Layers_XYZ(1,2);SingleLayer_Y2+Layers_XYZ(2,2);Wells(3,i)];
                %                 According the result, adjust the Theta
                Error_Vector=ErrorLayer_XYZ-Wells(:,i);
                if Error_Vector(1)*ShotRec_Vector(1,i)>0
                    Delta_Theta=-Delta_Theta/2;
                else
                    Delta_Theta=Delta_Theta/2;
                end
                %                 According the distance between the receiver and
                %                 calculating result, idenfy the loop whether need breaking
                Error_Distance=norm(Error_Vector);
                if Error_Distance<=10^(-4)
                    %                     Calculate the traveling time
                    for j=1:Layer_Num(i)
                        SingleLayer_Vector=Layers_XYZ(:,j+1)-Layers_XYZ(:,j);
                        Layers_R(i,j)=norm(SingleLayer_Vector);
                        ELayerTime_SR(i,j,1)=Layers_R(i,j)/Vp;
                        ELayerTime_SR(i,j,2)=Layers_R(i,j)/Vs;
                    end
                    break;
                end
            end
            
        otherwise
            %%%%%%%%%%%%%%%%%%%%%%
            %         When the layer number more than 2
            Layers_XYZ=zeros(3,Layer_Num(i)+1);
            Layers_XYZ(:,1)=Shot;
            Layers_XYZ(:,Layer_Num(i)+1)=Wells(:,i);
            
            ShotRec_Layers=Layers_ShotRec{i};
            Layers_XYZ(3,2:Layer_Num(i))=ShotRec_Layers;
            Delta_Theta=Theta/3;
            while 1
                %                 %            Firstly, calculate the fisrt layer
                SingleLayer_Z1=ShotRec_Layers(1)-Shot(3);
                SingleLayer_R1=abs(SingleLayer_Z1/cos(Theta+Delta_Theta));
                SingleLayer_X1=SingleLayer_R1*sin(Theta+Delta_Theta)*cos(Phi);
                SingleLayer_Y1=SingleLayer_R1*sin(Theta+Delta_Theta)*sin(Phi);
                Layers_XYZ(:,2)=[SingleLayer_X1+Shot(1);SingleLayer_Y1+Shot(2);ShotRec_Layers(1)];
                %                 Calculate the transmission angle
                if Theta>pi/2
                    Theta2=asin(sin(Theta)*V(1)/V(2));
                    Theta_Sphere=pi-Theta2;
                else
                    %                     Also need to correct%
                    Theta2=asin(sin(Theta)*V(2)/V(1));
                    Theta_Sphere=Theta2;
                end
                
                %                 %             Then, calculate the intermediate layers
                for j=2:Layer_Num(i)-1
                    SingleLayer_ZInter=Layers_XYZ(3,j+1)-Layers_XYZ(3,j);
                    SingleLayer_RInter=abs(SingleLayer_ZInter/cos(Theta_Sphere));
                    SingleLayer_XInter=SingleLayer_RInter*sin(Theta_Sphere)*cos(Phi);
                    SingleLayer_YInter=SingleLayer_RInter*sin(Theta_Sphere)*sin(Phi);
                    Layers_XYZ(:,j+1)=[SingleLayer_XInter+Layers_XYZ(1,j);SingleLayer_YInter+Layers_XYZ(2,j);Layers_XYZ(3,j+1)];
                    %                 Calculate the transmission angle
                    if Theta>pi/2
                        Theta2=asin(sin(Theta)*V(1)/V(2));
                        Theta_Sphere=pi-Theta2;
                    else
                        %                         Also need to correct%
                        Theta2=asin(sin(Theta)*V(2)/V(1));
                        Theta_Sphere=Theta2;
                    end
                end
                
                %              %              In the end, calculate the last layer
                SingleLayer_ZL=Wells(3,i)-Layers_XYZ(Layer_Num(i));
                SingleLayer_RL=abs(SingleLayer_ZL/cos(Theta_Sphere));
                SingleLayer_XL=SingleLayer_RL*sin(Theta_Sphere)*cos(Phi);
                SingleLayer_YL=SingleLayer_RL*sin(Theta_Sphere)*sin(Phi);
                ErrorLayer_XYZ=[SingleLayer_XL+Layers_XYZ(1,2);SingleLayer_YL+Layers_XYZ(2,2);Wells(3,i)];
                %                 According the result, adjust the Theta
                Error_Vector=ErrorLayer_XYZ-Wells(:,i);
                if Error_Vector(1)*ShotRec_Vector(1,i)>0
                    Delta_Theta=-Delta_Theta/2;
                else
                    Delta_Theta=Delta_Theta/2;
                end
                %                 According the distance between the receiver and
                %                 calculating result, idenfy the loop whether need breaking
                Error_Distance=norm(Error_Vector);
                if Error_Distance<=10^(-4)
                    %                     Calculate the traveling time
                    for j=1:Layer_Num(i)
                        SingleLayer_Vector=Layers_XYZ(:,j+1)-Layers_XYZ(:,j);
                        Layers_R(i,j)=norm(SingleLayer_Vector);
                        ELayerTime_SR(i,j,1)=Layers_R(i,j)/Vp;
                        ELayerTime_SR(i,j,2)=Layers_R(i,j)/Vs;
                    end
                    break;
                end
            end
    end
    %}
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     According to the ray tracing method, identify the  attenuation
    %     time in every layer (Version 1.0)
    %{
    if Layer_Num(i)==1
        %         When the layer number is 1
        ELayerTime_SR(i,1,1)=Length(i)/Vp;
        ELayerTime_SR(i,1,2)=Length(i)/Vs;
    else
        %         When the layer number more than 2
        ShotRec_Layers=Layers_ShotRec{i};
        for j=1:2:Layer_Num(i)-1
            %             Firstly, calculate the fisrt layer
            SingleLayer_Z1=ShotRec_Layers(j)-Shot(3);
            SingleLayer_R1=SingleLayer_Z1/cos(Theta);
            SingleLayer_X1=SingleLayer_R1*sin(Theta)*cos(Phi);
            SingleLayer_Y1=SingleLayer_R1*sin(Theta)*sin(Phi);
            Layer1_XYZ=[SingleLayer_X1+Shot(1);SingleLayer_Y1+Shot(2);ShotRec_Layers(j)];
            
            ELayerTime_SR(i,1,1)=SingleLayer_R1/Vp;
            ELayerTime_SR(i,1,2)=SingleLayer_R1/Vs;
            %             Then, calculate the next layer
            if j+1>Layer_Num(i)-1
                SingleLayer_Z1=Wells(3,i)-ShotRec_Layers(j);
                SingleLayer_R1=SingleLayer_Z1/cos(Theta);
                SingleLayer_X1=SingleLayer_R1*sin(Theta)*cos(Phi);
                SingleLayer_Y1=SingleLayer_R1*sin(Theta)*sin(Phi);
                Layer2_XYZ=[SingleLayer_X1+Shot(1);SingleLayer_Y1+Shot(2);ShotRec_Layers(j)];
                
                ELayerTime_SR(i,1,1)=Length(i)/Vp;
                ELayerTime_SR(i,1,2)=Length(i)/Vs;
            else
                SingleLayer_Z1=ShotRec_Layers(j)-Shot(3);
                SingleLayer_R1=SingleLayer_Z1/cos(Theta);
                SingleLayer_X1=SingleLayer_R1*sin(Theta)*cos(Phi);
                SingleLayer_Y1=SingleLayer_R1*sin(Theta)*sin(Phi);
                Layer1_XYZ=[SingleLayer_X1+Shot(1);SingleLayer_Y1+Shot(2);ShotRec_Layers(j)];
                
                ELayerTime_SR(i,1,1)=Length(i)/Vp;
                ELayerTime_SR(i,1,2)=Length(i)/Vs;
            end
            
        end
    end
    %}
end