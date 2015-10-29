function [Receivers,Shot]=Set_Geometry(Well_Num)
% % % % % % % % % % % 2015-5-28 % % % % % % % % % % %
% In this version, we choose the fixed vertical wells and set the shots
% position on a horizontal plane for several different depths 
% % % % % % % % % % % % % % % % % % % % % % % % % % % 

% Set the receivers' coordinates 2015-6-7 % 
% Radius=50;
Radius=150;
Rec_Depth_Int=10;
Rec_Num_1Well=10;
Receivers=ones(Rec_Num_1Well,3,Well_Num);
Azimuth_Int=pi/(Well_Num*4);
Azimuth=0:Azimuth_Int:Azimuth_Int*(Well_Num-1);
% Azimuth=pi/8:pi/8:pi/8*Well_Num;
for i=1:Well_Num
    for j=1:Rec_Num_1Well
        Receivers(j,1,i)=Radius*cos(Azimuth(i));
        Receivers(j,2,i)=Radius*sin(Azimuth(i));
        Receivers(j,3,i)=j*Rec_Depth_Int+2400;
    end
end
% Shot point coordinate 2015-5-30 %
% There is only one shot coordinate 2015-5-28 %
% 
Shot=[0 0 Receivers(Rec_Num_1Well/2,3,1)];
% Shot=[0 0 2000];
%Calculate the circle of well 2015-6-9 %
Circle_Azimuth=0:2*pi/100:2*pi;
Circle_Azimuth_Num=size(Circle_Azimuth,2);
Circle_Well=zeros(Circle_Azimuth_Num,3);
for i=1:Circle_Azimuth_Num
    Circle_Well(i,1)=Radius*cos(Circle_Azimuth(i));
    Circle_Well(i,2)=Radius*sin(Circle_Azimuth(i));
    Circle_Well(i,3)=Receivers(1,3,1);
end

% Basic figure parameters 2015-7-20 %
Fontsize=9;
Markersize=4;
Linewidth=1;
% Plot the geometry in 2D and 3D viewer

f1=figure;

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
plot(Circle_Well(:,1),Circle_Well(:,2),'.k','Linewidth',Linewidth);
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

% Plot the geometry in and 3D viewer
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

