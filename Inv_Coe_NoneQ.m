% Calculate the Coefficient Matrix in Frequency Domain
function [G_P,G_S,Ricker_Efficient_Value_Idx]=...
    Inv_Coe_NoneQ(Direction_Cosin,Rho,Vp,Vs,Qp_Err,Qs_Err,SR_Vec_model,...
    Layer_Num,Ricker_Derivative,Sample_Interval,ELayerTime_SR)

% Inversion schedul: d=Am+n
Ricker_DerL=size(Ricker_Derivative,2);
[Com,Rec_Num]=size(Direction_Cosin);
P_A=zeros(3*Rec_Num,6);
S_A=zeros(3*Rec_Num,6);
for i=1:Rec_Num
%     Generate the P-wave coefficient
    P_A11=Direction_Cosin(1,i)^3;
    P_A12=2*Direction_Cosin(1,i)^2*Direction_Cosin(2,i);
    P_A13=2*Direction_Cosin(1,i)^2*Direction_Cosin(3,i);
    P_A14=Direction_Cosin(1,i)*Direction_Cosin(2,i)^2;
    P_A15=2*Direction_Cosin(1,i)*Direction_Cosin(2,i)*Direction_Cosin(3,i);
    P_A16=Direction_Cosin(1,i)*Direction_Cosin(3,i)^2;
    
    P_A(3*(i-1)+1,:)=[P_A11 P_A12 P_A13 P_A14 P_A15 P_A16]/(4*pi*Rho*Vp^3*SR_Vec_model(i));
    
    
    P_A21=Direction_Cosin(1,i)^2*Direction_Cosin(2,i);
    P_A22=2*Direction_Cosin(1,i)*Direction_Cosin(2,i)^2;
    P_A23=2*Direction_Cosin(1,i)*Direction_Cosin(2,i)*Direction_Cosin(3,i);
    P_A24=Direction_Cosin(2,i)^3;
    P_A25=2*Direction_Cosin(2,i)^2*Direction_Cosin(3,i);
    P_A26=Direction_Cosin(2,i)*Direction_Cosin(3,i)^2;
    
    P_A(3*(i-1)+2,:)=[P_A21 P_A22 P_A23 P_A24 P_A25 P_A26]/(4*pi*Rho*Vp^3*SR_Vec_model(i));
    
    
    P_A31=Direction_Cosin(1,i)^2*Direction_Cosin(3,i);
    P_A32=2*Direction_Cosin(1,i)*Direction_Cosin(2,i)*Direction_Cosin(3,i);
    P_A33=2*Direction_Cosin(1,i)*Direction_Cosin(3,i)^2;
    P_A34=Direction_Cosin(2,i)^2*Direction_Cosin(3,i);
    P_A35=2*Direction_Cosin(2,i)*Direction_Cosin(3,i)^2;
    P_A36=Direction_Cosin(3,i)^3;
    
    P_A(3*(i-1)+3,:)=[P_A31 P_A32 P_A33 P_A34 P_A35 P_A36]/(4*pi*Rho*Vp^3*SR_Vec_model(i));
    
%     Generate the S wave coefficient
%     Generate the first line of S-wave matrix A
    S_A11=Direction_Cosin(1,i)^3-Direction_Cosin(1,i);
    S_A12=2*Direction_Cosin(1,i)^2*Direction_Cosin(2,i)-Direction_Cosin(2,i);
    S_A13=2*Direction_Cosin(1,i)^2*Direction_Cosin(3,i)-Direction_Cosin(3,i);
    S_A14=Direction_Cosin(1,i)*Direction_Cosin(2,i)^2;
    S_A15=2*Direction_Cosin(1,i)*Direction_Cosin(2,i)*Direction_Cosin(3,i);
    S_A16=Direction_Cosin(1,i)*Direction_Cosin(3,i)^2;
    
    S_A(3*(i-1)+1,:)=-[S_A11 S_A12 S_A13 S_A14 S_A15 S_A16]/(4*pi*Rho*Vs^3*SR_Vec_model(i));
%     Generate the second line of S-wave matrix A
    S_A21=Direction_Cosin(1,i)^2*Direction_Cosin(2,i);
    S_A22=2*Direction_Cosin(1,i)*Direction_Cosin(2,i)^2-Direction_Cosin(1,i);
    S_A23=2*Direction_Cosin(1,i)*Direction_Cosin(2,i)*Direction_Cosin(3,i);
    S_A24=Direction_Cosin(2,i)^3-Direction_Cosin(2,i);
    S_A25=2*Direction_Cosin(2,i)^2*Direction_Cosin(3,i)-Direction_Cosin(3,i);
    S_A26=Direction_Cosin(2,i)*Direction_Cosin(3,i)^2;
    
    S_A(3*(i-1)+2,:)=-[S_A21 S_A22 S_A23 S_A24 S_A25 S_A26]/(4*pi*Rho*Vs^3*SR_Vec_model(i));
