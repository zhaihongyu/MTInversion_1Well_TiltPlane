%% Decompose the moment tensor and return the percentage of basic MT
% The input moment tensor must be 3*3 
function [MTs_Percentage]=Decompose_MT(MTs_6xN)
% Get the basic parameters
MTs_Num=size(MTs_6xN,2);
MTs_Percentage=zeros(MTs_Num,3);
for i=1:MTs_Num
    MT=[MTs_6xN(1:3,i)';...
        MTs_6xN(2,i),MTs_6xN(4:5,i)';...
        MTs_6xN(3,i),MTs_6xN(5,i),MTs_6xN(6,i)];
    % Calculate the eigenvalues and eigenvectors
    [MT_Eigenvector,MT_Eigenvalue]=eig(MT);
    % Reset the eigenvalues and eigenvectors in descend oeder
    [M_123]=sort([MT_Eigenvalue(1,1),MT_Eigenvalue(2,2),MT_Eigenvalue(3,3)],'descend');
    % Calculate the percentage of basic MT
    M_ISO=1/3*sum(M_123);
    M_CLVD=2/3*(M_123(1)+M_123(3)-2*M_123(2));
    M_DC=1/2*(M_123(1)-M_123(3)-abs(M_123(1)+M_123(3)-2*M_123(2)));
    M_Total=abs(M_ISO)+abs(M_CLVD)+M_DC;
    MT_Percentage=[M_ISO,M_CLVD,M_DC]/M_Total;
    
    MTs_Percentage(i,:)=MT_Percentage;
end
% End the function
end