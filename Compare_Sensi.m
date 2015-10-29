clc
close all
clear all

load data_2well_15rec_Pi_2.mat
Sensi_Kernel_Pi_2=Sensi_Kernel;
Kernel_Cond_Pi_2=Kernel_Cond;
load data_2well_15rec_Pi_4.mat
Sensi_Kernel_Pi_4=Sensi_Kernel;
Kernel_Cond_Pi_4=Kernel_Cond;
load data_2well_15rec_Pi_6.mat
Sensi_Kernel_Pi_6=Sensi_Kernel;
Kernel_Cond_Pi_6=Kernel_Cond;
load data_2well_15rec_Pi_8.mat
Sensi_Kernel_Pi_8=Sensi_Kernel;
Kernel_Cond_Pi_8=Kernel_Cond;
load data_2well_15rec_Pi_10.mat
Sensi_Kernel_Pi_10=Sensi_Kernel;
Kernel_Cond_Pi_10=Kernel_Cond;
load data_2well_15rec_Pi_12.mat
Sensi_Kernel_Pi_12=Sensi_Kernel;
Kernel_Cond_Pi_12=Kernel_Cond;
load data_2well_15rec_Pi_14.mat
Sensi_Kernel_Pi_14=Sensi_Kernel;
Kernel_Cond_Pi_14=Kernel_Cond;
load data_2well_15rec_Pi_16.mat
Sensi_Kernel_Pi_16=Sensi_Kernel;
Kernel_Cond_Pi_16=Kernel_Cond;
% % % Plot the sensitivity of the kernel matrix 2015-4-28 % % % 
Sensi_Kernel_S1=[Sensi_Kernel_Pi_2(:,1,1),Sensi_Kernel_Pi_4(:,1,1),...
    Sensi_Kernel_Pi_6(:,1,1),Sensi_Kernel_Pi_8(:,1,1),Sensi_Kernel_Pi_10(:,1,1)...
    Sensi_Kernel_Pi_12(:,1,1),Sensi_Kernel_Pi_14(:,1,1),Sensi_Kernel_Pi_16(:,1,1)];
Sensi_Kernel_S2=[Sensi_Kernel_Pi_2(:,2,1),Sensi_Kernel_Pi_4(:,2,1),...
    Sensi_Kernel_Pi_6(:,2,1),Sensi_Kernel_Pi_8(:,2,1),Sensi_Kernel_Pi_10(:,2,1)...
    Sensi_Kernel_Pi_12(:,2,1),Sensi_Kernel_Pi_14(:,2,1),Sensi_Kernel_Pi_16(:,2,1)];
Sensi_Kernel_S3=[Sensi_Kernel_Pi_2(:,3,1),Sensi_Kernel_Pi_4(:,3,1),...
    Sensi_Kernel_Pi_6(:,3,1),Sensi_Kernel_Pi_8(:,3,1),Sensi_Kernel_Pi_10(:,3,1)...
    Sensi_Kernel_Pi_12(:,3,1),Sensi_Kernel_Pi_14(:,3,1),Sensi_Kernel_Pi_16(:,3,1)];
Sensi_Kernel_S4=[Sensi_Kernel_Pi_2(:,4,1),Sensi_Kernel_Pi_4(:,4,1),...
    Sensi_Kernel_Pi_6(:,4,1),Sensi_Kernel_Pi_8(:,4,1),Sensi_Kernel_Pi_10(:,4,1)...
   Sensi_Kernel_Pi_12(:,4,1),Sensi_Kernel_Pi_14(:,4,1),Sensi_Kernel_Pi_16(:,4,1) ];
Sensi_Kernel_S5=[Sensi_Kernel_Pi_2(:,5,1),Sensi_Kernel_Pi_4(:,5,1),...
    Sensi_Kernel_Pi_6(:,5,1),Sensi_Kernel_Pi_8(:,5,1),Sensi_Kernel_Pi_10(:,5,1)...
    Sensi_Kernel_Pi_12(:,5,1),Sensi_Kernel_Pi_14(:,5,1),Sensi_Kernel_Pi_16(:,5,1)];
