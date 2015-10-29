% Combine the travel time of directive wave and refelective wave 2015-9-15
function [Rho,Qp,Qs,TravelTime]=Set_QModel_TravelT...
    (TraveTime_DirWav_P,TraveTime_DirWav_S)
% % % Set the model parameters (Version 1)
% In this version, we choose the circle geometry around the event
% Qp=zeros(1,LayerNum);
% Qs=zeros(1,LayerNum);

Qp=[340,360,200,340];
Qs=[90,100,50,100];

Rec_Num=size(TraveTime_DirWav_P,2);
% Calculate the total travel time of the direct P & S wave
TravelTime=zeros(2,Rec_Num);
for i=1:Rec_Num
    TravelTime_SingleRec_P=TraveTime_DirWav_P{i};
    TravelTime_SingleRec_S=TraveTime_DirWav_S{i};
    Layer_Num=size(TravelTime_SingleRec_P,2);
    for j=1:Layer_Num
        TravelTime(1,i)=TravelTime(1,i)+TravelTime_SingleRec_P(j);
        TravelTime(2,i)=TravelTime(2,i)+TravelTime_SingleRec_S(j);
    end
    
end

%{
Qp=Qp_Min:Qp_Int:Qp_Min+Qp_Int*(Model_Num-1);
Qs=Qs_Min:Qs_Int:Qs_Min+Qs_Int*(Model_Num-1);

% Q Parameters
Q_Value=[Qp;Qs];
Q_Idx=1:Model_Num;
% Plot the Q value 
Fq=figure();
set(Fq,'Position',[100 100 600 1000]);
hold on
plot(Q_Idx,Q_Value,'-*','Linewidth',3,'Markersize',8);
set(gca,'YTick',[0:200:1200],'YTickLabel',{'0','200','400','600','800','1000','Infinite'});
set(gca,'XAxisLocation','top','Fontsize',14);
% set(gca,'XAxisLocation','top','Xlim',[0 8],'Fontsize',14);
grid on
xlabel('Model Index')
ylabel('Q Value');
legend('Qp','Qs','Location','Northwest');
set(gcf,'PaperPositionMode','manual','PaperUnits','point','PaperPosition',[100 100 600 1000]);
print('-r300','-djpeg','QModel');

Qp=[Qp_Min:Qp_Int:Qp_Min+Qp_Int*(Model_Num-2),5000];
Qs=[Qs_Min:Qs_Int:Qs_Min+Qs_Int*(Model_Num-2),6000];
%}
% Set Model Parameters
Rho=2.5;
end