function [RandomMTs]=Gen_RandomMTs()
% Display Random moment tensors

% MT_Value=[-1.0,-0.5,-0.1,1.0];
MT_Value=[-1.9,-1,0.5];
% MT_Value=[-1.5,1,0.5];
% MT_Value=[-1.0,1.0,0.0];
% MT_Value=[-1.0,1.0,0.0];
% MT_Value=-[-1.0,-0.5,0.2];
MT_Value_Num=size(MT_Value,2);
RandMT_Num=MT_Value_Num^6*2;
% Rand_Values=rand(6,RandMT_Num);
% Generate the random ISO moment tensors %
ISO=[1 0 0 1 0 1;-1 0 0 -1 0 -1]';

per_coe=0.1:0.1:1.2;
Per_Coe_Num=size(per_coe,2);
EveryPer_Coe_Num=1:Per_Coe_Num;
ISO_Rands_Num=sum(EveryPer_Coe_Num);
ISO_Rands=rand(6,ISO_Rands_Num*2);
% per_coe=[0.01,0.1,0.4,0.9];
Str=0;
for j=1:Per_Coe_Num  
    %     Generate the random explosion MT
    for i=1:EveryPer_Coe_Num(j)
        ISO_Rands(:,Str+i)=per_coe(j)*ISO_Rands(:,Str+i)+ISO(:,1);
        
        %     ISO_Rands(:,i+200)=-per_coe*ISO_Rands(:,i)+ISO(:,2);
    end
    %     Generate the random implosion MT
    for i=1:1:EveryPer_Coe_Num(j)
%         ISO_Rands(:,Str+i+ISO_Rands_Num)=per_coe(j)*ISO_Rands(:,Str+i+ISO_Rands_Num)+ISO(:,2);
        ISO_Rands(:,Str+i+ISO_Rands_Num)=-ISO_Rands(:,Str+i);
        %     ISO_Rands(:,i+200)=-per_coe*ISO_Rands(:,i)+ISO(:,2);
    end
    Str=sum(EveryPer_Coe_Num(1:j));
    
    %     End=ISO_Rands_Num_Part*j;
    
end


% RandMTs=zeros(6,1);
RandMTs=zeros(6,RandMT_Num);
count=1;
for i=1:MT_Value_Num
%     2nd element of moment tensor vector
    for j=1:MT_Value_Num
%         3rd element of moment tensor vector
        for k=1:MT_Value_Num
%             4th element of moment tensor vector
            for l=1:MT_Value_Num
%                 5th element of moment tensor vector
                for m=1:MT_Value_Num
%                     6th element of moment tensor vector
                    for n=1:MT_Value_Num
%                         According to the iterarion, changing the MT_Vector
                        RandMTs(1,count)=MT_Value(n);
                        RandMTs(2,count)=MT_Value(m);
                        RandMTs(3,count)=MT_Value(l);
                        RandMTs(4,count)=MT_Value(k);
                        RandMTs(5,count)=MT_Value(j);
                        RandMTs(6,count)=MT_Value(i);
%                         RandMTs(:,count)=RandMTs(:,count)+0.9*Rand_Values(:,count);
                        count=count+1;
                    end
                end
            end
        end
    end
end

MT_Value=-MT_Value;
RandMTs2=zeros(6,RandMT_Num);
count=1;
for i=1:MT_Value_Num
%     2nd element of moment tensor vector
    for j=1:MT_Value_Num
%         3rd element of moment tensor vector
        for k=1:MT_Value_Num
%             4th element of moment tensor vector
            for l=1:MT_Value_Num
%                 5th element of moment tensor vector
                for m=1:MT_Value_Num
%                     6th element of moment tensor vector
                    for n=1:MT_Value_Num
%                         According to the iterarion, changing the MT_Vector
                        RandMTs2(1,count)=MT_Value(n);
                        RandMTs2(2,count)=MT_Value(m);
                        RandMTs2(3,count)=MT_Value(l);
                        RandMTs2(4,count)=MT_Value(k);
                        RandMTs2(5,count)=MT_Value(j);
                        RandMTs2(6,count)=MT_Value(i);
                        count=count+1;
                    end
                end
            end
        end
    end
