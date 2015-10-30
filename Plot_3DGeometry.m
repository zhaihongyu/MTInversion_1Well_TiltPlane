%% Plot the 3D geometry when using vertical observing well
function Plot_3DGeometry(Radius,Receivers,Shot)
% Basic figure parameters
Fontsize=9;
Markersize=4;
Linewidth=1;
%% Plot the geometry in 3D  viewer
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
end