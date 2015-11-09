% Transform the moment tensor to T-k parameters
function [Tk_2xN]=MT_To_Tk(Input_MTs_6xN)
% The T & k parameters are calculated according to the different types of MT
MTs_Num=size(Input_MTs_6xN,2);
Tk_2xN=zeros(2,MTs_Num);
Inversion_MT=zeros(3,3);
Derivative_M=zeros(3,3);
for i=1:MTs_Num
    Inversion_MT(1,1:3)=Input_MTs_6xN(1:3,i);
    Inversion_MT(2,1)=Input_MTs_6xN(2,i);
    Inversion_MT(2,2:3)=Input_MTs_6xN(4:5,i);
    Inversion_MT(3,1)=Input_MTs_6xN(3,i);
    Inversion_MT(3,2)=Input_MTs_6xN(5,i);
    Inversion_MT(3,3)=Input_MTs_6xN(6,i);
    [M_Vec,M_D]=eig(Inversion_MT);
    Aver_M=(M_D(1,1)+M_D(2,2)+M_D(3,3))/3;
    for j=1:3
        Derivative_M(i,j)=M_D(j,j)-Aver_M;
    end
%     Derivative_M(i,:)=abs(Derivative_M(i,:));
    [Sort_M,Sort_Id]=sort(Derivative_M(i,:),'descend');
    Derivative_M(i,:)=Derivative_M(i,Sort_Id);
    %{
%      Leading Edge March 2010
%      Calculate T
    T_k(1,i)=2*Derivative_M(i,1)/abs(Derivative_M(i,3));
%      Calculate k
    T_k(2,i)=Aver_M/(abs(Aver_M)+abs(Derivative_M(i,3)));
    %}

%     Calculate T
%     Hudson et al. 1989
    if Derivative_M(i,2)>10^-4
        Tk_2xN(1,i)=-2*Derivative_M(i,2)/Derivative_M(i,3);
    elseif abs(Derivative_M(i,3))<=10^-4
        Tk_2xN(1,i)=0;
    else
        Tk_2xN(1,i)=2*Derivative_M(i,2)/Derivative_M(i,1);
    end
%     Calculate k
    if Derivative_M(i,2)>=0
        Tk_2xN(2,i)=Aver_M/(abs(Aver_M)-Derivative_M(i,3));
    end
    if Derivative_M(i,2)<=0
        Tk_2xN(2,i)=Aver_M/(abs(Aver_M)+Derivative_M(i,1));
    end
    %}
end
% End the function
end