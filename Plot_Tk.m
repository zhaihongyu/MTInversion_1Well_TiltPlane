function Plot_Tk(Tk_Original,Tk_Inversion,Plot_Type)
[Paras_Num,Num,Source_Type_Num]=size(Tk_Inversion);

% When Plot_Type is equal with 1, plot the original data and inverion data in one figure
% When Plot_Type is equal with 2, plot the original data and inverion data in two figure
% When Plot_Type is equal with 3, plot different types of sources of their original and inverion results in one figure
switch Plot_Type
    case 1
        % Transform the T-k parameters to x-y coordinates
        [TkOriginal_XY]=Tk_Transform(Tk_Original);
        [TkInversion_XY]=Tk_Transform(Tk_Inversion);
%         set(gcf,'position',[100 100 800 600]);
        axis off;
%         f1=figure();
%         hold on
        Plot_SourceTD();
        %{
        p1=plot(TkInversion_XY(1,:),TkInversion_XY(2,:),'*r','Markersize',12,'LineWidth',2.5);
        p2=plot(TkOriginal_XY(1,:),TkOriginal_XY(2,:),'.b','Markersize',22,'LineWidth',3);
        legend(p1,'Inversion MT');
        legend(p2,'Original MT');
        %}
%         p1=plot(TkInversion_XY(1,:),TkInversion_XY(2,:),'o','Markersize',5,'Markerfacecolor','r','Markeredgecolor','r',...
%             TkOriginal_XY(1,:),TkOriginal_XY(2,:),'^','Markersize',5,'Markerfacecolor','b','Markeredgecolor','b');
% %         set(p1,'Markersize',8,'LineWidth',1);
%         l1=legend(p1,'Inversion MT','Original MT');
%         set(l1,'FontSize',18)

        p1=plot(TkInversion_XY(1,:),TkInversion_XY(2,:),'o');
        set(p1,'Markersize',5,'Markerfacecolor','r','Markeredgecolor','r');
        p2=plot(TkOriginal_XY(1,:),TkOriginal_XY(2,:),'^');
        set(p2,'Markersize',5,'Markerfacecolor','b','Markeredgecolor','b');
        l1=legend([p1,p2],'Inversion MT','Original MT');
        set(l1,'FontSize',12,'Location','Southeast')
        
        %{
        for i=1:Num
%             Plot the original data and inverion data on the T-k diagram
            p1=plot(TkInversion_XY(1,i),TkInversion_XY(2,i),'*r','Markersize',12,'LineWidth',2.5);
            p2=plot(TkOriginal_XY(1,i),TkOriginal_XY(2,i),'.b','Markersize',22,'LineWidth',3);
        end
        %}
        
    case 2
        % Transform the T-k parameters to x-y coordinates
        [TkOriginal_XY]=Tk_Transform(Tk_Original);
        [TkInversion_XY]=Tk_Transform(Tk_Inversion);
        
        set(gcf,'position',[100 100 1900 600]);
        subplot(1,2,1)
        hold on
        Plot_SourceTD();
        for i=1:Num
%             Plot the original data and inverion data on the T-k diagram
            plot(TkOriginal_XY(1,i),TkOriginal_XY(2,i),'.b','Markersize',15,'LineWidth',2);
        end
        t1=title('Moment Tensor Inversion');
        set(t1,'FontSize',18)
        subplot(1,2,2)
        hold on
        Plot_SourceTD();
        for i=1:Num
%             Plot the original data and inverion data on the T-k diagram
            plot(TkInversion_XY(1,i),TkInversion_XY(2,i),'.r','Markersize',15,'LineWidth',2);
        end
        t2=title('Moment Tensor Inversion with Attenuation');
        set(t2,'FontSize',12)
%         Set the figure propersities
        axis off;
    case 3
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
        %         Plot the Source-Type diagram
        axis off;
        Plot_SourceTD();
        Markersize=3;
        LineWidth=0.1;
        %         FontSize=8;
        
        %{
        p1=plot(TkInversion_XY1(1,:),TkInversion_XY1(2,:),'o','LineWidth',LineWidth);
        set(p1,'Markersize',Markersize,'Markeredgecolor','r');
        p2=plot(TkOriginal_XY1(1,:),TkOriginal_XY1(2,:),'o','LineWidth',LineWidth);
        set(p2,'Markersize',Markersize,'Markeredgecolor','b');
        %
        p3=plot(TkInversion_XY2(1,:),TkInversion_XY2(2,:),'^','LineWidth',LineWidth);
        set(p3,'Markersize',Markersize,'Markeredgecolor','r');
        p4=plot(TkOriginal_XY2(1,:),TkOriginal_XY2(2,:),'^','LineWidth',LineWidth);
        set(p4,'Markersize',Markersize,'Markeredgecolor','b');
        %
        p5=plot(TkInversion_XY3(1,:),TkInversion_XY3(2,:),'d','LineWidth',LineWidth);
        set(p5,'Markersize',Markersize,'Markeredgecolor','r');
        p6=plot(TkOriginal_XY3(1,:),TkOriginal_XY3(2,:),'d','LineWidth',LineWidth);
        set(p6,'Markersize',Markersize,'Markeredgecolor','b');
        %
        p7=plot(TkInversion_XY4(1,:),TkInversion_XY4(2,:),'s','LineWidth',LineWidth);
        set(p7,'Markersize',Markersize,'Markeredgecolor','r');
        p8=plot(TkOriginal_XY4(1,:),TkOriginal_XY4(2,:),'s','LineWidth',LineWidth);
        set(p8,'Markersize',Markersize,'Markeredgecolor','b');
        
        %}
        
        %
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
        %}
        
    case 4
        Tk_Original1=Tk_Original(:,1);
        Tk_Original2=Tk_Original(:,2);
        Tk_Original3=Tk_Original(:,3);
        Tk_Original4=Tk_Original(:,4);
        
        % Transform the T-k parameters to x-y coordinates
        [TkOriginal_XY1]=Tk_Transform(Tk_Original1);
        [TkOriginal_XY2]=Tk_Transform(Tk_Original2);
        [TkOriginal_XY3]=Tk_Transform(Tk_Original3);
        [TkOriginal_XY4]=Tk_Transform(Tk_Original4);
        
        %         Plot the Source-Type diagram
        axis off;
        Plot_SourceTD();

        p2=plot(TkOriginal_XY1(1,:),TkOriginal_XY1(2,:),'o','LineWidth',1);
        set(p2,'Markersize',6,'Markeredgecolor','b','Markerfacecolor','b');
        
        p4=plot(TkOriginal_XY2(1,:),TkOriginal_XY2(2,:),'^','LineWidth',1);
        set(p4,'Markersize',6,'Markeredgecolor','b','Markerfacecolor','b');
        
        p6=plot(TkOriginal_XY3(1,:),TkOriginal_XY3(2,:),'d','LineWidth',1);
        set(p6,'Markersize',6,'Markeredgecolor','b','Markerfacecolor','b');
        
        p8=plot(TkOriginal_XY4(1,:),TkOriginal_XY4(2,:),'s','LineWidth',1);
        set(p8,'Markersize',6,'Markeredgecolor','b','Markerfacecolor','b');
        l1=legend([p2,p4,p6,p8],'ISO','CLVD','LVD','DC');
        set(l1,'FontSize',12,'Location','Southeast')
    otherwise
    
end
