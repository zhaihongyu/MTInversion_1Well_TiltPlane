%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% According to the ray tracing method, identify the  attenuation time in
% every layer (Version 3.0 - Succuss)
%
Layer_Num_Max=max(Layer_Num);
Layers_R=zeros(Rec_Num,Layer_Num_Max);
ELayerTime_SR=zeros(Rec_Num,Layer_Num_Max,2);
ShotRec_Vector=zeros(3,Rec_Num);

for i=1:Rec_Num
    %     Calculate the sphere coordinate
    ShotRec_Vector(:,i)=Wells(:,i)-Shot;
    R_ShotRec=Length(i);
    Rxy_ShotRec=sqrt(ShotRec_Vector(1,i)^2+ShotRec_Vector(2,i)^2);
    Theta=acos(ShotRec_Vector(3,i)/R_ShotRec);
    if ShotRec_Vector(2,i)>0
        Phi=acos(ShotRec_Vector(1,i)/Rxy_ShotRec);
    else
        Phi=acos(ShotRec_Vector(1,i)/Rxy_ShotRec)+pi;
    end
    %     According the sphere coordinate, using ray tracing method
    switch Layer_Num(i)
        case 1
            %%%%%%%%%%%%%%%%%%
            %         When the layer number is 1
            ELayerTime_SR(i,1,1)=Length(i)/Vp;
            ELayerTime_SR(i,1,2)=Length(i)/Vs;
        otherwise
            %%%%%%%%%%%%%%%%%%%%%%
            %         When the layer number >= 2
            Layers_XYZ=zeros(3,Layer_Num(i)+1);
            Layers_XYZ(:,1)=Shot;
            Layers_XYZ(:,Layer_Num(i)+1)=Wells(:,i);
            
            ShotRec_Layers=Layers_ShotRec{i};
            Layers_XYZ(3,2:Layer_Num(i))=ShotRec_Layers;
            Delta_Theta=Theta/3;
            while 1
                %                 %            Firstly, calculate the fisrt layer
                SingleLayer_Z1=ShotRec_Layers(1)-Shot(3);
                SingleLayer_R1=abs(SingleLayer_Z1/cos(Theta+Delta_Theta));
                SingleLayer_X1=SingleLayer_R1*sin(Theta+Delta_Theta)*cos(Phi);
                SingleLayer_Y1=SingleLayer_R1*sin(Theta+Delta_Theta)*sin(Phi);
                Layers_XYZ(:,2)=[SingleLayer_X1+Shot(1);SingleLayer_Y1+Shot(2);ShotRec_Layers(1)];
                %                 Calculate the transmission angle
                if Theta>pi/2
                    Theta2=asin(sin(Theta)*V(1)/V(2));
                    Theta_Sphere=pi-Theta2;
                else
                    %                     Also need to correct%
                    Theta2=asin(sin(Theta)*V(2)/V(1));
                    Theta_Sphere=Theta2;
                end
                
                %                 %             Then, calculate the intermediate layers
                for j=2:Layer_Num(i)
                    SingleLayer_ZInter=Layers_XYZ(3,j+1)-Layers_XYZ(3,j);
                    SingleLayer_RInter=abs(SingleLayer_ZInter/cos(Theta_Sphere));
                    SingleLayer_XInter=SingleLayer_RInter*sin(Theta_Sphere)*cos(Phi);
                    SingleLayer_YInter=SingleLayer_RInter*sin(Theta_Sphere)*sin(Phi);
                    Layers_XYZ(:,j+1)=[SingleLayer_XInter+Layers_XYZ(1,j);SingleLayer_YInter+Layers_XYZ(2,j);Layers_XYZ(3,j+1)];
                    %                 Calculate the transmission angle
                    if Theta>pi/2
                        Theta2=asin(sin(Theta)*V(1)/V(2));
                        Theta_Sphere=pi-Theta2;
                    else
                        %                         Also need to correct%
                        Theta2=asin(sin(Theta)*V(2)/V(1));
                        Theta_Sphere=Theta2;
                    end
                end
                %                 According the result, adjust the Theta
                Error_Vector=Layers_XYZ(:,Layer_Num(i)+1)-Wells(:,i);
                if Error_Vector(1)*ShotRec_Vector(1,i)>0
                    Delta_Theta=-Delta_Theta/2;
                else
                    Delta_Theta=Delta_Theta/2;
                end
                %                 According the distance between the receiver and
                %                 calculating result, idenfy the loop whether need breaking
                Error_Distance=norm(Error_Vector);
                if Error_Distance<=10^(-4)
                    %                     Calculate the traveling time
                    for j=1:Layer_Num(i)
                        SingleLayer_Vector=Layers_XYZ(:,j+1)-Layers_XYZ(:,j);
                        Layers_R(i,j)=norm(SingleLayer_Vector);
                        ELayerTime_SR(i,j,1)=Layers_R(i,j)/Vp;
                        ELayerTime_SR(i,j,2)=Layers_R(i,j)/Vs;
                    end
                    break;
                end
            end
    end
end
%}