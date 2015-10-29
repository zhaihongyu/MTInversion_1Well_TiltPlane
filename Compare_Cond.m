clc
close all
clear all
% Import the condition number data
%
load data_2well_15rec_Pi_2.mat
Kernel_Cond_Pi_2=Kernel_Cond;
load data_2well_15rec_Pi_4.mat
Kernel_Cond_Pi_4=Kernel_Cond;
load data_2well_15rec_Pi_6.mat
Kernel_Cond_Pi_6=Kernel_Cond;
load data_2well_15rec_Pi_8.mat
Kernel_Cond_Pi_8=Kernel_Cond;
load data_2well_15rec_Pi_10.mat
Kernel_Cond_Pi_10=Kernel_Cond;
load data_2well_15rec_Pi_12.mat
Kernel_Cond_Pi_12=Kernel_Cond;
load data_2well_15rec_Pi_14.mat
Kernel_Cond_Pi_14=Kernel_Cond;
load data_2well_15rec_Pi_16.mat
Kernel_Cond_Pi_16=Kernel_Cond;
load data_2well_15rec_Pi_18.mat
Kernel_Cond_Pi_18=Kernel_Cond;
load data_2well_15rec_Pi_20.mat
Kernel_Cond_Pi_20=Kernel_Cond;
load data_2well_15rec_Pi_22.mat
Kernel_Cond_Pi_22=Kernel_Cond;
load data_2well_15rec_Pi_24.mat
Kernel_Cond_Pi_24=Kernel_Cond;
load data_2well_15rec_Pi_26.mat
Kernel_Cond_Pi_26=Kernel_Cond;
load data_2well_15rec_Pi_28.mat
Kernel_Cond_Pi_28=Kernel_Cond;
load data_2well_15rec_Pi_30.mat
Kernel_Cond_Pi_30=Kernel_Cond;
% Generate the condition number for different azimuth and solid angle 
KernelCond_C1=[Kernel_Cond_Pi_2(:,1),Kernel_Cond_Pi_4(:,1),...
    Kernel_Cond_Pi_6(:,1),Kernel_Cond_Pi_8(:,1),Kernel_Cond_Pi_10(:,1),...
    Kernel_Cond_Pi_12(:,1),Kernel_Cond_Pi_14(:,1),Kernel_Cond_Pi_16(:,1),...
    Kernel_Cond_Pi_18(:,1),Kernel_Cond_Pi_20(:,1),Kernel_Cond_Pi_22(:,1),...
    Kernel_Cond_Pi_24(:,1),Kernel_Cond_Pi_26(:,1),Kernel_Cond_Pi_28(:,1),...
    Kernel_Cond_Pi_30(:,1)];
KernelCond_C2=[Kernel_Cond_Pi_2(:,2),Kernel_Cond_Pi_4(:,2),...
    Kernel_Cond_Pi_6(:,2),Kernel_Cond_Pi_8(:,2),Kernel_Cond_Pi_10(:,2),...
    Kernel_Cond_Pi_12(:,2),Kernel_Cond_Pi_14(:,2),Kernel_Cond_Pi_16(:,2),...
    Kernel_Cond_Pi_18(:,2),Kernel_Cond_Pi_20(:,2),Kernel_Cond_Pi_22(:,2),...
    Kernel_Cond_Pi_24(:,2),Kernel_Cond_Pi_26(:,2),Kernel_Cond_Pi_28(:,2),...
    Kernel_Cond_Pi_30(:,2)];
%}

% Set the basic parameters 2015-5-12%
[Azimuth_Num,Angle_Num]=size(KernelCond_C1);
% Azimuth_Id=1:Azimuth_Num;
% Angle_Id=1:Angle_Num;
Azimuth_Id=linspace(0,pi,Azimuth_Num)*180/pi;
Angle_Id=Angle_Num:-1:1;
YTick=[Angle_Id(Angle_Num:-3:3),Angle_Id(1)];
Int=2:2:30;
Angle_Tick=pi./Int*180/pi;
YTickLabel=[Angle_Tick(Angle_Num:-3:3),Angle_Tick(1)];

[Azimuth_Id_3D,Angle_Id_3D]=meshgrid(Azimuth_Id,Angle_Id);
% % % Plot the condition number of the kernel matrix 2015-4-29 % % %
FontSize=22;
RotX=-20;
RotY=15;
figure
set(gcf,'Position',[0 0 1150 800])
subplot(2,1,1)
grid on
% contourf(Azimuth_Id_3D,Angle_Id_3D,KernelCond_C1');
surf(Azimuth_Id_3D,Angle_Id_3D,KernelCond_C1');
% mesh(Azimuth_Id_3D,Angle_Id_3D,KernelCond_C1');
colorbar
set(gca,'FontSize',FontSize,'XLim',[Azimuth_Id(1),Azimuth_Id(Azimuth_Num)]...
    ,'YLim',[Angle_Id(Angle_Num),Angle_Id(1)],'YTick',YTick,'YTickLabel',YTickLabel)
% xlabel('Azimuth','FontSize',FontSize,'Rotation',RotY);
% ylabel('Solid Angle','FontSize',FontSize,'Rotation',RotX);
xlabel('Azimuth','FontSize',FontSize);
ylabel('Solid Angle','FontSize',FontSize);
view(2)

subplot(2,1,2)
grid on
surf(Azimuth_Id_3D,Angle_Id_3D,log(KernelCond_C2'));
% surf(Azimuth_Id_3D,Angle_Id_3D,KernelCond_C2');
colorbar
set(gca,'FontSize',FontSize,'XLim',[Azimuth_Id(1),Azimuth_Id(Azimuth_Num)]...
    ,'YLim',[Angle_Id(Angle_Num),Angle_Id(1)],'YTick',YTick,'YTickLabel',YTickLabel)
% ylabel('Azimuth','FontSize',FontSize,'Rotation',RotY);
% xlabel('Solid Angle','FontSize',FontSize,'Rotation',RotX);
xlabel('Azimuth','FontSize',FontSize);
ylabel('Solid Angle','FontSize',FontSize);
view(2)