% Coordinates of receivers in the observation Wells 2015-6-8 %
% There are 3 observe wells, and 12 receivers in each Wells. 
% Slant Wells 1 coordinates
%{
Well1_XS=-40;
Well1_XE=40;
Well1_X=Well1_XE-Well1_XS;
well1_Rx=Well1_XS:Well1_X/(Rec_Num_1Well-1):Well1_XE;

Well1_YS=80;
Well1_YE=-10;
Well1_Y=Well1_YE-Well1_YS;
well1_Ry=Well1_YS:Well1_Y/(Rec_Num_1Well-1):Well1_YE;

Well1_ZS=1400;
Well1_ZE=1700;
Well1_Z=Well1_ZE-Well1_ZS;
well1_Rz=Well1_ZS:Well1_Z/(Rec_Num_1Well-1):Well1_ZE;
% Vertical Wells 2 coordinates
well2_Rx=ones(Rec_Num_1Well,1);
well2_Rx=well2_Rx*50;
well2_Ry=ones(Rec_Num_1Well,1);
well2_Ry=well2_Ry*70;

Well2_ZS=2200;
Well2_ZE=2800;
Well2_Z=Well2_ZE-Well2_ZS;
well2_Rz=Well2_ZS:Well2_Z/(Rec_Num_1Well-1):Well2_ZE;

% Vertical Wells 3 coordinates
well3_Rx=ones(Rec_Num_1Well,1);
well3_Rx=well3_Rx*-50;
well3_Ry=ones(Rec_Num_1Well,1);
well3_Ry=well3_Ry*40;

Well3_ZS=2200;
Well3_ZE=2800;
Well3_Z=Well3_ZE-Well3_ZS;
well3_Rz=Well3_ZS:Well3_Z/(Rec_Num_1Well-1):Well3_ZE;
%
Receivers(:,:,1)=[well1_Rx',well1_Ry',well1_Rz'];
% 
Receivers(:,:,2)=[well2_Rx,well2_Ry,well2_Rz'];
% 
Receivers(:,:,3)=[well3_Rx,well3_Ry,well3_Rz'];
Deep_Initial=1200;
Layer_Int=1700;
%}
% Set the receivers' coordinates 2015-5-28 % 
%{
Rec_Num=30;
Wells_XY=[-200,0;200,0];
Receivers=ones(Rec_Num,3,Well_Num);
Rec_Depth_Int=10;
Receivers(:,1,1)=Receivers(:,1,1)*Wells_XY(1,1);
Receivers(:,2,1)=Receivers(:,2,1)*Wells_XY(1,2);
Receivers(:,1,2)=Receivers(:,1,2)*Wells_XY(2,1);
Receivers(:,2,2)=Receivers(:,2,2)*Wells_XY(2,2);
for i=1:Rec_Num
    Receivers(i,3,:)=i*Rec_Depth_Int+2400;
end
Receivers_Depth=Receivers(Rec_Num,3,1)-Receivers(1,3,1);
%}

% Shot point coordinates 2015-5-28 %
% According to the grid of different shot plane, identify the position of every shot
% 2015-5-28 %
%{ 
Shots_X_Int=100;
Shots_Y_Int=100;
Shots_x=Model_X(1):Shots_X_Int:Model_X(2);
Shots_y=Model_Y(1):Shots_Y_Int:Model_Y(2);
[Shots_X,Shots_Y]=meshgrid(Shots_x,Shots_y);
[Shots_X_Num,Shots_Y_Num]=size(Shots_X);
Shots_Depth=[Receivers(1,3,1)-Receivers_Depth/4,Receivers(1,3,1),...
    Receivers(1,3,1)+Receivers_Depth/4,Receivers(1,3,1)+Receivers_Depth/2];
Shots_Z=ones(Shots_X_Num,Shots_Y_Num)*Shots_Depth(Model_Id);
Shots=zeros(Shots_X_Num,Shots_Y_Num,3);
Shots(:,:,1)=Shots_X;
Shots(:,:,2)=Shots_Y;
Shots(:,:,3)=Shots_Z;
%}

% Plot the geometry 2015-5-28 %
%{
figure
set(gcf,'Position',[100 100 400 800])
hold on
grid on
% Plot the wells 2015-5-28 %
plot3(Receivers(:,1,1),Receivers(:,2,1),Receivers(:,3,1),'bv','MarkerSize',14,'Linewidth',2);
plot3(Receivers(:,1,2),Receivers(:,2,2),Receivers(:,3,2),'bv','MarkerSize',14,'Linewidth',2);
% Plot the shots plane 2015-5-28 %
m1=mesh(Shots_X,Shots_Y,Shots_Z);
set(m1,'EdgeAlpha',0.6,'FaceAlpha',0.3)
set(gca,'ZDir','reverse','Zlim',[2100,2700])
% view(3)
view([45,8])
%}


%}

% Plot the model surface 2015-6-7 %
%
% Set the model parameters 2015-6-7 %
Model_X=[-100,100];
Model_Y=[-100,100];
Layer_Num=1;
Deep_Initial=Receivers(1,3,1)-40;
Layer_Int=Receivers(Rec_Num_1Well,3,1)-Receivers(1,3,1)+80;

% Plot the Layer and layer face
Layer_x=[Model_X(1);Model_X(2);Model_X(2);Model_X(1);];
Layer_y=[Model_Y(1);Model_Y(1);Model_Y(2);Model_Y(2);];
Layer_Z=zeros(Layer_Num+1,1);

Layer_Color=[0.5,1,0.5];

f3=figure;
set(gcf,'Position',[100 100 600 1000])
% set(f2,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 8 7]);
hold on
grid on
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
plot3(Circle_Well(:,1),Circle_Well(:,2),Circle_Well(:,3),'-k','Linewidth',2);
% set(gca,'ZDir','reverse','Zlim',[2100,2700])
% view(3)
% view([45,8])
% set(gcf,'position',[400 100 600 1000])
set(gcf,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[400 100 500 800]);
print('-r300','-djpeg','Model');

end