%     Generate the second line of S-wave matrix A
    S_A31=Direction_Cosin(1,i)^2*Direction_Cosin(3,i);
    S_A32=2*Direction_Cosin(1,i)*Direction_Cosin(2,i)*Direction_Cosin(3,i);
    S_A33=2*Direction_Cosin(1,i)*Direction_Cosin(3,i)^2-Direction_Cosin(1,i);
    S_A34=Direction_Cosin(2,i)^2*Direction_Cosin(3,i);
    S_A35=2*Direction_Cosin(2,i)*Direction_Cosin(3,i)^2-Direction_Cosin(2,i);
    S_A36=Direction_Cosin(3,i)^3-Direction_Cosin(3,i);
    
    S_A(3*(i-1)+3,:)=-[S_A31 S_A32 S_A33 S_A34 S_A35 S_A36]/(4*pi*Rho*Vs^3*SR_Vec_model(i));
end

% Generate the G matrix (Version 1.0)
%{
G_P=zeros(Rec_Num*L*Com,6);
G_S=zeros(Rec_Num*L*Com,6);

for i=1:Rec_Num
    for j=1:L
        s1=(i-1)*3+1;
        e1=i*3;
        s2=(i*j-1)*3+1;
        e2=i*j*3;
        G_P(s2:e2,:)=P_A(s1:e1,:)*Ricker_Derivative(j);
        G_S(s2:e2,:)=S_A(s1:e1,:)*Ricker_Derivative(j);
    end
end
%}

% Generate the G matrix with error Q value 2015-6-1 %
% Basic FFT parameters
Max_F=0.5/Sample_Interval;
FFT_F=zeros(1,Ricker_DerL);
F_N=Ricker_DerL/2;
FFT_F(1:F_N+1)=0:Max_F/(F_N):Max_F;
FFT_F(F_N+2:Ricker_DerL)=FFT_F(F_N:-1:2);

Ricker_FFT=fft(Ricker_Derivative);
Ricker_Abs=abs(Ricker_FFT);
Ricker_Efficient=0.5*max(Ricker_Abs);

Ricker_Efficient_Value_Idx=find(Ricker_Abs>=Ricker_Efficient);
Eff_Ricker_L=size(Ricker_Efficient_Value_Idx,2);
G_P=zeros(Rec_Num*Eff_Ricker_L*Com,6);
G_S=zeros(Rec_Num*Eff_Ricker_L*Com,6);

for i=1:Rec_Num
    s1=(i-1)*3+1;
    e1=i*3;
    %  According to the travel time of every layer, add the attenuation
    %  layer by layer 2015-6-1 %
    for m=1:Layer_Num(i)
        % Using FFT and IFFT to add attenuation 2015-6-1 %
        Ricker_FFT_Qp_Att=real(Ricker_FFT).*exp(-pi*FFT_F*ELayerTime_SR(i,m,1)/Qp_Err(m))+...
            imag(Ricker_FFT).*exp(-pi*FFT_F*ELayerTime_SR(i,m,1)/Qp_Err(m))*1i;
        Ricker_FFT_Qs_Att=real(Ricker_FFT).*exp(-pi*FFT_F*ELayerTime_SR(i,m,2)/Qs_Err(m))+...
            imag(Ricker_FFT).*exp(-pi*FFT_F*ELayerTime_SR(i,m,2)/Qp_Err(m))*1i;
    end
    
    for j=1:Eff_Ricker_L
        s2=(i-1)*Eff_Ricker_L*Com+(j-1)*3+1;
        e2=(i-1)*Eff_Ricker_L*Com+(j-1)*3+3;
        
%         G_P(s2:e2,:)=P_A(s1:e1,:)*real(Ricker_FFT_Qp_Att(Ricker_Efficient_Value_Idx(j)));
%         G_S(s2:e2,:)=S_A(s1:e1,:)*real(Ricker_FFT_Qs_Att(Ricker_Efficient_Value_Idx(j)));
        G_P(s2:e2,:)=P_A(s1:e1,:)*real(Ricker_FFT(Ricker_Efficient_Value_Idx(j)));
        G_S(s2:e2,:)=S_A(s1:e1,:)*real(Ricker_FFT(Ricker_Efficient_Value_Idx(j)));
    end
end