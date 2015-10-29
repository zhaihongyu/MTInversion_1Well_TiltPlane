function Plot_PS_WaveField(Well_Num,P_wave,P_wave_xyz,S_wave,S_wave_xyz)

Rec_Num=size(P_wave,1);
Rec_Num_1Well=Rec_Num/Well_Num;
% Y_Lim=max(T_Interval_PS);
Title_3C=['X','Y','Z'];
%{
% % % Plot the P-wave field
figure
subplot(1,4,1)
hold on
for i=1:Rec_Num
    plot(P_wave(i,:),T_Interval_PS,'k');
end
title('P-Wave Field');
set(gca,'YDir','reverse','YLim',[200 Y_Lim])
% Plot the X,Y,Z component P-wave field

for j=1:3
    subplot(1,4,j+1)
    hold on
    for i=1:Rec_Num
        plot(P_wave_xyz(i,:,j),T_Interval_PS,'k');
    end
    Title=['P-Wave Field ',Title_3C(j),'-D'];
    title(Title);
    set(gca,'YDir','reverse','YLim',[200 Y_Lim])
end

% % % Plot the S-wave field
figure
subplot(1,4,1)
hold on
for i=1:Rec_Num
    plot(S_wave(i,:),T_Interval_PS,'k');
end
title('S-Wave Field');
set(gca,'YDir','reverse','YLim',[200 Y_Lim])
% Plot the X,Y,Z component S-wave field
Title_3C=['X','Y','Z'];
for j=1:3
    subplot(1,4,j+1)
    hold on
    for i=1:Rec_Num
        plot(S_wave_xyz(i,:,j),T_Interval_PS,'k');
    end
    Title=['S-Wave Field ',Title_3C(j),'-D'];
    title(Title);
    set(gca,'YDir','reverse','YLim',[200 Y_Lim])
end
%}
% % % Generate the whole wave field
Wavefield=P_wave+S_wave;
Wavefield_xyz=P_wave_xyz+S_wave_xyz;
% % % Normalization Processing
Max_XYZ=max(Wavefield_xyz);

% % % Plot the PS-wave field using two different colors
%{
f1=figure();
set(f1,'position',[150 150 2000 1200]);

subplot(1,4,1)
hold on
for i=1:Rec_Num
    plot(Wavefield(i,:),T_Interval_PS,'k');
end
set(gca,'YDir','reverse','YLim',[200 Y_Lim]);
%}
%{
for j=1:3
    subplot(1,3,j)
    hold on
    for i=1:Rec_Num
        plot(P_wave_xyz(i,:,1),T_Interval_PS,'r','Linewidth',0.1);
    end
    for i=1:Rec_Num
        plot(S_wave_xyz(i,:,1),T_Interval_PS,'b','Linewidth',0.1);
    end
    Title=['PS-Wave Field ',Title_3C(j),'-Component'];
    title(Title,'FontSize',18);
    xlabel('Trace Number','FontSize',18);
    ylabel('Time(ms)','FontSize',18);
    set(gca,'YDir','reverse','YLim',[100 700],'XLim',[0 280])
    set(gca,'XTick',[0:50:300],'XTickLabel',[0:5:30],'FontSize',18)
end
%}


% % % Plot the PS-wave field
%{
f1=figure();
set(f1,'position',[150 150 2000 1200]);
for j=1:3
    subplot(1,3,j)
    hold on
    for i=1:Rec_Num
        plot(Wavefield_xyz(i,:,j),T_Interval_PS,'k','Linewidth',0.1);
    end
    Title=['PS-Wave Field ',Title_3C(j),'-Component'];
    title(Title,'FontSize',18);
    xlabel('Trace Number','FontSize',18);
    ylabel('Time(ms)','FontSize',18);
%     set(gca,'YDir','reverse','YLim',[100 700],'XLim',[0 280])
    set(gca,'YDir','reverse')
    set(gca,'XTick',[0:50:300],'XTickLabel',[0:5:30],'FontSize',18)
end
%}
%
% % % Plot the PS-wave field in different well
%{
Rec_Num_Well=Rec_Num/3;
for i=1:3
    f1=figure();
    set(f1,'position',[150 150 1800 1200]);
    for j=1:3
        subplot(1,3,j)
        hold on
        for k=1:Rec_Num_Well
            plot(Wavefield_xyz(k+Rec_Num_Well*(i-1),:,j),T_Interval_PS,'k','Linewidth',0.1);
        end
        Title=['PS-Wave Field ',Title_3C(j),'-Component'];
        title(Title,'FontSize',18);
        xlabel('Trace Number','FontSize',18);
        ylabel('Time(ms)','FontSize',18);
        %     set(gca,'YDir','reverse','YLim',[100 700],'XLim',[0 280])
        set(gca,'YDir','reverse')
%         set(gca,'XTick',[0:50:300],'XTickLabel',[0:5:30],'FontSize',18)
    end
end
%}

% % % Only plot the wave filed in 1 well 2015-4-22 % % %
Wavefiled_1Well=Wavefield(1:Rec_Num_1Well,:)';
Wavefiled_XYZ_1Well=Wavefield_xyz(1:Rec_Num_1Well,:,:);
% Plot the PS wavefield
figure
wigb(Wavefiled_1Well);
figure
subplot(1,3,1)
wigb(Wavefiled_XYZ_1Well(:,:,1)')
subplot(1,3,2)
wigb(Wavefiled_XYZ_1Well(:,:,2)')
subplot(1,3,3)
wigb(Wavefiled_XYZ_1Well(:,:,3)')
end
%}