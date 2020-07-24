%% Prepare data base
clear all;
clc;

% (1) Define  wavelength range 0.2 um - 20um. Considering increment of
% Length increases with the wavelength, use log10 scale increment here
W_range=[0.2,20];
N=1000;
lambda=(W_range(1)*10.^(linspace(0,log10(W_range(2)/W_range(1)),N)))';
% (2) Convert from spreadsheet to matrix
Ag=raw2mat('mat_Ag.csv',lambda);
Air=ones(N,1);
Al2O3=raw2mat('mat_Al2O3.csv',lambda);
Au=raw2mat('mat_Au.csv',lambda);
BK7=raw2mat('mat_BK7.csv',lambda);
HfO2=raw2mat('mat_HfO2.xlsx',lambda);
MgF2=raw2mat('mat_MgF2.xlsx',lambda);
MgO=raw2mat('mat_MgO.csv',lambda);
SiC=raw2mat('mat_SiC.csv',lambda);
SiN=raw2mat('mat_SiN.xlsx',lambda);
SiO2=raw2mat({'mat_SiO2_short.csv','mat_SiO2_long.csv'},lambda);
TiO2=raw2mat('mat_TiO2.csv',lambda);
ZrO2=raw2mat('mat_ZrO2.csv',lambda);
%% Calculate Emissivity
% Combine to one dataset along lambda,column number is the index
mat=[Ag,Air,Al2O3,Au,BK7,HfO2,MgF2,MgO,SiC,SiN,SiO2,TiO2,ZrO2];
% Ag-1,Air-2,Al2O3-3,Au-4,Bk7-5,HfO2-6,MgF2-7,MgO-8,SiC-9,SiN-10
% SiO2-11,TiO2-12,ZrO2-13
% Define Superstrate, coatings, substrate and coatings' depth
n=[2,7,6,9,7,9,7,1];
d=[3.279,0.64,0.657,1.94,1.337,0.047];
d=-d;
% Define incident angle
M=100;
d_theta=pi/2/M;
theta=0:d_theta:pi/2-d_theta;
[X,Y]=meshgrid(theta,1:N);
% We ignore c0 and u here since they will be cancelled out in reflection
% coefficient
Rs=refs(X,Y,lambda,mat,n,d);
Rp=refp(X,Y,lambda,mat,n,d);
R=1/2*(Rs+Rp);
emis=1-R;
emis_avg=sum(sin(X).*cos(X).*emis.*d_theta,2);
%% Plots
figure()
plot(lambda,emis(:,1))
hold on
plot(lambda,emis_avg)
title('Emissivity @ Normal Incident & Average Emissivity over Solid Angle')
xlabel('Wavelength \lambda(\mum)')
ylabel('Emissivity \epsilon')
legend('Normal Incident','Average')
grid on

figure()
Colormap=surf(rad2deg(X),lambda(Y),emis,'EdgeColor','None','facecolor','interp');
colormap hot
colorbar
view([0 90])
xlabel('Incident Angle \theta(\circ)')
ylabel('Wavelength \lambda(\mum)')
xlim([0,90])
ylim([0.2,20])
title('Emissivity')
%% Supplementary Functions
% ** can combine two files without overlapping, in the future could be 
% used to combine several files with overlapping

% Spreadsheet to a n by 2 matrix that is w;n+i*k format and remove rows
% with duplicates in w to avoid error in interp1, interpolate & extrapolate
% to designated range
function [mat]=raw2mat(raw_mat, lambda)
    raw_mat=string(raw_mat);
    wn=[];
    n=[];
    wk=[];
    k=[];
    for i=1:length(raw_mat)
        mat=readtable(raw_mat(i));
        mat=table2array(mat);
        if(~isa(mat,'double'))
            mat=str2double(mat);
        end
        s=size(mat);
        if(s(2)==2)
            if(any(any(isnan(mat))))
                L=find(isnan(mat(:,1)));
                mat(any(isnan(mat),2),:)=[];
                wn=[wn;mat(1:L-1,1)];
                n=[n;mat(1:L-1,2)];
                wk=[wk;mat(L:end,1)];
                k=[k;mat(L:end,2)];
            else
                L=length(mat);
                wn=[wn;mat(1:L,1)];
                n=[n;mat(1:L,2)];
                wk=[wk;wn];
                k=[k;zeros(L,1)];
            end
        else
            L=length(mat);
            wn=[wn;mat(1:L,1)];
            n=[n;mat(1:L,2)];
            wk=[wk;wn];
            k=[k;mat(1:L,3)];
        end
    end
    [wn,wn_I]=sort(wn);
    n=n(wn_I);
    [wk,wk_I]=sort(wk);
    k=k(wk_I);
    [wn,n]=Duplicates_remover(wn,n);
    [wk,k]=Duplicates_remover(wk,k);
    n=interp1(wn,n,lambda,'spline','extrap');
    k=interp1(wk,k,lambda,'spline','extrap');
    mat=zeros(length(lambda),1);
    mat=n+1i*k;
end

% Remove the duplicated rows
function [w,n]=Duplicates_remover(w,n)
    C=unique(w);
    if(length(w)>length(C))
        row_dup=[];
        for i=1:length(C)
            I=find(w==C(i));
            if(length(I)>=2)
                row_dup=[row_dup,I(2:end)];
            end
        end
        w(row_dup)=[];
        n(row_dup)=[];
    end
end

% Caculate Rs
function Rs=refs(X,Y,lambda,mat,n,d)
    Zs=@(x,y,ni)1./(ni(y).*sqrt(1-sin(x).*sin(x)./ni(y)./ni(y)));
    Zds=Zs(X,Y,mat(:,n(end)));
    K=length(d);
    for i=K:-1:1
        Z0=Zds;
        ni=mat(:,n(i+1));
        Zi=Zs(X,Y,ni);
        nI=ni(Y);
        Cos=sqrt(1-sin(X).*sin(X)./nI./nI);
        kz=2*pi.*nI./lambda(Y).*Cos;
        Zds=Zi.*(Z0+1i.*Zi.*tan(kz.*d(i)))./(Zi+1i.*Z0.*tan(kz.*d(i)));
    end
    n0=mat(:,n(1));
    Z0=Zs(X,Y,n0);
    rs=(Zds-Z0)./(Zds+Z0);
    Rs=rs.*conj(rs);
end

% Calculate Rp
function Rp=refp(X,Y,lambda,mat,n,d)
    Zp=@(x,y,ni)sqrt(1-sin(x).*sin(x)./ni(y)./ni(y))./ni(y);
    Zdp=Zp(X,Y,mat(:,n(end)));
    K=length(d);
    for i=K:-1:1
        Z0=Zdp;
        ni=mat(:,n(i+1));
        Zi=Zp(X,Y,ni);
        nI=ni(Y);
        Cos=sqrt(1-sin(X).*sin(X)./nI./nI);
        kz=2*pi.*nI./lambda(Y).*Cos;
        Zdp=Zi.*(Z0+1i.*Zi.*tan(kz.*d(i)))./(Zi+1i.*Z0.*tan(kz.*d(i)));
    end
    n0=mat(:,n(1));
    Z0=Zp(X,Y,n0);
    rp=(Zdp-Z0)./(Zdp+Z0);
    Rp=rp.*conj(rp);
end