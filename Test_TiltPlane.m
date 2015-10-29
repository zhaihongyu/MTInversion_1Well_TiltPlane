
function [Projection]=Project_on_Plane(Point_Coor)
% The function of plane in 3D space
x=-10:10;
y=-10:10;
[X,Y]=meshgrid(x,y);
% z=3x+2y+1
A=3;
B=2;
C=1;
D=4;
Normal_Vector=[A,B,C];

Z=3*X+2*Y+1;
% Plot the plane in 3D space
mesh(X,Y,Z);
t=(A*Point_Coor(1)+B*Point_Coor(2)+C*Point_Coor(3))/(sum(Normal_Vector.^2));
end