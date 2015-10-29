function Gradient_SVD(Matrix)
% Calculate the svd of gradient matrix  2015-5-13 %

% Matrix=rand(Matrix_D);
% SVD
[U,S,W]=svd(Matrix);
Matrix_D=size(W,1);
Initial_Single_Value=diag(S);
Single_Value_Int=max(Initial_Single_Value)-min(Initial_Single_Value);
% Set the basic parameters
X_Id=1:Matrix_D;
Y_Id=1:Matrix_D;
Y_Tick=0.5:(Matrix_D/5):Matrix_D+0.5;
digits(3);
Y_TickLabel=Initial_Single_Value(Matrix_D):Single_Value_Int/5:Initial_Single_Value(1);
Y_TickLabel=double(vpa(Y_TickLabel,3));

% [X_3D,Y_3D]=meshgrid(X_Id,Y_Id);
Single_Value=diag(S)/max(diag(S))*(Matrix_D)+0.5;
% Plot the result of SVD
Fontsize=16;
figure
hold on
imagesc(X_Id,Y_Id,abs(W'))
colormap(gray)
plot(X_Id,Single_Value,'r-*');
set(gca,'YLim',[0.5,Matrix_D+0.5],'XLim',[0.5,Matrix_D+0.5],'FontSize',Fontsize)
set(gca,'YTick',Y_Tick,'YTickLabel',Y_TickLabel);
axis square
end


