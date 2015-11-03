%%  2015-10-28 % % %
% In this version, we choose the 1 vertical wells and set the shots
% position on a horizontal plane for several different depths 

%% 2015-9-14 % % %
% Add a tilt plane as the reflect plane for the increasing the MT
% information and improving the inversion result

%% 2015-11-2% % %
% Improve the code and realize to rotating the observing well under
% horizontal sediment interface

%% 
% Model_Num='Return the model number of which the model has different observe azimuth'
% Set the interface type: 
% 1=>'Horizontal interface', 
% 2=>'Tilt interface',
% 3=>'Rotating the vertical well under horiziontal interface'

function [Receivers,Shot,Vp,Vs,Layer_Z,Plane_Function,Model_Num]=Set_Geometry_1Well_V1(Interface_Type)

% Model parameters
Well_Num=1;
Vp=[4400, 4200, 3500,4300];
Vs=[2400, 2200, 1700,2300];

Rec_Depth_Int=15;
Rec_Num_1Well=10;

% The plane function parameters
Plane_Function=zeros(1,4);
%% According to the interface type, set the well and plane parameters
switch Interface_Type
    case 1
        %% Set 1 tile well 2015-10-29 %
        Model_Num=1;
        Receivers=ones(Rec_Num_1Well,3,Model_Num);
        % Set basic parameters
        Well_Radius_Start=3400;
        Well_Azimuth=pi/6;
        Well_Ploar=pi/3;
        Receivers_Radius=zeros(1,Rec_Num_1Well);
        Recs_X_Per=900:-50:900-50*(Rec_Num_1Well);
        Recs_Y_Per=700:-34:700-34*(Rec_Num_1Well);
        for i=1:Well_Num
            for j=1:Rec_Num_1Well
                Well_Radius=Well_Radius_Start+Rec_Depth_Int*j;
                Receivers(j,1,i)=Well_Radius*cos(Well_Azimuth)*sin(Well_Ploar)-j*Recs_X_Per(j);
                Receivers(j,2,i)=Well_Radius*sin(Well_Azimuth)*sin(Well_Ploar)-j*Recs_Y_Per(j);
                Receivers(j,3,i)=Well_Radius*cos(Well_Ploar);
                Receivers_Radius(j)=Well_Radius*sin(Well_Ploar);
            end
        end
        % Shot point coordinate 2015-5-30 %
        Shot=[0 0 Receivers(Rec_Num_1Well/2,3,1)];
        
        % Plot the 3D model
        Radius=max(Receivers_Radius);
        Radius_Coeff=10;
        Model_X=[-Radius-Radius/Radius_Coeff,Radius+Radius/Radius_Coeff];
        Model_Y=[-Radius-Radius/Radius_Coeff,Radius+Radius/Radius_Coeff];
        %Set the horizontal plane parameters
        Plane_Function(1)=0.00;
        Plane_Function(2)=0.0;
        Plane_Function(3)=-1;
        [Plane_Function,Layer_Z]=Plot_Model(Model_X,Model_Y,Receivers,Shot,Plane_Function);
        
    case 2
        %% Set 1 vertical well 2015-8-6 %
        Model_Num=1;
        Receivers=ones(Rec_Num_1Well,3,Model_Num);
        % Set basic parameters
        Radius=150;
        
        Azimuth_Int=pi/(Well_Num*5);
        Azimuth=Azimuth_Int:Azimuth_Int:Azimuth_Int*(Well_Num);
        % Azimuth=pi/8:pi/8:pi/8*Well_Num;
        % Set the receivers' coordinates 2015-6-7 % 
        for i=1:Well_Num
            for j=1:Rec_Num_1Well
                Receivers(j,1,i)=Radius*cos(Azimuth(i));
                Receivers(j,2,i)=Radius*sin(Azimuth(i));
                Receivers(j,3,i)=j*Rec_Depth_Int+2400;
            end
        end
        %Calculate the circle of well 2015-6-9 %
        Circle_Azimuth=0:2*pi/100:2*pi;
        Circle_Azimuth_Num=size(Circle_Azimuth,2);
        Circle_Line=zeros(Circle_Azimuth_Num,3);
        for i=1:Circle_Azimuth_Num
            Circle_Line(i,1)=Radius*cos(Circle_Azimuth(i));
            Circle_Line(i,2)=Radius*sin(Circle_Azimuth(i));
            Circle_Line(i,3)=Receivers(1,3,1);
        end
        % Shot point coordinate 2015-5-30 %
        Shot=[0 0 Receivers(Rec_Num_1Well/2,3,1)];
        
        %  Plot the geometry in 2D  viewer       
        Plot_2DGeometry(Well_Num,Radius,Circle_Line,Receivers,Shot)
        % Plot the 3D geometry when using vertical observing well
        Plot_3DGeometry(Radius,Receivers,Shot)
        Radius_Coeff=10;
        Model_X=[-Radius-Radius/Radius_Coeff,Radius+Radius/Radius_Coeff];
        Model_Y=[-Radius-Radius/Radius_Coeff,Radius+Radius/Radius_Coeff];
        % Plot the 3D model
        % Set the tile plane function parameters
        Plane_Function(1)=0.08;
        Plane_Function(2)=0.5;
        Plane_Function(3)=-1;
        [Plane_Function,Layer_Z]=Plot_Model(Model_X,Model_Y,Receivers,Shot,Plane_Function);
    case 3
        %% Using different rotating angle to define the well
        Rotating_Azimuth=0:pi/10:2*pi-pi/10;
        Model_Num=size(Rotating_Azimuth,2);
        Receivers=ones(Rec_Num_1Well,3,Model_Num);
        %Firstly, define a vertical well
        Radius=150;

        % Set the receivers' coordinates 2015-6-7 % 
        for i=1:Model_Num
            for j=1:Rec_Num_1Well
                Receivers(j,1,i)=Radius*cos(Rotating_Azimuth(i));
                Receivers(j,2,i)=Radius*sin(Rotating_Azimuth(i));
                Receivers(j,3,i)=j*Rec_Depth_Int+2400;
            end
        end
        
        % Shot point coordinate 2015-5-30 %
        Shot=[0 0 Receivers(Rec_Num_1Well/2,3,1)];
        
        % Plot the 3D model
        Radius_Coeff=10;
        Model_X=[-Radius-Radius/Radius_Coeff,Radius+Radius/Radius_Coeff];
        Model_Y=[-Radius-Radius/Radius_Coeff,Radius+Radius/Radius_Coeff];
        %Set the horizontal plane parameters
        Plane_Function(1)=0.00;
        Plane_Function(2)=0.0;
        Plane_Function(3)=-1;
        [Plane_Function,Layer_Z]=Plot_Model(Model_X,Model_Y,Receivers(:,:,1),Shot,Plane_Function);
    otherwise
end






end