% Combine the travel time of direct wave and refelect wave 2015-9-15
% Treat the direct wave and reflect wave as two kind of observation system.
% So the receiver number will be same for the two system
% "TravelTime"=The total travel time for every kind of wave at every receiver
function [Rho,TravelTime,TravelTime_P,TravelTime_S]=Combine_TravelTime...
    (TraveTime_DirWav_P,TraveTime_DirWav_S,TravelTime_RefWave_P,TravelTime_RefWave_S)
% Set Model Parameters
Rho=2.5;
% Set the basic parameters
Rec_Num_DirWave=size(TraveTime_DirWav_P,2);
Rec_Num_RefWave=size(TraveTime_DirWav_P,2);
Rec_Num_All=Rec_Num_DirWave+Rec_Num_RefWave;

TravelTime=zeros(2,Rec_Num_All);
TravelTime_P=[TraveTime_DirWav_P,TravelTime_RefWave_P];
TravelTime_S=[TraveTime_DirWav_S,TravelTime_RefWave_S];
% Calculate the total travel time of the direct P & S wave
for i=1:Rec_Num_DirWave
    TT_SingleRec_DirP=TraveTime_DirWav_P{i};
    TT_SingleRec_DirS=TraveTime_DirWav_S{i};
    %In this place consider the multi-layers situation
    Layer_Num=size(TT_SingleRec_DirP,2);
    for j=1:Layer_Num
        TravelTime(1,i)=TravelTime(1,i)+TT_SingleRec_DirP(j);
        TravelTime(2,i)=TravelTime(2,i)+TT_SingleRec_DirS(j);
    end
end
% Calculate the total travel time of the reflect P & S wave
for i=1:Rec_Num_RefWave
    TT_SingleRec_RefP=TravelTime_RefWave_P{i};
    TT_SingleRec_RefS=TravelTime_RefWave_S{i};
    %In this place consider the multi-layers situation
    Layer_Num=size(TT_SingleRec_RefP,2);
    for j=1:Layer_Num
        TravelTime(1,i+Rec_Num_DirWave)=TravelTime(1,i+Rec_Num_DirWave)+TT_SingleRec_RefP(j);
        TravelTime(2,i+Rec_Num_DirWave)=TravelTime(2,i+Rec_Num_DirWave)+TT_SingleRec_RefS(j);
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

end