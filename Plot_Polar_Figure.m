% 2015-11-4
% According to the azimuth and radius plot the polar figure
function Plot_Polar_Figure(Azimuth,Radius,MT_Name)
% Get the input parameters' propersity
FontSize=9;
Axis_LineWidth=0.1;
LineWidth=1;
MarkerSize=3;
Axis_Color=[0.5 0.5 0.5];
[Object_Num,Azimuth_Num]=size(Radius);

% Radius_Min=min(min());
Radius_Max=max(max(abs(Radius*10)));

%% Plot the figure
figure
set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 15 15])
hold on

%% Calculate the circle axis parameters
CircleAxis_azimuth=0:pi/100:2*pi;
CircleAxis_azimuth_Num=size(CircleAxis_azimuth,2);
CircleAxis_Radius_Int=ceil(Radius_Max)*10/5;
CircleAxis_Radius=CircleAxis_Radius_Int:CircleAxis_Radius_Int:ceil(Radius_Max)*10;
CircleAxis_Radius_Num=size(CircleAxis_Radius,2);
CircleAxis_Coor=zeros(CircleAxis_Radius_Num,CircleAxis_azimuth_Num,2);
for i=1:CircleAxis_Radius_Num
    CircleAxis_Coor(i,:,1)=CircleAxis_Radius(i)*sin(CircleAxis_azimuth);
    CircleAxis_Coor(i,:,2)=CircleAxis_Radius(i)*cos(CircleAxis_azimuth);
end
% Plot the circle axis
for i=1:CircleAxis_Radius_Num
    plot(CircleAxis_Coor(i,:,1),CircleAxis_Coor(i,:,2),'Color',Axis_Color);
end

%% Calculate the radius axis
RadiusAxis_Azimuth=0:pi/6:2*pi;
RadiusAxis_Azimuth_Num=size(RadiusAxis_Azimuth,2);
RadiusAxis_Coor=zeros(2,RadiusAxis_Azimuth_Num,2);
RadiusAxis_Coor(2,:,1)=CircleAxis_Radius(CircleAxis_Radius_Num)*sin(RadiusAxis_Azimuth);
RadiusAxis_Coor(2,:,2)=CircleAxis_Radius(CircleAxis_Radius_Num)*cos(RadiusAxis_Azimuth);
% Plot the radius axis
for i=1:RadiusAxis_Azimuth_Num
    plot(RadiusAxis_Coor(:,i,1),RadiusAxis_Coor(:,i,2),'Color',Axis_Color);
end

%% Calculate the azimuth text position
Azimuth_Text={'0','30','60','90','120','150','180','210','240','270','300','330'};
AzimuthText_Azimuth=0:pi/6:2*pi-pi/6;
Text_Num=size(AzimuthText_Azimuth,2);
AzimuthText_Radius=CircleAxis_Radius(CircleAxis_Radius_Num)*1.1;
AzimuthText_Coor=zeros(2,Text_Num);
AzimuthText_Coor(1,:)=AzimuthText_Radius*sin(AzimuthText_Azimuth);
AzimuthText_Coor(2,:)=AzimuthText_Radius*cos(AzimuthText_Azimuth);
% Plot the azimuth text
for i=1:Text_Num
    t1=text(AzimuthText_Coor(1,i),AzimuthText_Coor(2,i),Azimuth_Text{i});
    set(t1,'HorizontalAlignment','center','FontSize',FontSize);
end

%% Calculate objection position
Object_Line_Position=zeros(Object_Num,Azimuth_Num,2);
for i=1:Object_Num
    Object_Line_Position(i,:,1)=100*Radius(i,:).*sin(Azimuth);
    Object_Line_Position(i,:,2)=100*Radius(i,:).*cos(Azimuth);
end
% Plot the object line
for i=1:Object_Num
    O(i)=plot(Object_Line_Position(i,:,1),Object_Line_Position(i,:,2),'-*',...
        'LineWidth',LineWidth,'MarkerSize',MarkerSize);
end
legend(O,{'ISO','CLVD','DC'})
Title=['Inversion Error - ',MT_Name];
title(Title);
XLim=[-AzimuthText_Radius*1.1,AzimuthText_Radius*1.1];
YLim=XLim;
set(gca,'FontSize',FontSize,'XLim',XLim,'YLim',YLim);
axis equal
axis off
SaveTitle=['Inversion Error - ',MT_Name,' (Polar Figure)'];
print('-r300','-dtiff',SaveTitle)
% End the function
end