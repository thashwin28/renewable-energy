clear
clc
close all

Vbati=[];
SOCi=[];

for I1=5:1:5
t1=7;
SOC1=.2;
K=.8;
D=1e-5;
SOCm=936;
ns=6;
SOC2=SOC1;

for t=0:.1:t1
B=SOC2;

if (I1<=0) % discharging mode
V1=(1.926+.124*B)*ns;
R1=(.19+.1037/(B-.14))*ns/SOCm;

elseif (I1>0) % charging mode
V1=(2+.148*B)*ns;
R1=(.758+.1309/(1.06-B))*ns/SOCm;
R1=double(R1);
end

syms v;
f1=K*V1*I1-D*SOC2*SOCm;
ee=int((K*V1*I1-D*SOC2*SOCm),v,0,t);
SOC=SOC1+SOCm^(-1)*ee;

SOC2=SOC;

Vbat=V1+I1*R1;
Vbat=double(Vbat);

Vbati=[Vbati;Vbat];

SOC=double(SOC);
SOCi=[SOCi;SOC];

end
end

Vbati
SOCi

plot(Vbati)
figure
plot(SOCi)