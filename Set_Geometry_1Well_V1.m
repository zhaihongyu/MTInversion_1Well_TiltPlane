% % %  2015-8-26 % % %
% In this version, we choose the 1 vertical wells and set the shots
% position on a horizontal plane for several different depths 

% % % 2015-9-14 % % %
% Add a tilt plane as the reflect plane for the increasing the MT
% information and improving the inversion result
function [Receivers,Shot,Well_Num,Vp,Vs,Layer_Z,Plane_Function]=Set_Geometry_1Well_V1
%% Set 1 vertical well and 1 horizontal well to test the inversion results 2015-8-6 %
Well_Num=1;
% Set the receivers' coordinates 2015-6-7 % 
Vp=[4400, 4200, 3500,4300];
Vs=[2400, 2200, 1700,2300];
% Radius=50;
Radius=150;
Rec_Depth_Int=15;
Rec_Num_1Well=10;

Receivers=ones(Rec_Num_1Well,3,Well_Num);
Azimuth_Int=pi/(Well_Num*5);
Azimuth=Azimuth_Int:Azimuth_Int:Azimuth_Int*(Well_Num);
% Azimuth=pi/8:pi/8:pi/8*Well_Num;
% Calculate receiver position of the vertical well
%{
for j=1:Rec_Num_1Well
    Receivers(j,1,1)=Radius*cos(Azimuth(1));
    Receivers(j,2,1)=Radius*sin(Azimuth(1));
    Receivers(j,3,1)=j*Rec_Depth_Int+2300;
end
%}
for i=1:Well_Num
    for j=1:Rec_Num_1Well
        Receivers(j,1,i)=Radius*cos(Azimuth(i));
        Receivers(j,2,i)=Radius*sin(Azimuth(i));
        Receivers(j,3,i)=j*Rec_Depth_Int+2400;
    end
end

%% Shot point coordinate 2015-5-30 %
% There is only one shot coordinate 2015-5-28 %
Shot=[0 0 Receivers(Rec_Num_1Well/2,3,1)];
% Shot=[0 0 2000];

%Calculate the circle of well 2015-6-9 %
Circle_Azimuth=0:2*pi/100:2*pi;
Circle_Azimuth_Num=size(Circle_Azimuth,2);
Circle_Line=zeros(Circle_Azimuth_Num,3);
for i=1:Circle_Azimuth_Num
    Circle_Line(i,1)=Radius*cos(Circle_Azimuth(i));
    Circle_Line(i,2)=Radius*sin(Circle_Azimuth(i));
    Circle_Line(i,3)=Receivers(1,3,1);
end

%% Plot the geometry in 2D  viewer
f1=figure;
% Basic figure parameters 2015-7-20 %
Fontsize=9;
Markersize=4;
Linewidth=1;
% Plot the geometry in 2D  viewer
hold on
% Plot the direction of geometry
Position_X=zeros(1,2);
Position_Y=zeros(1,2);
Vector_X=[0 Radius+Radius/3];
Vector_Y=[Radius+Radius/3 0];
quiver(Position_X,Position_Y,Vector_X,Vector_Y,'k','Linewidth',Linewidth-0.5)
text(Radius/12,Radius+Radius/3,'N','FontSize',Fontsize);
text(Radius+Radius/4,-Radius/12,'E','FontSize',Fontsize);
% Plot the circle of wells 2015-6-9 %
plot(Circle_Line(:,1),Circle_Line(:,2),'.k','Linewidth',Linewidth);
% Plot the wells 2015-6-29 %
for i=1:Well_Num
    plot(Receivers(1,1,i),Receivers(1,2,i),'ob',...
        'MarkerSize',Markersize,'Linewidth',Linewidth,'Markerfacecolor','b')
    Borehole=['B',num2str(i)];
    text(Receivers(1,1,i)+10,Receivers(1,2,i)+20,Borehole,'FontSize',Fontsize);
end
%{
plot(Receivers(1,1,1),Receivers(1,2,1),'ob',...
    'MarkerSize',10,'Linewidth',1,'Markerfacecolor','b')
text(Receivers(1,1,1)+10,Receivers(1,2,1)+5,'B1','FontSize',Fontsize);

plot(Receivers(1,1,2),Receivers(1,2,2),...
    'ob','MarkerSize',10,'Linewidth',1,'Markerfacecolor','b')
text(Receivers(1,1,2)+10,Receivers(1,2,2)+5,'B2','FontSize',Fontsize);
%}
% Plot the shots plane 2015-5-28 %
plot(Shot(1),Shot(2),'r*','MarkerSize',Markersize,'Linewidth',Linewidth);
% title('a','FontSize',Fontsize);
axis square
axis off
text(-Radius/10,-Radius-Radius/8,'(a)','FontSize',Fontsize);
set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 8 8]);
print(f1,'-r300','-dtiff','Geometry-2D-3 Well');

