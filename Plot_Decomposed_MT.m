% 2015-11-4
% According to the original and inversed MT, plot the decomposition results
% and the inversion error.

function Plot_Decomposed_MT(Original_MT_Decom,Inversed_MT_Decom)
% Figure parameters

FontSize=9;
LineWidth=0.1;
MarkerSize=3;
% Get the input parameter property
Source_Num=4;
MT_Name={'ISO','DC','CLVD^-','CLVD^+'};
Legend={'ISO','CLVD','DC'};

[Total_MT_Num,Com,Model_Num]=size(Original_MT_Decom);
Model_Idx=1:Model_Num;
Random_MT_Num=Total_MT_Num/Source_Num;
Azimuth_Int=2*pi/Model_Num;
Azimuth=(0:Azimuth_Int:2*pi-Azimuth_Int)*180/pi;

% Acoording to the 'Random_MT_Num', plot the different types of figure
switch Random_MT_Num
    case 1
        % Single input source 
        for i=1:Source_Num
            Original_MT=reshape(Original_MT_Decom(i,:,:),3,Model_Num);
            Inversed_MT=reshape(Inversed_MT_Decom(i,:,:),3,Model_Num);
            Inversion_Error_MT=Inversed_MT-Original_MT;
            
            figure
            set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 16 8])
            % Plot the original and inversed results
            subplot(1,2,1)
            grid on
            hold on
            for j=1:3
                p1=plot(Azimuth,Original_MT(j,:),'--s','LineWidth',LineWidth,'MarkerSize',MarkerSize);
                GetColor=p1.Color;
                plot(Azimuth,Inversed_MT(j,:),'-*','LineWidth',LineWidth,'MarkerSize',MarkerSize,'Color',GetColor);
            end
            for j=1:3
                plot(Azimuth,Inversed_MT(j,:),'-*','LineWidth',LineWidth,'MarkerSize',MarkerSize);
            end
            p1=plot(Azimuth,Original_MT,'--s','LineWidth',LineWidth,'MarkerSize',MarkerSize);
            p2=plot(Azimuth,Inversed_MT,'-*','LineWidth',LineWidth,'MarkerSize',MarkerSize);
            
            YLim_P1=[floor(min(min(Inversed_MT))*10),ceil(max(max(Inversed_MT))*10)]/10;
            YTick_P1=YLim_P1(1):0.1:YLim_P1(2);
            YTickLabel_P1=YLim_P1(1)*100:10:YLim_P1(2)*100;
            set(gca,'YLim',YLim_P1,'YTick',YTick_P1,'YTicklabel',YTickLabel_P1,'FontSize',FontSize)
            ylabel('DC and non-DC [%]','FontSize',FontSize);
            xlabel('Oberve well Azimuth [^o]','FontSize',FontSize);
            
            legend(p1,Legend);
            legend(p2,Legend);
            Title_P1=['Inversion Result - ',MT_Name{i}];
            title(Title_P1);
            % Plot the inversion error
            subplot(1,2,2)
            grid on
            hold on
            plot(Azimuth,Inversion_Error_MT,'-s','LineWidth',LineWidth,'MarkerSize',MarkerSize);
            
            YLim_P2=[floor(min(min(Inversion_Error_MT))*10),ceil(max(max(Inversion_Error_MT))*10)]/10;
            YTick_P2=YLim_P2(1):0.1:YLim_P2(2);
            YTickLabel_P2=YLim_P2(1)*100:10:YLim_P2(2)*100;
            set(gca,'YLim',YLim_P2,'YTick',YTick_P2,'YTicklabel',YTickLabel_P2,'FontSize',FontSize)
            ylabel('DC and non-DC [%]');
            xlabel('Oberve well Azimuth [^o]');
            Title_P1=['Inversion Error - ',MT_Name{i}];
            title(Title_P1);
            % Save the picture
            Title=['Inversion Results and Inversion Error - ',MT_Name{i}];
            print('-r300','-dtiff',Title)
            
            set(gcf,'Position',[100 100 1600 800]);
        end
        
    otherwise
        % Multiple input sources
        
end


end