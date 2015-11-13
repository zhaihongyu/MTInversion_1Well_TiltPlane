% 2015-11-9 %
% Plot the decomposition results of inversed moment tensors
% According to 'Figure_Type', plot the different type figure:
% Figure_Type=1: plot the result model by model
% Figure_Type='otherwise': plot the result according to MTs form.
function Plot_Decomposition_InveMTs(Inversed_MTs_Decom,Figure_Type)
FontSize=9;
Axis_LineWidth=0.1;
LineWidth=1;
MarkerSize=3;
[Model_Num,Type_Num]=size(Inversed_MTs_Decom);
% Figure basic parameters
MTs_Name={'ISO','DC','CLVD^-','CLVD^+'};
XLabel={'ISO Percent [%]','CLVD Percent [%]','DC Percent [%]'};
FaceColor={'r','g','b'};
% Plot the result of MT decomposition

switch Figure_Type
    case 1
        % plot the result model by model
        for model_id=1:Model_Num
            % Plot the decompisition results model by model
            figure
            hold on
            Title=['Decomposition of inversed MTs (Model ',num2str(model_id),' )'];
            
            set(gcf,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 15 12]);
            set(gcf,'Position',[100 100 900 400])
            SingleType_InveMTs_Decom=Inversed_MTs_Decom(model_id,:);
            AllSubplot_Handles=cell(Type_Num,3);
            
            for i=1:Type_Num
                SingleModel_MTs=SingleType_InveMTs_Decom{i};
                AllSubplot_YLims=zeros(3,2);
                for j=1:3
                    subplot_id=(i-1)*3+j;
                    Subplot_Handle=subplot(Type_Num,3,subplot_id);
                    Bin_Num=8;
                    h1=histogram(SingleModel_MTs(:,j),Bin_Num);
                    set(h1,'FaceColor',FaceColor{j},'Normalization','probability')
                    % Set the axis properties
                    XTick=h1.BinEdges(1:2:Bin_Num+1);
                    XTick_Label=round(XTick*100);
                    Subplot_Title=[MTs_Name{i},'¿‡–Õ’‘¥'];
                    title(Subplot_Title,'FontSize',FontSize);
                    set(gca,'XLim',h1.BinLimits,'XTick',XTick,'XTickLabel',XTick_Label);
                    set(gca,'FontSize',FontSize);
                    xlabel(XLabel{j});
                    
                    AllSubplot_Handles{i,j}=Subplot_Handle;
                    AllSubplot_YLims(j,:)=Subplot_Handle.YLim;
                end
                % Reset the °ÆYLim°Ø of every line of subplot figure
                TheSubplot_Lim=[min(AllSubplot_YLims(:,1)),max(AllSubplot_YLims(:,2))];
                for j=1:3
                    SingleSubplot_Handle=AllSubplot_Handles{i,j};
                    set(SingleSubplot_Handle,'YLim',TheSubplot_Lim);
                end
            end
            %Save the figure
            print('-r300','-dtiff',Title)
        end
    otherwise 
        % plot the result according to MTs form
        for i=1:Type_Num
            % Set the figure iteration
            AllSubplot_Handles=cell(Model_Num,3);
            f1=figure;
            hold on
            set(f1,'PaperPositionMode','manual','PaperUnits','centimeters','PaperPosition',[0 0 15 30]);
            set(f1,'Position',[100 100 900 2500])
            
            Title=['Decomposition of inversed MTs - ',MTs_Name{i}];
            SingleType_InveMTs_Decom=Inversed_MTs_Decom(:,i);
            % Plot the results from 1st model to the last but one model 
            for j=1:Model_Num-1
                SingleModel_MTs=SingleType_InveMTs_Decom{j};
                %Set the model iteration
                for k=1:3
                    %Set the decomposition result iteration
                    subplot_id=(j-1)*3+k;
                    Subplot_handle=subplot(Model_Num,3,subplot_id);
                    
                    Bin_Num=8;
                    h1=histogram(SingleModel_MTs(:,k),Bin_Num);
                    set(h1,'FaceColor',FaceColor{k},'Normalization','probability')
                    % Set the axis properties
                    XTick=h1.BinEdges(1:2:Bin_Num+1);
                    XTick_Label=round(XTick*100);
                    set(gca,'XLim',h1.BinLimits,'XTick',XTick,'XTickLabel',XTick_Label);
                    set(gca,'FontSize',FontSize);
                    
                    AllSubplot_Handles{j,k}=Subplot_handle;
                end     
            end
            % Plot the results of last model 
            LastModel_MTs=SingleType_InveMTs_Decom{Model_Num};
            for k=1:3
                %Set the decomposition result iteration
                subplot_id=(Model_Num-1)*3+k;
                Subplot_handle=subplot(Model_Num,3,subplot_id);
                
                Bin_Num=8;
                h1=histogram(LastModel_MTs(:,k),Bin_Num);
                set(h1,'FaceColor',FaceColor{k},'Normalization','probability')
                % Set the axis properties
                XTick=h1.BinEdges(1:2:Bin_Num+1);
                XTick_Label=round(XTick*100);
                set(gca,'XLim',h1.BinLimits,'XTick',XTick,'XTickLabel',XTick_Label);
                set(gca,'FontSize',FontSize);
                xlabel(XLabel{k});
                
                AllSubplot_Handles{Model_Num,k}=Subplot_handle;
            end
            % Compare and reset the 'YLim' value of all subplots
            AllSubplot_YLims=zeros(3,2);
            for j=1:Model_Num
                for k=1:3
                    SingleSubplot_Handle=AllSubplot_Handles{j,k};
                    AllSubplot_YLims(k,:)=SingleSubplot_Handle.YLim;
                end 
                TheSubplot_Lim=[min(AllSubplot_YLims(:,1)),max(AllSubplot_YLims(:,2))];
                % Reset the °ÆYLim°Ø of every line of subplot figure
                for k=1:3
                    SingleSubplot_Handle=AllSubplot_Handles{j,k};
                    set(SingleSubplot_Handle,'YLim',TheSubplot_Lim);
                end 
            end
            
            %Save the figure
            print('-r300','-dtiff',Title)
        end
        
end 


% End the function
end