%% Plot the geometry in and 3D viewer
f2=figure;
hold on
% Plot the direction of geometry
Position3D_X=zeros(1,3);
Position3D_Y=zeros(1,3);
Position3D_Z=ones(1,3)*Receivers(1,3,1);
Vector3D_X=[0 Radius+Radius/3 0];
Vector3D_Y=[Radius+Radius/3 0 0];
Vector3D_Z=[0 0 (Radius+Radius/3)];
quiver3(Position3D_X,Position3D_Y,Position3D_Z,...
    Vector3D_X,Vector3D_Y,Vector3D_Z,'k','Linewidth',Linewidth-0.5)
text(5,Radius+Radius/2.5,Position3D_Z(1),'N','FontSize',Fontsize);
text(Radius+Radius/2.5,5,Position3D_Z(1),'E','FontSize',Fontsize);


% text(Radius+35,5,Position3D_Z(1),'E','FontSize',Fontsize);
% Plot the circle of wells 2015-6-9 %
% plot3(Circle_Well(:,1),Circle_Well(:,2),Circle_Well(:,3),'.k','Linewidth',2);
% Plot the wells 2015-6-7 %
plot3(Receivers(:,1,1)-Radius/2,Receivers(:,2,1),Receivers(:,3,1),...
    '-bv','MarkerSize',Markersize,'Linewidth',Linewidth-0.9,'Markerfacecolor','b');
%{
for i=1:Well_Num
    plot3(Receivers(:,1,i),Receivers(:,2,i),Receivers(:,3,i),...
        '-bv','MarkerSize',12,'Linewidth',1,'Markerfacecolor','b');
end
%}
% Plot the shots plane 2015-5-28 %
plot3(Shot(1),Shot(2),Shot(3),'r*','MarkerSize',Markersize,'Linewidth',Linewidth);
set(gca,'zdir','reverse');
% title('b','FontSize',Fontsize);
% axis square
axis off
text(Radius/10,0,Shot(3)+Radius/0.9,'(b)','FontSize',Fontsize);
view(140,30)
% view(3)
% Save the figure 2015-6-23 %
% set(f2,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[100 100 1000 500]);
set(f2,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 12 9]);
print(f2,'-r300','-dtiff','Geometry-3D-3 Well');
%}

%% Set the Model's Sediments boundary
% Set the model parameters 2015-6-7 %
Radius_Coeff=10;
Model_X=[-Radius-Radius/Radius_Coeff,Radius+Radius/Radius_Coeff];
Model_Y=[-Radius-Radius/Radius_Coeff,Radius+Radius/Radius_Coeff];

%
Layer_Num=1;
Deep_Initial=Receivers(1,3,1)-20;
Layer_Int=(Receivers(Rec_Num_1Well,3,1)-Receivers(1,3,1)+80)/Layer_Num;

% Layer color index
Layer_Cor_Idx=Vp.^3/max(Vp.^3);
% Set the model Layer coordinates
Layer_x=[Model_X(1);Model_X(2);Model_X(2);Model_X(1);];
Layer_y=[Model_Y(1);Model_Y(1);Model_Y(2);Model_Y(2);];
Layer_Z=zeros(Layer_Num+1,1);
for i=1:Layer_Num+1
    Layer_Z(i)=Deep_Initial+(i-1)*Layer_Int;
end

% Plot the model Layer and layer face
figure;
set(gcf,'Position',[100 100 800 800])
% set(f2,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 8 7]);
hold on
grid on
EdgeAlpha=0.6;
FaceAlpha=0.5;
for i=1:Layer_Num
    Layer_z=ones(4,1);
    %     Plot the top face
    Layer_z=Layer_z*Layer_Z(i);
    
    Layer_Color=[Layer_Cor_Idx(i),Layer_Cor_Idx(i),Layer_Cor_Idx(i)*1];
    Top1=patch(Layer_x,Layer_y,Layer_z,Layer_Color);
    set(Top1,'EdgeAlpha',EdgeAlpha,'FaceAlpha',FaceAlpha);
    %     Plot the bottom face
    Layer_z=Layer_z*Layer_Z(i+1);
    
    Layer_Color=[i*0.1,i*0.15,i*0.1];
    Bot2=patch(Layer_x,Layer_y,Layer_z,Layer_Color);
    set(Bot2,'EdgeAlpha',EdgeAlpha,'FaceAlpha',FaceAlpha);
