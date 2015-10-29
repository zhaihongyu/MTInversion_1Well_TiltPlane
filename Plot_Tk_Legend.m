function Plot_Tk_Legend(Tk_Original,Tk_Inversion)
% This mainly purpose is plotting the legend of T-k diagram 2015-6-24 %
% Basic diagram parameters 2015-6-24 %
Markersize=4;
LineWidth=0.1;
FontSize=9;
%
Tk_Original1=Tk_Original(:,:,1);
Tk_Original2=Tk_Original(:,:,2);
Tk_Original3=Tk_Original(:,:,3);
Tk_Original4=Tk_Original(:,:,4);

Tk_Inversion1=Tk_Inversion(:,:,1);
Tk_Inversion2=Tk_Inversion(:,:,2);
Tk_Inversion3=Tk_Inversion(:,:,3);
Tk_Inversion4=Tk_Inversion(:,:,4);
% Transform the T-k parameters to x-y coordinates
[TkOriginal_XY1]=Tk_Transform(Tk_Original1);
[TkInversion_XY1]=Tk_Transform(Tk_Inversion1);

[TkOriginal_XY2]=Tk_Transform(Tk_Original2);
[TkInversion_XY2]=Tk_Transform(Tk_Inversion2);

[TkOriginal_XY3]=Tk_Transform(Tk_Original3);
[TkInversion_XY3]=Tk_Transform(Tk_Inversion3);

[TkOriginal_XY4]=Tk_Transform(Tk_Original4);
[TkInversion_XY4]=Tk_Transform(Tk_Inversion4);
f_legend=figure();
set(f_legend,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 13 8]);
hold on;
%Set the title
Title='T-k diagram legend figure';
title(Title,'FontSize',FontSize);
%  Plot the 4 Different Source-Types diagram 2015-6-24 %
axis off;
Plot_SourceTD();
%{
%1st source type
p1=plot(TkInversion_XY1(1,:),TkInversion_XY1(2,:),'o','LineWidth',LineWidth);
set(p1,'Markersize',Markersize,'Markeredgecolor','r');
p2=plot(TkOriginal_XY1(1,:),TkOriginal_XY1(2,:),'o','LineWidth',LineWidth);
set(p2,'Markersize',Markersize,'Markeredgecolor','b');
%2nd source type
p3=plot(TkInversion_XY2(1,:),TkInversion_XY2(2,:),'^','LineWidth',LineWidth);
set(p3,'Markersize',Markersize,'Markeredgecolor','r');
p4=plot(TkOriginal_XY2(1,:),TkOriginal_XY2(2,:),'^','LineWidth',LineWidth);
set(p4,'Markersize',Markersize,'Markeredgecolor','b');
%3rd source type
p5=plot(TkInversion_XY3(1,:),TkInversion_XY3(2,:),'d','LineWidth',LineWidth);
set(p5,'Markersize',Markersize,'Markeredgecolor','r');
p6=plot(TkOriginal_XY3(1,:),TkOriginal_XY3(2,:),'d','LineWidth',LineWidth);
set(p6,'Markersize',Markersize,'Markeredgecolor','b');
%4th source type
p7=plot(TkInversion_XY4(1,:),TkInversion_XY4(2,:),'s','LineWidth',LineWidth);
set(p7,'Markersize',Markersize,'Markeredgecolor','r');
p8=plot(TkOriginal_XY4(1,:),TkOriginal_XY4(2,:),'s','LineWidth',LineWidth);
set(p8,'Markersize',Markersize,'Markeredgecolor','b');
%}

%1st source type
p1=plot(TkInversion_XY1(1,:),TkInversion_XY1(2,:),'o','LineWidth',LineWidth);
set(p1,'Markersize',Markersize,'Markeredgecolor','r','Markerfacecolor','r');
p2=plot(TkOriginal_XY1(1,:),TkOriginal_XY1(2,:),'o','LineWidth',LineWidth);
set(p2,'Markersize',Markersize,'Markeredgecolor','b','Markerfacecolor','b');
%2nd source type
p3=plot(TkInversion_XY2(1,:),TkInversion_XY2(2,:),'^','LineWidth',LineWidth);
set(p3,'Markersize',Markersize,'Markeredgecolor','r','Markerfacecolor','r');
p4=plot(TkOriginal_XY2(1,:),TkOriginal_XY2(2,:),'^','LineWidth',LineWidth);
set(p4,'Markersize',Markersize,'Markeredgecolor','b','Markerfacecolor','b');
%3rd source type
p5=plot(TkInversion_XY3(1,:),TkInversion_XY3(2,:),'d','LineWidth',LineWidth);
set(p5,'Markersize',Markersize,'Markeredgecolor','r','Markerfacecolor','r');
p6=plot(TkOriginal_XY3(1,:),TkOriginal_XY3(2,:),'d','LineWidth',LineWidth);
set(p6,'Markersize',Markersize,'Markeredgecolor','b','Markerfacecolor','b');
%4th source type
p7=plot(TkInversion_XY4(1,:),TkInversion_XY4(2,:),'s','LineWidth',LineWidth);
set(p7,'Markersize',Markersize,'Markeredgecolor','r','Markerfacecolor','r');
p8=plot(TkOriginal_XY4(1,:),TkOriginal_XY4(2,:),'s','LineWidth',LineWidth);
set(p8,'Markersize',Markersize,'Markeredgecolor','b','Markerfacecolor','b');

% Plot the 4 types legend 2015-6-24 %
l1=legend([p1,p2],'Inv-ISO','Ori-ISO');
l1_Position=[0.5 0.2 1.5 1];
set(l1,'Units','centimeters','Position',l1_Position,'Box','off','FontSize',FontSize);
%
ah1=axes('position',get(gca,'position'),'visible','off');
l2=legend(ah1,[p3,p4],'Inv-DC','Ori-DC');
l2_Position=[l1_Position(1)+3.5,l1_Position(2),l1_Position(3),l1_Position(4)];
set(l2,'Units','centimeters','Position',l2_Position,'Box','off','FontSize',FontSize);
%
ah2=axes('position',get(gca,'position'),'visible','off');
l3=legend(ah2,[p5,p6],'Inv-CLVD^-','Ori-CLVD^-');
l3_Position=[l2_Position(1)+4,l2_Position(2),l2_Position(3),l2_Position(4)];
set(l3,'Units','centimeters','Position',l3_Position,'Box','off','FontSize',FontSize);
%
ah3=axes('position',get(gca,'position'),'visible','off');
l4=legend(ah3,[p7,p8],'Inv-CLVD^+','Ori-CLVD^+');
l4_Position=[l3_Position(1)+4,l3_Position(2),l3_Position(3),l3_Position(4)];
set(l4,'Units','centimeters','Position',l4_Position,'Box','off','FontSize',FontSize);
% Save the figure 
print(f_legend,'-r300','-dtiff',Title);
end