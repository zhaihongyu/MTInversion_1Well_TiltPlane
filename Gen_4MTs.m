% Generate 4 kinds of random basic moment tensor
% According to the random type, decide to generate which kind of random moment tensors.
% Rand_Type=1: generate 4 kinds of pure moment tensors
% Rand_Type=2: genrate 4 kinds of  single random moment tensors
% Rand_Type=3: generate 4 kinds of multiple random moment tensors


function [MTs]=Gen_4MTs(Rand_Type)
% 4 basic seismic moment tensors 2015-4-27 %
M_ISO_Pos=2/3*[1 0 0;0 1 0;0 0 1];
M_ISO_Neg=-2/3*[1 0 0;0 1 0;0 0 1];
M_DC=[1 0 0;0 0 0;0 0 -1];
M_CLVD_Neg=2/3*[1 0 0;0 1 0;0 0 -2];
M_CLVD_Pos=2/3*[2 0 0;0 -1 0;0 0 -1];
% According to the random type, choose different algorithm
switch Rand_Type
    case 1
        %% Generate pure basic moment tensor
        MTs=cell(1,4);
        MTs{1}=[M_ISO_Pos(1,1:3)';M_ISO_Pos(2,2:3)';M_ISO_Pos(3,3)];
        MTs{2}=[M_DC(1,1:3)';M_DC(2,2:3)';M_DC(3,3)];
        MTs{3}=[M_CLVD_Neg(1,1:3)';M_CLVD_Neg(2,2:3)';M_CLVD_Neg(3,3)];
        MTs{4}=[M_CLVD_Pos(1,1:3)';M_CLVD_Pos(2,2:3)';M_CLVD_Pos(3,3)];
    case 2
        %% Generate 4 kinds of single random moment tensor
        MTs=cell(1,4);
        Main_Coe=0.85;
        Rand_ISO=Main_Coe*M_ISO_Pos+0.1*M_DC+0.05*M_CLVD_Pos;
        Rand_DC=Main_Coe*M_DC+0.1*M_ISO_Pos+0.05*M_CLVD_Pos;
        Rand_CLVD_Neg=Main_Coe*M_CLVD_Neg+0.1*M_ISO_Pos*0.05*M_DC;
        Rand_CLVD_Pos=Main_Coe*M_CLVD_Pos+0.1*M_ISO_Neg*0.05*M_DC;
        %Transform Matrix into vector
        MTs{1}=[Rand_ISO(1,1:3)';Rand_ISO(2,2:3)';Rand_ISO(3,3)];
        MTs{2}=[Rand_DC(1,1:3)';Rand_DC(2,2:3)';Rand_DC(3,3)];
        MTs{3}=[Rand_CLVD_Neg(1,1:3)';Rand_CLVD_Neg(2,2:3)';Rand_CLVD_Neg(3,3)];
        MTs{4}=[Rand_CLVD_Pos(1,1:3)';Rand_CLVD_Pos(2,2:3)';Rand_CLVD_Pos(3,3)];
    case 3
        %%  Generate 4 kinds of random moment tensor
        [Random_ISOs_6xN]=Gen_Random_ISO();
        [Random_DCs_6xN]=Gen_Random_DC();
        [Random_NegCLVDs_6xN]=Gen_Random_NegCLVD();
        [Random_PosCLVDs_6xN]=Gen_Random_PosCLVD();
        MTs=cell(1,4);
        MTs{1}=Random_ISOs_6xN;
        MTs{2}=Random_DCs_6xN;
        MTs{3}=Random_NegCLVDs_6xN;
        MTs{4}=Random_PosCLVDs_6xN;
    otherwise
        
end

end