%% Plot the 3D model
function [Layer_Z]=Plot_Model(Model_X,Model_Y,Receivers,Shot,Plane_Function)
%% Set the Model's Sediments boundary
% Set the model parameters 2015-6-7 %
[Rec_Num_1Well,Com,Well_Num]=size(Receivers);
%
Layer_Num=1;
Deep_Initial=Receivers(1,3,1)-20;
Layer_Int=(Receivers(Rec_Num_1Well,3,1)-Receivers(1,3,1)+80)/Layer_Num;


% Set the model Layer coordinates
Layer_x=[Model_X(1);Model_X(2);Model_X(2);Model_X(1);];
Layer_y=[Model_Y(1);Model_Y(1);Model_Y(2);Model_Y(2);];
Layer_Z=zeros(Layer_Num+1,1);
for i=1:Layer_Num+1
    Layer_Z(i)=Deep_Initial+(i-1)*Layer_Int;
end

% Layer color index
Layer_Cor_Idx=Layer_Z.^3/max(Layer_Z.^3);
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
% plot3(Circle_Line(:,1),Circle_Line(:,2),Circle_Line(:,3),'.k','Linewidth',2);

% set(gca,'ZDir','reverse','Zlim',[2100,2700])
% view(3)
% view([45,8])
% set(gcf,'position',[400 100 600 1000])
set(gcf,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[400 100 500 800]);
print('-r300','-djpeg','Model');

%% Tile plane function 2015-9-14
%  plane function parameters
Plane_Function(4)=Shot(3)+Layer_Int/2;
% Calculate the four vertex coordinates of tilt plane
TiltPlane_X=[Model_X(1),Model_X(2),Model_X(2),Model_X(1)];
TiltPlane_Y=[Model_Y(1),Model_Y(1),Model_Y(2),Model_Y(2)];
% Calculate the four vertex coordinates of tilt plane
TiltPlane_Z=Plane_Function(1)*TiltPlane_X+Plane_Function(2)*TiltPlane_Y+Plane_Function(4);
h_TP=patch(TiltPlane_X,TiltPlane_Y,TiltPlane_Z,Layer_Color-0.2);
set(h_TP,'EdgeAlpha',EdgeAlpha,'FaceAlpha',FaceAlpha);
end