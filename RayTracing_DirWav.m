%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% According to the ray tracing method, identify the  attenuation time in
% every layer (Version 3.0 - Succuss)
function [TraveTime_DirWav,Coor_RayTrace]=...
    RayTracing_DirWav(Receivers,Shot,V_SRs,LayerNum_EverySR,Layers_ZCoor_EverySR)
% Identify the basic parameters
Rec_Num_All=size(Receivers,1);
Length_Layers_EverySR=cell(1,Rec_Num_All);

ShotRec_Vector=zeros(Rec_Num_All,3);

TraveTime_DirWav=cell(1,Rec_Num_All);
Coor_RayTrace=cell(1,Rec_Num_All);
Length_EverySR=zeros(1,Rec_Num_All);
for i=1:Rec_Num_All
    V=V_SRs{i};
    ELayerLenth_SR=zeros(1,LayerNum_EverySR(i));
    ELayerTime_SR=zeros(1,LayerNum_EverySR(i));
    %     Calculate the sphere coordinate
    ShotRec_Vector(i,:)=Receivers(i,:)-Shot;
    Length_EverySR(i)=norm(ShotRec_Vector(i,:));
    Rxy_ShotRec=sqrt(ShotRec_Vector(i,1)^2+ShotRec_Vector(i,2)^2);
    Theta=acos(ShotRec_Vector(i,3)/Length_EverySR(i));
    if ShotRec_Vector(i,2)>0
        Phi=acos(ShotRec_Vector(i,1)/Rxy_ShotRec);
    else
        Phi=acos(ShotRec_Vector(i,1)/Rxy_ShotRec)+pi;
    end
    %     According the sphere coordinate, using ray tracing method
    switch LayerNum_EverySR(i)
        case 1
            %%%%%%%%%%%%%%%%%%
            %             When the layer number is 1
            Length_Layers_EverySR{i}=Length_EverySR(i);
            ELayerTime_SR(1)=Length_EverySR(i)/V;
            %Record the travel time to every receiver
            TraveTime_DirWav{i}=ELayerTime_SR;
            %Record the coordinates form  shot to receiver
            Coor_RayTrace{i}=[Shot;Receivers(i,:);];
        otherwise
            %%%%%%%%%%%%%%%%%%%%%%
            %         When the layer number >= 2
            % Transmission point coordinates on every sediment interface='TransPoint_XYZ_SI'
            TransPoint_XYZ_SI_XYZ=zeros(LayerNum_EverySR(i)+1,3);
            TransPoint_XYZ_SI_XYZ(1,:)=Shot;
            TransPoint_XYZ_SI_XYZ(LayerNum_EverySR(i)+1,:)=Receivers(i,:);
            
            ShotRec_Layers=Layers_ZCoor_EverySR{i};
            TransPoint_XYZ_SI_XYZ(2:LayerNum_EverySR(i),3)=ShotRec_Layers;
            %According the Theta, identify the Delta Theta
            if Theta>pi/2
                Delta_Theta=(pi-Theta)/5;
                Error_Idx=1;
            else
                Delta_Theta=-(pi/2-Theta)/5;
                Error_Idx=1;
            end
            
            while 1
                Theta=Theta+Delta_Theta;
                % Firstly, calculate the coordinate of fisrt transmission piont
                SingleLayer_Z2=TransPoint_XYZ_SI_XYZ(2,3)-Shot(3);
                SingleLayer_R2=abs(SingleLayer_Z2/cos(Theta));
                SingleLayer_X2=SingleLayer_R2*sin(Theta)*cos(Phi);
                SingleLayer_Y2=SingleLayer_R2*sin(Theta)*sin(Phi);
                TransPoint_XYZ_SI_XYZ(2,:)=[SingleLayer_X2+Shot(1);SingleLayer_Y2+Shot(2);TransPoint_XYZ_SI_XYZ(2,3)];
                %                 Calculate the transmission angle
                if Theta>pi/2                
                    Theta2=asin(sin(pi-Theta)*V(2)/V(1));
                    Theta_Sphere=pi-Theta2;
                else
                    Theta2=asin(sin(Theta)*V(2)/V(1));
                    Theta_Sphere=Theta2;
                end
                % Then calculate the coordinate of next point
                SingleLayer_Z3=TransPoint_XYZ_SI_XYZ(3,3)-TransPoint_XYZ_SI_XYZ(2,3);
                SingleLayer_R3=abs(SingleLayer_Z3/cos(Theta_Sphere));
                SingleLayer_X3=SingleLayer_R3*sin(Theta_Sphere)*cos(Phi);
                SingleLayer_Y3=SingleLayer_R3*sin(Theta_Sphere)*sin(Phi);
                TransPoint_XYZ_SI_XYZ(3,:)=[SingleLayer_X3+TransPoint_XYZ_SI_XYZ(2,1);SingleLayer_Y3+TransPoint_XYZ_SI_XYZ(2,2);TransPoint_XYZ_SI_XYZ(3,3)];
                
                % Secondly, calculate the transmission angle of rest  transmission points
                for j=3:LayerNum_EverySR(i)
                    
                    % Calculate the transmission angle                
                    if Theta>pi/2
                        Theta2=asin(sin(pi-Theta)*V(j)/V(j-1));
                        Theta_Sphere=pi-Theta2;
                    else
                        Theta2=asin(sin(Theta)*V(j)/V(j-1));
                        Theta_Sphere=Theta2;
                    end
                    % Then, calculate the coordinates of rest  transmission points
                    SingleLayer_ZInter=TransPoint_XYZ_SI_XYZ(j+1,3)-TransPoint_XYZ_SI_XYZ(j,3);
                    SingleLayer_RInter=abs(SingleLayer_ZInter/cos(Theta_Sphere));
                    SingleLayer_XInter=SingleLayer_RInter*sin(Theta_Sphere)*cos(Phi);
                    SingleLayer_YInter=SingleLayer_RInter*sin(Theta_Sphere)*sin(Phi);
                    TransPoint_XYZ_SI_XYZ(j+1,:)=[SingleLayer_XInter+TransPoint_XYZ_SI_XYZ(j,1);SingleLayer_YInter+TransPoint_XYZ_SI_XYZ(j,2);TransPoint_XYZ_SI_XYZ(j+1,3)];
                end
                % According the result, adjust the Theta
                ShotToErrorRec_Vector=TransPoint_XYZ_SI_XYZ(LayerNum_EverySR(i)+1,:)-Shot;
                Error_Radius=norm(ShotToErrorRec_Vector(1:2))-norm(ShotRec_Vector(i,1:2));
                if Error_Radius*Error_Idx<0
                    Error_Idx=-Error_Idx;
                    Delta_Theta=-Delta_Theta/2;
                end
                %                 According the distance between the receiver and
                %                 calculating result, idenfy the loop whether need breaking
                
                if abs(Error_Radius)<=10^(-4)
                    %Record the coordinates form  shot to receiver
                    Coor_RayTrace{i}=TransPoint_XYZ_SI_XYZ;
                    % Calculate the traveling time for every layer of each
                    % shot-receiver pattern
                    for j=1:LayerNum_EverySR(i)
                        SingleLayer_Vector=TransPoint_XYZ_SI_XYZ(j+1,:)-TransPoint_XYZ_SI_XYZ(j,:);
                        ELayerLenth_SR(j)=norm(SingleLayer_Vector);
                        ELayerTime_SR(j)=ELayerLenth_SR(j)/V(j);
                    end
                    Length_Layers_EverySR{i}=ELayerLenth_SR;
                    TraveTime_DirWav{i}=ELayerTime_SR;
                    break;
                end
            end
    end
end
% End the function
end

