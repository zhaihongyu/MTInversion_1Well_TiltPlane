% Plot the Hudson diagram and some basic moment tensor 2015-6-26 %
function Hudson_Dia()

% Some basic seismic moment tensors 2015-6-26 %
M_ISO_Pos=2/3*[1 0 0;0 1 0;0 0 1];
M_ISO_Neg=-2/3*[1 0 0;0 1 0;0 0 1];
M_DC=[1 0 0;0 0 0;0 0 -1];
M_CLVD_Neg=2/3*[1 0 0;0 1 0;0 0 -2];
M_CLVD_Pos=2/3*[2 0 0;0 -1 0;0 0 -1];
M_LD_Pos=[1 0 0;0 0 0;0 0 0];
M_LD_Neg=[-1 0 0;0 0 0;0 0 0];
M_TC_Pos=[0.25 0 0;0 0.25 0;0 0 1-0.25];
M_TC_Neg=-[0.25 0 0;0 0.25 0;0 0 1-0.25];
M_IP_Pos=[1 0 0;0 1 0;0 0 0];
M_CD_Pos=[1 0 0;0 1 0;0 0 2*0.25];

MTs=zeros(3,3,10);
MTs(:,:,1)=M_ISO_Pos;
MTs(:,:,2)=M_ISO_Neg;
MTs(:,:,3)=M_DC;
MTs(:,:,4)=M_CLVD_Neg;
MTs(:,:,5)=M_CLVD_Pos;
MTs(:,:,6)=M_LD_Pos;
MTs(:,:,7)=M_LD_Neg;
MTs(:,:,8)=M_TC_Pos;
MTs(:,:,9)=M_TC_Neg;
% MTs(:,:,9)=M_IP_Pos;
% MTs(:,:,10)=M_CD_Pos;
% Transform the moment tensors 2015-6-26 %
MTs_Num=9;
MTs_Vector=zeros(6,MTs_Num);
for i=1:MTs_Num
    MT=MTs(:,:,i);
    MTs_Vector(:,i)=[MT(1,1);MT(1,2);MT(1,3);MT(2,2);MT(2,3);MT(3,3);];  
end
[MTs_Tk]=MT_Transform(MTs_Vector);
[MTs_Tk_XY]=Tk_Transform(MTs_Tk);
% Plot the Hudson diagram 2015-6-28 %
Title='Dudson diagram';
Markersize=3;
LineWidth=0.1;
f1=figure();
set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 8 6]);
hold on
Plot_SourceTD();

plot(MTs_Tk_XY(1,:),MTs_Tk_XY(2,:),'o','LineWidth',LineWidth,...
    'Markersize',Markersize,'Markeredgecolor','b','Markerfacecolor','b');
% Save the figure 2015-6-28 %
print(f1,'-r300','-dtiff',Title);
end