%% Plot the 2D geometry when using vertical observing well
function Plot_2DGeometry(Well_Num,Radius,Circle_Line,Receivers,Shot)
% Basic figure parameters
Fontsize=9;
Markersize=4;
Linewidth=1;

%% Plot the geometry in 2D  viewer
f1=figure;
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

end