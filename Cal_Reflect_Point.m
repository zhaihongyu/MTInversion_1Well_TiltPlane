% According to the shot point, receiver point and reflection plane
% information, calculate the reflection point coordinate 2015-9-14
function [Reflection_Point,Travel_Distance_Ref]=Cal_Reflect_Point(Shot,Receiver,Plane_Fun)
% Calculate the projection point of shot
[Projection_Shot]=Project_on_Plane(Shot,Plane_Fun);
% Calculate the projection point of receiver
[Projection_Rec]=Project_on_Plane(Receiver,Plane_Fun);
% According to the relative position, calculate the reflection point
% coordinate
Distance_Shot_to_Proj=norm(Projection_Shot-Shot);
Distance_Receiver_to_Proj=norm(Projection_Rec-Receiver);
Distance_Proj_Points=norm(Projection_Shot-Projection_Rec);
Direction_Cosin_Proj_Points=[Projection_Rec-Projection_Shot]/Distance_Proj_Points;
% Geometry relationship between shot and receiver
Tan_Reflection_Angle=Distance_Proj_Points/(Distance_Shot_to_Proj+Distance_Receiver_to_Proj);
Dis_ProjShot_ReflectPoint=Distance_Shot_to_Proj*Tan_Reflection_Angle;
% Calculate the reflect point coordinate
Reflection_Point=Projection_Shot+Dis_ProjShot_ReflectPoint.*Direction_Cosin_Proj_Points;
% Calculate the travel distance of the reflection wave
Travel_Distance_Ref=[norm(Reflection_Point-Shot),norm(Receiver-Reflection_Point)];

% Plot the reflection trace
Reflecton_Trace_X=[Shot(1),Reflection_Point(1),Receiver(1)];
Reflecton_Trace_Y=[Shot(2),Reflection_Point(2),Receiver(2)];
Reflecton_Trace_Z=[Shot(3),Reflection_Point(3),Receiver(3)];
plot3(Reflecton_Trace_X,Reflecton_Trace_Y,Reflecton_Trace_Z,'b');
end