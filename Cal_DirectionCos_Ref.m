% Using the shot and reflection point to calculate the direction cosine for
% the reflect wave. 2015-9-15
% Because their is only 1 layer, the direction cosine for the reflection
% P&S wave are same. 
function [DirectionCos_RefP,DirectionCos_RefS]=Cal_DirectionCos_Ref(Shot,Reflection_Points)
% Set the basic parameters
Rec_Num=size(Reflection_Points,1);
DirectionCos_RefP=zeros(3,Rec_Num);
DirectionCos_RefS=zeros(3,Rec_Num);
% According to the coordinates of shot and reflection, calculate the
% direction cosine
for i=1:Rec_Num
    Direction_Vector=Reflection_Points(i)-Shot;
    DirectionCos_RefP(:,i)=Direction_Vector'/norm(Direction_Vector);
    DirectionCos_RefS(:,i)=DirectionCos_RefP(:,i);
end
end