end
% Set the lateral face coordinates
Face1_x=[Model_X(1);Model_X(1);Model_X(2);Model_X(2);];
Face1_y=[Model_Y(1);Model_Y(1);Model_Y(1);Model_Y(1);];

Face2_x=[Model_X(2);Model_X(2);Model_X(2);Model_X(2);];
Face2_y=[Model_Y(1);Model_Y(1);Model_Y(2);Model_Y(2);];

Face3_x=[Model_X(1);Model_X(1);Model_X(2);Model_X(2);];
Face3_y=[Model_Y(2);Model_Y(2);Model_Y(2);Model_Y(2);];

Face4_x=[Model_X(1);Model_X(1);Model_X(1);Model_X(1);];
Face4_y=[Model_Y(1);Model_Y(1);Model_Y(2);Model_Y(2);];

% Plot the lateral face coordinates
for i=1:Layer_Num
    Deep(1)=Deep_Initial+(i-1)*Layer_Int;
    Deep(2)=Deep_Initial+i*Layer_Int;
    Face_z=[Deep(2);Deep(1);Deep(1);Deep(2);];
    Layer_Color=[Layer_Cor_Idx(i),Layer_Cor_Idx(i),Layer_Cor_Idx(i)];
    %     Plot the Face 1
    h1=patch(Face1_x,Face1_y,Face_z,Layer_Color);
    set(h1,'EdgeAlpha',EdgeAlpha,'FaceAlpha',FaceAlpha);
    %     Plot the Face 2
    h1=patch(Face2_x,Face2_y,Face_z,Layer_Color);
    set(h1,'EdgeAlpha',EdgeAlpha,'FaceAlpha',FaceAlpha);
    %     Plot the Face 3
    h1=patch(Face3_x,Face3_y,Face_z,Layer_Color);
    set(h1,'EdgeAlpha',EdgeAlpha,'FaceAlpha',FaceAlpha);
    %     Plot the Face 4
    h1=patch(Face4_x,Face4_y,Face_z,Layer_Color);
    set(h1,'EdgeAlpha',EdgeAlpha,'FaceAlpha',FaceAlpha);
end
% Set the figure property
set(gca,'ZDir','reverse','FontSize',14);
axis([Model_X(1) Model_X(2) Model_Y(1) Model_Y(2) Layer_Z(1) Layer_Z(Layer_Num+1)]);
grid on
view(-30.5,8);
xlabel('X');
ylabel('Y');
zlabel('Depth/m');

%}

% Plot the geometry 2015-5-28 %
%

% Plot the wells 2015-6-7 %
for i=1:Well_Num
    plot3(Receivers(:,1,i),Receivers(:,2,i),Receivers(:,3,i),'-bv',...
        'MarkerSize',12,'Linewidth',1,'Markerfacecolor','b');
end
% Plot the shots plane 2015-5-28 %
plot3(Shot(1),Shot(2),Shot(3),'r*','MarkerSize',13,'Linewidth',3);
% Plot the circle of wells 2015-6-9 %
plot3(Circle_Line(:,1),Circle_Line(:,2),Circle_Line(:,3),'.k','Linewidth',2);
% set(gca,'ZDir','reverse','Zlim',[2100,2700])
% view(3)
% view([45,8])
% set(gcf,'position',[400 100 600 1000])
set(gcf,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[400 100 500 800]);
print('-r300','-djpeg','Model');

%% Tile plane function 2015-9-14
% Tile plane function parameters
Plane_Function(1)=0.08;
Plane_Function(2)=0.5;
Plane_Function(3)=-1;
Plane_Function(4)=Shot(3)+Layer_Int/2;
%}
% Calculate the four vertex coordinates of tilt plane
TiltPlane_X=[Model_X(1),Model_X(2),Model_X(2),Model_X(1)];
TiltPlane_Y=[Model_Y(1),Model_Y(1),Model_Y(2),Model_Y(2)];
% Calculate the four vertex coordinates of tilt plane
TiltPlane_Z=Plane_Function(1)*TiltPlane_X+Plane_Function(2)*TiltPlane_Y+Plane_Function(4);
h_TP=patch(TiltPlane_X,TiltPlane_Y,TiltPlane_Z,Layer_Color-0.2);
set(h_TP,'EdgeAlpha',EdgeAlpha,'FaceAlpha',FaceAlpha);


end