function Plot_AllTksError(T_Orig_All,k_Orig_All,Abso_T_Error_PS,Abso_k_Error_PS)
% Plot the T-k's error for all kinds of moment tensors
f1=figure();
set(f1,'Position',[0 0 600 1200])
Fontsize=18;
% Model 1
subplot(3,2,1)
hold on
grid on
axis([-1 1 -1 1])
axis square
plot(T_Orig_All(:,1),Abso_T_Error_PS(:,1),'.')
xlabel('T','Fontsize',Fontsize);
ylabel('T Error','Fontsize',Fontsize)
set(gca,'Fontsize',Fontsize)
subplot(3,2,2)
hold on
grid on
axis([-1 1 -1 1])
axis square
plot(k_Orig_All(:,1),Abso_k_Error_PS(:,1),'.')
xlabel('k','Fontsize',Fontsize);
ylabel('k Error','Fontsize',Fontsize)
set(gca,'Fontsize',Fontsize)
% Model 3
subplot(3,2,3)
hold on
grid on
axis([-1 1 -1 1])
axis square
plot(T_Orig_All(:,3),Abso_T_Error_PS(:,3),'.')
xlabel('T','Fontsize',Fontsize);
ylabel('T Error','Fontsize',Fontsize)
set(gca,'Fontsize',Fontsize)
subplot(3,2,4)
hold on
grid on
axis([-1 1 -1 1])
axis square
plot(k_Orig_All(:,3),Abso_k_Error_PS(:,3),'.')
xlabel('k','Fontsize',Fontsize);
ylabel('k Error','Fontsize',Fontsize)
set(gca,'Fontsize',Fontsize)
% Model 6
subplot(3,2,5)
hold on
grid on
axis([-1 1 -1 1])
axis square
plot(T_Orig_All(:,6),Abso_T_Error_PS(:,6),'.')
xlabel('T','Fontsize',Fontsize);
ylabel('T Error','Fontsize',Fontsize)
set(gca,'Fontsize',Fontsize)
subplot(3,2,6)
hold on
grid on
axis([-1 1 -1 1])
axis square
plot(k_Orig_All(:,6),Abso_k_Error_PS(:,6),'.')
xlabel('k','Fontsize',Fontsize);
ylabel('k Error','Fontsize',Fontsize)
set(gca,'Fontsize',Fontsize)