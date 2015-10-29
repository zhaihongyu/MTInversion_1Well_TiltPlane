function [Wells,Shot,Radius]=Set_Geometry1(Model_Id)
% In this version, we choose the circle geometry around the event
% Shot point coordinates
Shot=[0,0,2000];

Radius_Int=5;
Radius=1+Radius_Int*Model_Id;
Well_Num=8;
% Rec_Num_In1Well=1;
Azimuth=2*pi/Well_Num;
% Wells=zeros(Well_Num,Rec_Num_1Well,3);
Wells=zeros(Well_Num,3);

% Accoding the azimuth, calculate the receivers' coordinate
for i=1:Well_Num
    Wells(i,1)=Radius*cos(i*Azimuth);
    Wells(i,2)=Radius*sin(i*Azimuth);
    Wells(i,3)=Shot(3);
end
% Plot the geometry
%{
figure
hold on
grid on
plot3(Shot(1),Shot(2),Shot(3),'r*','MarkerSize',14,'Linewidth',2);
plot3(Wells(:,1),Wells(:,2),Wells(:,3),'bv-.','MarkerSize',10,'Linewidth',2);
set(gca,'ZDir','reverse')
% view(3)

Deep_Initial=3000;
Layer_Int=-2000;
Layer_Num=1;
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
end