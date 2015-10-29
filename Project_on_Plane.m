% According to the point coordinate and Plane function, calculate the
% projection coordinate 2015-9-14
function [Projection]=Project_on_Plane(Point_Coor,Plane_Fun)
% The function of plane in 3D space
x=-10:10;
y=-10:10;
[X,Y]=meshgrid(x,y);

% Suppose the plane function as "z=3x+2y+1"
%{
Plane_Fun(1)=3;
Plane_Fun(2)=2;
Plane_Fun(3)=-1;
Plane_Fun(4)=1;
Z=3*X+2*Y+1;
%}

% Get the normal direction vector
Normal_Vector=[Plane_Fun(1),Plane_Fun(2),Plane_Fun(3)];
% Calculate the projection point coordinate
t=(Plane_Fun(1)*Point_Coor(1)+Plane_Fun(2)*Point_Coor(2)+Plane_Fun(3)*Point_Coor(3)+Plane_Fun(4))/(sum(Normal_Vector.^2));
Projection=[Point_Coor(1)-Plane_Fun(1)*t,Point_Coor(2)-Plane_Fun(2)*t,Point_Coor(3)-Plane_Fun(3)*t];

% PLot the figure
%{
figure
hold on
% Plot the plane in 3D space
mesh(X,Y,Z);
plot3([Point_Coor(1),Projection(1)],[Point_Coor(2),Projection(2)],[Point_Coor(3),Projection(3)],'*-');
plot3([0,A],[0,B],[0,C],'*-r');
%}
end