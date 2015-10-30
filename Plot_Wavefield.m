% Plot the forward wavefield
function Plot_Wavefield(SWavefield_L,Wavefield,Sample_Interval)
Fontsize=9;
YTick_Int=round(SWavefield_L/15);
YTick=0:YTick_Int:SWavefield_L;
YTickLabel=[0:YTick_Int:SWavefield_L]*Sample_Interval*1000;
f1=figure;
set(f1,'Position',[100 100 1400 800])
%
subplot(1,3,1)
wigb(Wavefield(:,:,1)');
set(gca,'YTick',YTick,'YTickLabel',YTickLabel,'FontSize',Fontsize);
title('X Component','FontSize',Fontsize)
xlabel('Trace','FontSize',Fontsize);
ylabel('Time/ms','FontSize',Fontsize);
%
subplot(1,3,2)
wigb(Wavefield(:,:,2)');
set(gca,'YTick',YTick,'YTickLabel',YTickLabel,'FontSize',Fontsize);
title('Y Component','FontSize',Fontsize)
xlabel('Trace','FontSize',Fontsize);
ylabel('Time/ms','FontSize',Fontsize);
%
subplot(1,3,3)
wigb(Wavefield(:,:,3)');
set(gca,'YTick',YTick,'YTickLabel',YTickLabel,'FontSize',Fontsize);
title('Z Component','FontSize',Fontsize)
xlabel('Trace','FontSize',Fontsize);
ylabel('Time/ms','FontSize',Fontsize);

set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 16 8]);
print(f1,'-r300','-dtiff','Wavefield-DC');
end