end

RandMTss=[RandMTs,ISO_Rands];
% Tk_All=zeros(2,RandMT_Num);
% Transform the MT vector
% Tk_All=MT_Transform(ISO_Rands);
Tk_All=MT_Transform(RandMTss);
% Tk_All=MT_Transform(RandMTs);
Tk_All2=MT_Transform(RandMTs2);
% delete the same value in the RandMtss
for i=1:size(RandMTss,2)
    for j=i+1:size(RandMTss,2)
        Error=abs(Tk_All(1,i)-Tk_All(1,j));
        if Error<=1E-4
            Tk_All(:,j)=[0;0];
        end
    end
end
[Idx]=find(abs(Tk_All(1,:))>0);
New_Tk_All=Tk_All(:,Idx);
New_RandMTs1=RandMTss(:,Idx);
% Delete the same value in the RandMts2
for i=1:size(RandMTs2,2)
    for j=i+1:size(RandMTs2,2)
        Error=abs(Tk_All2(1,i)-Tk_All2(1,j));
        if Error<=1E-4
            Tk_All2(:,j)=[0;0];
        end
    end
end
[Idx]=find(abs(Tk_All2(1,:))>0);
New_Tk_All2=Tk_All2(:,Idx);
New_RandMTs2=RandMTs2(:,Idx);

% Plot the random moment tensors  Version 1 2015-6-18 %
%{
f1=figure();
set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperSize',[8 7]);
% set(f1,'position',[0 0 900 700])
hold on;
% Transform the T-k parameters to x-y coordinates
[TkOriginal_XY1]=Tk_Transform(New_Tk_All);
[TkOriginal_XY2]=Tk_Transform(New_Tk_All2);

%         Plot the Source-Type diagram
axis off;
Plot_SourceTD();
FontSize=20;
Markersize=7;
LineWidth=2;
%
p1=plot(TkOriginal_XY1(1,:),TkOriginal_XY1(2,:),'o','LineWidth',LineWidth);
set(p1,'Markersize',Markersize,'Markeredgecolor','r');
p2=plot(TkOriginal_XY2(1,:),TkOriginal_XY2(2,:),'o','LineWidth',LineWidth);
set(p2,'Markersize',Markersize,'Markeredgecolor','r');

Title=['Hudson Diagram'];
title(Title,'FontSize',FontSize);
% set(f1,'PaperPositionMode','manual','PaperUnits','points','PaperPosition',[0 0 900 700]);
print(f1,'-r300','-djpeg',Title);
%}

% Generate the final random MTs Version 2 2015-6-18 %
RandomMTs=[New_RandMTs1,New_RandMTs2];
% Adding random noise to the random moment tensor 2015-6-17 %
Per_Coe=0.15;
RandomMTs_Num=size(RandomMTs,2);
RandMT_ValueOri=rand(6,RandomMTs_Num)*Per_Coe;
for i=1:round(RandomMTs_Num/2)
    RandomMTs(:,i)=RandomMTs(:,i)+abs(RandMT_ValueOri(:,i));
end
for i=round(RandomMTs_Num/2)+1:RandomMTs_Num
    RandomMTs(:,i)=RandomMTs(:,i)+RandMT_ValueOri(:,i);
end
% Plot the random moment tensors 2015-6-18 %
f2=figure();
set(f2,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 8 7]);

% set(f2,'position',[0 0 900 700])
hold on;
% Transform the T-k parameters to x-y coordinates
[RandomTk]=MT_Transform(RandomMTs);
[RandomTk_XY]=Tk_Transform(RandomTk);

%         Plot the Source-Type diagram
axis off;
Plot_SourceTD();
FontSize=10;
Markersize=3;
LineWidth=1;
%
p1=plot(RandomTk_XY(1,:),RandomTk_XY(2,:),'o','LineWidth',LineWidth);
set(p1,'Markersize',Markersize,'Markeredgecolor','r');

Title=['Hudson Diagram'];
title(Title,'FontSize',FontSize);
% set(f2,'PaperPositionMode','manual','PaperUnits','points','PaperPosition',[0 0 900 700]);
print(f2,'-r300','-djpeg',Title);
end
