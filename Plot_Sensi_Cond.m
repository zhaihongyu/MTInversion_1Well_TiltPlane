function Plot_Sensi_Cond(Kernel_Sensi,Kernel_Cond)
% % % Plot the sensitivity and condition number of the kernel matrix 2015-4-28 % % % 
FontSize=22;
[Model_Num,Sensi_Value_Num,WaveType]=size(Kernel_Sensi);
% [Model_Num,WaveType]=size(Kernel_Cond);
Sensi_Value_Id=1:Sensi_Value_Num;
Model_Id=1:Model_Num;
[Model_Id_3D,Sensi_Value_Id_3D]=meshgrid(Sensi_Value_Id,Model_Id);
% Plot the sensitivity of kernel matrix which use P & S wave 2015-4-28 %
f1=figure;
set(f1,'Position',[200 100 800 1800])
subplot(2,1,1)
hold on
grid on
Sensi_Value=Kernel_Sensi(:,:,1);
% plot(Sensi_Value_Id,Sensi_Value);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value)
% mesh(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value)
set(gca,'FontSize',FontSize,'XLim',[1,6])
ylabel('Model Id','FontSize',FontSize,'Rotation',28);
xlabel('Sensitivity Value','FontSize',FontSize,'Rotation',-17);
view(37.5,45);
% 
subplot(2,1,2)
hold on
grid on
Sensi_Value=Kernel_Sensi(:,:,2);
% plot(Sensi_Value_Id,Sensi_Value);
surf(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value)
% mesh(Model_Id_3D,Sensi_Value_Id_3D,Sensi_Value)
set(gca,'FontSize',FontSize,'XLim',[1,6])
ylabel('Model Id','FontSize',FontSize,'Rotation',28);
xlabel('Sensitivity Value','FontSize',FontSize,'Rotation',-17);
view(37.5,45);
% Plot the sensitivity of kernel matrix which use P & S wave 2015-4-28 %
% Plot the condition number of kernel matrix 2015-4-28 %
end