Sensi_Kernel_S6=[Sensi_Kernel_Pi_2(:,6,1),Sensi_Kernel_Pi_4(:,6,1),...
    Sensi_Kernel_Pi_6(:,6,1),Sensi_Kernel_Pi_8(:,6,1),Sensi_Kernel_Pi_10(:,6,1)...
    Sensi_Kernel_Pi_12(:,6,1),Sensi_Kernel_Pi_14(:,6,1),Sensi_Kernel_Pi_16(:,6,1)];
% % % Plot the every sensitivity  of the kernel matrix respectively 2015-5-12 % % % 
FontSize=20;
[Model_Num,Single_Sensi_Num]=size(Sensi_Kernel_S1);
Model_Id=1:Model_Num;
Single_Sensi_Id=1:Single_Sensi_Num;
[Model_Id_3D,Single_Sensi_Id_3D]=meshgrid(Model_Id,Single_Sensi_Id);

figure
set(gcf,'Position',[0 0 1800 700])
subplot(3,2,1)
% plot3(Model_Id_3D,Single_Sensi_Id_3D,Sensi_Kernel_S1,'*');
surf(Model_Id_3D,Single_Sensi_Id_3D,Sensi_Kernel_S1');
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar;
caxis([4.1E11,5E12]);

view(2)
subplot(3,2,2)
surf(Model_Id_3D,Single_Sensi_Id_3D,Sensi_Kernel_S2');
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar
caxis([4.1E11,5E12]);
view(2)
subplot(3,2,3)
surf(Model_Id_3D,Single_Sensi_Id_3D,Sensi_Kernel_S3');
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar
caxis([4.1E11,5E12]);
view(2)
subplot(3,2,4)
surf(Model_Id_3D,Single_Sensi_Id_3D,Sensi_Kernel_S4');
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar
caxis([4.1E11,5E12]);
view(2)
subplot(3,2,5)
surf(Model_Id_3D,Single_Sensi_Id_3D,Sensi_Kernel_S5');
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar
caxis([4.1E11,5E12]);
view(2)
subplot(3,2,6)
surf(Model_Id_3D,Single_Sensi_Id_3D,Sensi_Kernel_S6');
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar
caxis([4.1E11,5E12]);
view(2)
% Plot_Sensi_Cond(Sensi_Kernel,Kernel_Cond);
% % % Plot the sensitivity and condition number of the kernel matrix 2015-4-28 % % % 

[Model_Num,Sensi_Value_Num,WaveType]=size(Sensi_Kernel);
% [Model_Num,WaveType]=size(Kernel_Cond);
Sensi_Value_Id=1:Sensi_Value_Num;

[Model_Id_3D,Sensi_Value_Id_3D]=meshgrid(Model_Id,Sensi_Value_Id);
RotY=15;
RotX=-9;

% Plot the sensitivity of kernel matrix which use P & S wave 2015-4-28 %
f1=figure;
set(f1,'Position',[0 0 800 1000])
subplot(4,1,1)
hold on
grid on
Sensi_Value=Sensi_Kernel_Pi_2(:,:,1);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value')
% mesh(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value)
% set(gca,'FontSize',FontSize,'XLim',[1,6])
% ylabel('Model Id','FontSize',FontSize,'Rotation',RotY);
% xlabel('Sensitivity Value','FontSize',FontSize,'Rotation',RotX);
set(gca,'FontSize',FontSize,'YLim',[1,Sensi_Value_Num])
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar
view(2)
% view(37.5,30);

subplot(4,1,2)
hold on
grid on
Sensi_Value=Sensi_Kernel_Pi_4(:,:,1);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value')
% mesh(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value)
% set(gca,'FontSize',FontSize,'XLim',[1,6])
% ylabel('Model Id','FontSize',FontSize,'Rotation',RotY);
% xlabel('Sensitivity Value','FontSize',FontSize,'Rotation',RotX);
set(gca,'FontSize',FontSize,'YLim',[1,Sensi_Value_Num])
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar
view(2)
% view(37.5,30);

subplot(4,1,3)
hold on
grid on
Sensi_Value=Sensi_Kernel_Pi_6(:,:,1);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value')
% mesh(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value)
% set(gca,'FontSize',FontSize,'XLim',[1,6])
% ylabel('Model Id','FontSize',FontSize,'Rotation',RotY);
% xlabel('Sensitivity Value','FontSize',FontSize,'Rotation',RotX);
set(gca,'FontSize',FontSize,'YLim',[1,Sensi_Value_Num])
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar
view(2)
% view(37.5,30);

subplot(4,1,4)
hold on
grid on
Sensi_Value=Sensi_Kernel_Pi_8(:,:,1);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value')
% mesh(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value)
% set(gca,'FontSize',FontSize,'XLim',[1,6])
% ylabel('Model Id','FontSize',FontSize,'Rotation',RotY);
% xlabel('Sensitivity Value','FontSize',FontSize,'Rotation',RotX);
set(gca,'FontSize',FontSize,'YLim',[1,Sensi_Value_Num])
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar
view(2)
% view(37.5,30);

% Plot the sensitivity of kernel matrix which use P wave 2015-4-28 %
f1=figure;
set(f1,'Position',[0 0 800 1000])
subplot(4,1,1)
hold on
grid on
Sensi_Value=Sensi_Kernel_Pi_2(:,:,2);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value')
% mesh(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value)
% set(gca,'FontSize',FontSize,'XLim',[1,6])
% ylabel('Model Id','FontSize',FontSize,'Rotation',RotY);
% xlabel('Sensitivity Value','FontSize',FontSize,'Rotation',RotX);
set(gca,'FontSize',FontSize,'YLim',[1,Sensi_Value_Num])
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar
view(2)
% view(37.5,30);

subplot(4,1,2)
hold on
grid on
Sensi_Value=Sensi_Kernel_Pi_4(:,:,2);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value')
% mesh(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value)
% set(gca,'FontSize',FontSize,'XLim',[1,6])
% ylabel('Model Id','FontSize',FontSize,'Rotation',RotY);
% xlabel('Sensitivity Value','FontSize',FontSize,'Rotation',RotX);
set(gca,'FontSize',FontSize,'YLim',[1,Sensi_Value_Num])
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar
view(2)
% view(37.5,30);

subplot(4,1,3)
hold on
grid on
Sensi_Value=Sensi_Kernel_Pi_6(:,:,2);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value')
% mesh(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value)
% set(gca,'FontSize',FontSize,'XLim',[1,6])
% ylabel('Model Id','FontSize',FontSize,'Rotation',RotY);
% xlabel('Sensitivity Value','FontSize',FontSize,'Rotation',RotX);
set(gca,'FontSize',FontSize,'YLim',[1,Sensi_Value_Num])
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar
view(2)
% view(37.5,30);

subplot(4,1,4)
hold on
grid on
Sensi_Value=Sensi_Kernel_Pi_8(:,:,2);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value')
% mesh(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value)
% set(gca,'FontSize',FontSize,'XLim',[1,6])
% ylabel('Model Id','FontSize',FontSize,'Rotation',RotY);
% xlabel('Sensitivity Value','FontSize',FontSize,'Rotation',RotX);
set(gca,'FontSize',FontSize,'YLim',[1,Sensi_Value_Num])
ylabel('Solid Angle','FontSize',FontSize);
xlabel('Azimuth','FontSize',FontSize);
colorbar
view(2)
% view(37.5,30);

% 
% Plot the all the sensitivity of kernel matrix which use P & S wave 2015-4-28 %
%{
f2=figure;
set(f2,'Position',[200 100 800 1000])
% subplot(2,1,2)
hold on
grid on
Sensi_Value=Sensi_Kernel_Pi_2(:,:,2);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value')
Sensi_Value=Sensi_Kernel_Pi_4(:,:,2);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value')
Sensi_Value=Sensi_Kernel_Pi_6(:,:,2);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value')
Sensi_Value=Sensi_Kernel_Pi_8(:,:,2);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value')
% mesh(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value)
% set(gca,'FontSize',FontSize,'XLim',[1,6])
ylabel('Model Id','FontSize',FontSize,'Rotation',RotY);
xlabel('Sensitivity Value','FontSize',FontSize,'Rotation',RotX);
view(2)
% view(37.5,30);
%}
% Plot the sensitivity of kernel matrix which use P & S wave 2015-4-RotY %
% Plot the condition number of kernel matrix 2015-4-RotY %