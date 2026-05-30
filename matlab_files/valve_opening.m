close all;
clear;

%% Zadávané hodnoty

N1=450; % Počet segmentů první části potrubí
rho=1000; % kg/m^3
f=0.019;  % Součinitel tření
g=9.81; % m/s^2
f_kol=0.0908;
a=1796.5; % m/s
D=2.64; % m Průměr potrubí
vyska_nadrze = 13.5; 
H_ventil= 3;

T_max = 401; % Délka trvání simulace
C= 0.43; % Parametr ventilu

% Parametry otevírání ventilu
t_start = 20; % sekund
t_trvani = 60; % sekund

Q_start = 0; % m3/s

% Součinitelé ztrát v komíně a koleni
Zk_komin=0.015;
Zk_upadnice=0.015;
Z_kol=0.5;

% Výpočet komínů
N_kominy = 40; % Počet dílků komínu
offset_vyska = 6; % Ofset vizualizace pro hezčí vzhled

%% Geometrie potrubí
% Vektor sklonů v promilích (stoupání je směrem doleva - tj. +) ZAČÁTEK NA KONCI POTRUBÍ

sklon = [0.403, 0.403, 0.403, 0.4, 0.4, 0.4, -0.798, -9.6656, -1000, 0, 1000, 5, 5, 3, 7, 5, 0.25, 0.25, 0.4, -1.1851, ...
         -1.2089, -1000, 0, 1000, 2.5225, 2.5225, 4.02, 2.5225, 2.335, 2.5225, 1.4571, 0.25, 0.25, 0.4];

% Vektor vzdáleností (zase od konce) v metrech

delka = [51074.75-50710.36, 50710.36-48946.54, 48946.54-47639.17, 47639.17-44939.05, ...
         44939.05-39387.24, 39387.24-39287.23, 39287.23-36284.31, 36284.31-31888.42, 56.15, 542.95, 75.15 ...
         31345.47-27384.71, 27384.71-27095.47, 27095.47-27045.47, 27045.47-26995.47, ...
         26995.47-24509.03, 24509.03-20218.71, 20218.71-20154.70, 20154.70-16863.78, ...
         16863.78-15002.07, 15002.07-13071.90, 61.71, 324.94, 61.71, 12746.96-11696.86, 11696.86-11596.86, ...
         11596.86-10577.99, 10577.99-9946.86, 9946.86-9146.86, 9146.86-8446.86, ...
         8446.86-8306.19, 8306.19-5665.04, 5665.04-3407.24, 3407.24-0];

%% Geomtrie terénu nad potrubím

x_kliove_body = [300, 500, 700, 750.83, 900, 1000, 1600, 2100, 2400, 2800, 2950, 3059, 3100, 3450, 3534, 3650, 3800, 3900, 4300, 4800, ...
    5000, 5150, 5500, 5665, 6000, 6500, 6700, 6900, 7400, 7700, 8100, 8700, 9000, 9500, 9850, 10100, 10200, 10300, 10400, 10598, 10900, ...
    11100, 11800, 11950, 12050, 12400, 12700, 12950, 13050, 13300, 13500, 13900, 14200, 14600, 14700, 14800, 15000, 15800, 16200, 16600, 16863, ...
    17100, 17500, 17800, 18000, 18400, 18900, 19400, 19800, 20115, 20500, 20700, 21200, 22000, 22300, 22500, 22700, 23000, 23100, 23400, 24200, ...
    24500, 24700, 25300, 25800, 26400, 26900, 27100, 27500, 27800, 28400, 28800, 29150, 29450, 29900, 30200, 30500, 30900, 31200, 31700, 31900, ...
    32100, 32450, 32800, 33100, 33500, 34000, 34400, 34800, 35200, 35600, 36000, 36500, 36800, 37000, 37300, 37900, 38100, 38600, 39000, 39400, ...
    39650, 39850, 39950, 40300, 40500, 41000, 41400, 41900, 42300, 43200, 43400, 43800, 44000, 44500, 44800, 45150, 45200, 45800, 46000, 46300, ...
    46900, 47100, 47800, 48500, 48950, 49400, 49950, 50200, 50500, 50700, 51100, 51300];
h_klicove_body = [362, 385, 380, 368, 385, 390, 410, 415, 405, 400, 385, 370, 385, 390, 367, 385, 400, 405, 410, 425, ...
    420, 400, 380, 378, 382, 425, 430, 440, 460, 470, 480, 496, 498, 490, 486, 470, 460, 450, 425, 420, 428, ...
    436, 430, 415, 424, 400, 370, 353, 365, 400, 430, 380, 415, 490, 500, 490, 440, 470, 460, 503, 500, ...
    500, 490, 430, 420, 426, 430, 410, 405, 405, 405, 420, 440, 485, 510, 518, 510, 500, 480, 455, 486, ...
    486, 460, 430, 480, 450, 405, 395, 395, 398, 386, 390, 430, 445, 420, 354, 380, 360, 340, 330, 315, ...
    320, 340, 362, 350, 334, 345, 360, 370, 380, 400, 410, 400, 430, 420, 375, 390, 392, 410, 395, 375, ...
    375, 375, 375, 380, 400, 420, 436, 438, 450, 456, 464, 460, 452, 444, 428, 425, 425, 422, 412, 420, ...
    390, 380, 382, 378, 373, 373, 370, 366, 356, 342, 340, 332];

%% Výchozí parametry

% První část mezi nádrží a komínem K2
L1=5665.04; %m
A=pi*D^2/4;

% Komín K2
D_K2 = 0.4; %m
A_K2 = pi*D_K2^2/4; 

% Druhá část mezi komínem K2 a komínem K3
L2=4912.95; %m

% Komín K3
D_K3 = 1.6; %m
A_K3 = pi*D_K3^2/4; 

% Třetí část mezi komínem K3 a Blanicí
L3 = 12746.96-10577.99; %m

% Čtvrtá část podtok pod Blanicí
L41 = 61.71; %m dolů
L42 = 324.94; %m vodorovně
L43 = 61.71; %m nahoru

D_4 = 2.6; %m
A_4 = pi*D_4^2/4; 

% Pátá část mezi Blanicí a komínem K5
L5 = 16863.78-13071.90; %m

% Komín K5
D_K5 = 0.8; %m Odhad, z výkresu není zřejmé 
A_K5 = pi*D_K5^2/4;

% Šestá část mezi komínem K5 a úpadnicí Křešice
L6 = 20218.71-16863.78; %m

% Úpadnice Křešice
D_K6 = 5; %m
alpha6 = 30.2*pi/180; %rad
a6 = D_K6/(sin(alpha6)*2); % Hlavní poloosa
b6 = D_K6/2; % Vedlejší poloosa
A_K6 = pi*a6*b6; % Vodorovná plocha

% Sedmá část mezi úpadnicí Křešice a komínem K8
L7 = 27384.71-20218.71; %m

% Komín K8
D_K8 = 0.8; %m  Odhad, z výkresu není zřejmé 
A_K8 = pi*D_K8^2/4; 

% Osmá část mezi komínem K8 a Sázavou
L8 = 31345.47-27384.71; %m

% Devátá část podtok pod Sázavou
L91 = 75.15; %m Dolů
L92 = 542.95; %m Vodorovně
L93 = 56.15; %m Nahoru

D_9 = 2.6; %m
A_9 = pi*D_9^2/4; 

% Desátá část mezi Sázavou a úpadnicí Brtnicí
L10 = 39387.24-31888.42; %m

% Úpadnice Brtnice
D_K11 = 5; %m
alpha11 = 24.8*pi/180; %rad
a11 = D_K11/(sin(alpha11)*2); % Hlavní poloosa
b11 = D_K11/2; % Vedlejší poloosa
A_K11 = pi*a11*b11; % Vodorovná plocha

% Jedenáctá část mezi úpadnicí Brtnicí a komínem Čenětice (ozn. K12)
L11 = 44939.05-39387.24; %m

% Komín Čenětice
D_K12 = 0.4; %m  
A_K12 = pi*D_K12^2/4;

% Dvanáctá část mezi komínem Čenětice a komínem K13
L12 = 48946.54-44939.05; %m

% Komín K13
D_K13 = 2.8; %m  

A_K13 = pi*D_K13^2/4;

% Třináctá část mezi komínem K13 a komínem K14
L13 = 51074.75-48946.54; %m

%% MOC 
B=a/g;
dx = L1/(N1-1);

% První část mezi nádrží a komínem K2
dt = dx / a;
Ndt = 1;
dt_K = dt/Ndt; % Zkrácený časový interval pro výpočet komínů
n = ceil(T_max/dt); % Počet časových kroků zaokrouhlených nahoru
x1 = linspace(0,L1,N1);

% Druhá část mezi komínem K2 a komínem K3 
N2 = round(L2/dx)+1;
L2 = (N2 - 1) * dx; % Zpětně upravená délka, aby seděla na dx pro zachování podmínky pro MOC
x2 = linspace(L1,L1+L2,N2);

% Třetí část mezi komínem K3 a Blanicí
N3 = round(L3/dx)+1;
L3 = (N3 - 1) * dx;
x3 = linspace(L1+L2,L1+L2+L3,N3);

% Čtvrtá část podtok pod Blanicí
N41 = round(L41/dx)+1;
L41 = (N41 - 1) * dx;
x41 = linspace(L1+L2+L3,L1+L2+L3+L41,N41);

N42 = round(L42/dx)+1;
L42 = (N42 - 1) * dx;
x42 = linspace(L1+L2+L3+L41,L1+L2+L3+L41+L42,N42);

N43 = round(L43/dx)+1;
L43 = (N43 - 1) * dx;
x43 = linspace(L1+L2+L3+L41+L42,L1+L2+L3+L41+L42+L43,N43);

N4 = N41 + N42 + N43;
L4 = L41 + L42 + L43;
x4 = [x41 x42 x43];

% Pátá část mezi Blanicí a komínem K5
N5 = round(L5/dx)+1;
L5 = (N5 - 1) * dx;
x5 = linspace(L1+L2+L3+L4,L1+L2+L3+L4+L5,N5);

% Šestá část mezi komínem K5 a úpadnicí Křešice
N6 = round(L6/dx)+1;
L6 = (N6 - 1) * dx;
x6 = linspace(L1+L2+L3+L4+L5,L1+L2+L3+L4+L5+L6,N6);

% Sedmá část mezi úpadnicí Křešice a komínem K8
N7 = round(L7/dx);
L7 = (N7 - 1) * dx;
x7 = linspace(L1+L2+L3+L4+L5+L6,L1+L2+L3+L4+L5+L6+L7,N7);

% Osmá část mezi komínem K8 a Sázavou
N8 = round(L8/dx)+1;
L8 = (N8 - 1) * dx;
x8 = linspace(L1+L2+L3+L4+L5+L6+L7,L1+L2+L3+L4+L5+L6+L7+L8,N8);

% Devátá část podtok pod Sázavou
N91 = round(L91/dx)+1;
L91 = (N91 - 1) * dx;
x91 = linspace(L1+L2+L3+L4+L5+L6+L7+L8,L1+L2+L3+L4+L5+L6+L7+L8+L91,N91);

N92 = round(L92/dx)+1;
L92 = (N92 - 1) * dx;
x92 = linspace(L1+L2+L3+L4+L5+L6+L7+L8+L91,L1+L2+L3+L4+L5+L6+L7+L8+L91+L92,N92);

N93 = round(L93/dx)+1;
L93 = (N93 - 1) * dx;
x93 = linspace(L1+L2+L3++L4+L5+L6+L7+L8+L91+L92,L1+L2+L3+L4+L5+L6+L7+L8+L91+L92+L93,N93);

N9 = N91 + N92 + N93;
L9 = L91 + L92 + L93;
x9 = [x91 x92 x93];

% Desátá část mezi Sázavou a úpadnicí Brtnicí
N10 = round(L10/dx)+1;
L10 = (N10 - 1) * dx;
x10 = linspace(L1+L2+L3+L4+L5+L6+L7+L8+L9,L1+L2+L3+L4+L5+L6+L7+L8+L9+L10,N10);

% Jedenáctá část mezi úpadnicí Brtnicí a komínem Čenětice (ozn. K11)
N11 = round(L11/dx)+1;
L11 = (N11 - 1) * dx;
x11 = linspace(L1+L2+L3+L4+L5+L6+L7+L8+L9+L10,L1+L2+L3+L4+L5+L6+L7+L8+L9+L10+L11,N11);

% Dvanáctá část mezi komínem Čenětice a komínem K13
N12 = round(L12/dx)+1;
L12 = (N12 - 1) * dx;
x12 = linspace(L1+L2+L3+L4+L5+L6+L7+L8+L9+L10+L11,L1+L2+L3+L4+L5+L6+L7+L8+L9+L10+L11+L12,N12);

% Třináctá část mezi komínem K13 a komínem K14
N13 = round(L13/dx)+1;
L13 = (N13 - 1) * dx;
x13 = linspace(L1+L2+L3+L4+L5+L6+L7+L8+L9+L10+L11+L12,L1+L2+L3+L4+L5+L6+L7+L8+L9+L10+L11+L12+L13,N13);

N_pol = N1 + N2 + N3 + N4 + N5 + N6 + N7; % Pro zkrácení indexů v druhé polovině potrubí
x_celk = [x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13];

%% Výška počátku potrubí oproti konci

h_poc = sum(delka .* (sklon / 1000));

%% Určení vektorů zemské výšky

delka_od_zacatku = fliplr(delka);
sklon_od_zacatku = fliplr(sklon);

U = round(delka_od_zacatku / dx);

pocet_useku = length(U);
Hz_usek = cell(1, pocet_useku);

h_start = h_poc;

for k = 1:pocet_useku
    Hz_usek{k} = zeros(1, U(k)+1);
    Hz_usek{k}(1) = h_start;

    for i = 2:U(k)+1
        Hz_usek{k}(i) = Hz_usek{k}(i-1) - sklon_od_zacatku(k)/1000*dx;
    end

    h_start = Hz_usek{k}(end);
end

casti = {[1 2], [3 4 5 6 7], [8, 9, 10], 11, 12, 13, [14 15], [16 17], [18 19 20 21 22], 23, 24, 25, 26, [27, 28, 29],...
         30, [31, 32], [33, 34]}; 
% Hz1 = úseky 1-2, Hz2 = úseky 3–7 atd. 

Hz = cell(1, length(casti)); 

for c = 1:length(casti)
    idx = casti{c};

    Hz{c} = Hz_usek{idx(1)};
    for j = 2:length(idx)
        Hz{c} = [Hz{c}, Hz_usek{idx(j)}(2:end)];
    end
end

Hz1 = Hz{1}; Hz2 = Hz{2}; Hz3 = Hz{3}; Hz41 = Hz{4}; Hz42 = Hz{5}; Hz43 = Hz{6}; Hz5 = Hz{7}; Hz6 = Hz{8}; Hz7 = Hz{9}; 
Hz8 = Hz{10}; Hz91 = Hz{11}; Hz92 = Hz{12}; Hz93 = Hz{13}; Hz10 = Hz{14}; Hz11 = Hz{15}; Hz12 = Hz{16}; Hz13 = Hz{17};

Hz=[Hz1 Hz2 Hz3 Hz41 Hz42 Hz43 Hz5 Hz6 Hz7 Hz8 Hz91 Hz92 Hz93 Hz10 Hz11 Hz12 Hz13];

%% Okrajové a počáteční podmínky

Q = zeros(n,N_pol+N8+N9+N10+N11+N12+N13);
% OP pro průtok nutno dopočítat

% OP pro piezometrickou výšku jsou fixní
Hp = zeros(n,N_pol+N8+N9+N10+N11+N12+N13);
Hp(:,1)= vyska_nadrze*ones(n,1);
Hp(1,:)=Hz(1)+vyska_nadrze-Hz(:);

H=zeros(n,N_pol+N8+N9+N10+N11+N12+N13);
H(1,2:end)=Hp(1,2:end)+Hz(2:end); 
H(:,1)=Hp(:,1)+Hz(1);

% Počáteční podmínky
Q(1,:) = Q_start*ones(1,N_pol+N8+N9+N10+N11+N12+N13);
dH=-B/A*dt*f/(D*A)*Q(1,1)*abs(Q(1,1))/2;
H_start = Hz(1) + vyska_nadrze;
H(1,2:end) = H_start + cumsum(ones(1,N_pol+N8+N9+N10+N11+N12+N13-1)*dH);

% Výšky hladin v komínech
Hk2=zeros(n,1);
Hk2(1,1)=Hz(1)+vyska_nadrze;
Hk3=zeros(n,1);
Hk3(1,1)=Hz(1)+vyska_nadrze;
Hk5=zeros(n,1);
Hk5(1,1)=Hz(1)+vyska_nadrze;
Hk6=zeros(n,1);
Hk6(1,1)=Hz(1)+vyska_nadrze;
Hk8=zeros(n,1);
Hk8(1,1)=Hz(1)+vyska_nadrze;
Hk11=zeros(n,1);
Hk11(1,1)=Hz(1)+vyska_nadrze;
Hk12=zeros(n,1);
Hk12(1,1)=Hz(1)+vyska_nadrze;
Hk13=zeros(n,1);
Hk13(1,1)=Hz(1)+vyska_nadrze;

% Pomocné proměnné pro přetečení
Qk11_preteceny_total=0;
Qk12_preteceny_total=0;
Qk13_preteceny_total=0;
Qk11_preteceny_vector=zeros(1,n);
Qk12_preteceny_vector=zeros(1,n);
Qk13_preteceny_vector=zeros(1,n);

% Pomocné proměnné pro podtlak
Hk11_podtlak = zeros(1,n);
Hk12_podtlak = zeros(1,n);
Hk13_podtlak = zeros(1,n);

%% Výpočet

for j = 1 : n-1
 time=j*dt

 Hp(j,:) = H(j,:)-Hz;

 % Podmínka nádrž nalevo
         Q(j+1,1)=Q(j,2)+A/B*(H(j,1)-H(j,2))-dt*f/(2*A*D)*Q(j,2)*abs(Q(j,2));

 % Podmínka komín K2   
         res2= [Q(j,N1); Q(j,N1+1); Hk2(j); H(j,N1)]; % průtok zleva, průtok zprava, výška v komíně, výška v uzlu
         C_plus2  = Q(j,N1-1) + A/B * H(j,N1-1) - dt_K*f/(2*A*D)*Q(j,N1-1)*abs(Q(j,N1-1));
         C_minus2 = Q(j,N1+2) - A/B * H(j,N1+2) - dt_K*f/(2*A*D)*Q(j,N1+2)*abs(Q(j,N1+2));
         
         M = [1, 0, 0, A/B; 
             0, 1, 0, -A/B; 
             -dt_K/A_K2, dt_K/A_K2, 1, 0; 
             0, 0, -1, 1];
         
         for k = 1:Ndt
             Qk2 = res2(1) - res2(2);
         
             b = [C_plus2; 
                  C_minus2; 
                  res2(3); 
                  (Zk_komin/(2*g*A_K2^2)) * Qk2 * abs(Qk2)];
         
             res2 = M\b; 
         end
         
         Q(j+1, N1)     = res2(1);
         Q(j+1, N1+1)   = res2(2);
         Hk2(j+1)       = res2(3);
         H(j+1, N1) = res2(4);
         H(j+1, N1+1) = res2(4);

% Podmínka komín K3
         res3= [Q(j,N1+N2); Q(j,N1+N2+1); Hk3(j); H(j,N1+N2)]; % průtok zleva, průtok zprava, výška v komíně, výška v uzlu
         C_plus3  = Q(j,N1+N2-1) + A/B * H(j,N1+N2-1) - dt_K*f/(2*A*D)*Q(j,N1+N2-1)*abs(Q(j,N1+N2-1));
         C_minus3 = Q(j,N1+N2+2) - A/B * H(j,N1+N2+2) - dt_K*f/(2*A*D)*Q(j,N1+N2+2)*abs(Q(j,N1+N2+2));
         
         M = [1, 0, 0, A/B; 
             0, 1, 0, -A/B; 
             -dt_K/A_K3, dt_K/A_K3, 1, 0; 
             0, 0, -1, 1];
         
         for k = 1:Ndt
             Qk3 = res3(1) - res3(2);
         
             b = [C_plus3; 
                  C_minus3; 
                  res3(3); 
                  (Zk_komin/(2*g*A_K3^2)) * Qk3 * abs(Qk3)];
         
             res3 = M\b; 
         end
         
         Q(j+1, N1+N2)     = res3(1);
         Q(j+1, N1+N2+1)   = res3(2);
         Hk3(j+1)       = res3(3);
         H(j+1, N1+N2) = res3(4);
         H(j+1, N1+N2+1) = res3(4);

  % Podmínka komín K5
         res5= [Q(j,N1+N2+N3+N4+N5); Q(j,N1+N2+N3+N4+N5+1); Hk5(j); H(j,N1+N2+N3+N4+N5)]; % průtok zleva, průtok zprava, výška v komíně, výška v uzlu
         C_plus5  = Q(j,N1+N2+N3+N4+N5-1) + A/B * H(j,N1+N2+N3+N4+N5-1) - dt_K*f/(2*A*D)*Q(j,N1+N2+N3+N4+N5-1)*abs(Q(j,N1+N2+N3+N4+N5-1));
         C_minus5 = Q(j,N1+N2+N3+N4+N5+2) - A/B * H(j,N1+N2+N3+N4+N5+2) - dt_K*f/(2*A*D)*Q(j,N1+N2+N3+N4+N5+2)*abs(Q(j,N1+N2+N3+N4+N5+2));
         
         M = [1, 0, 0, A/B; 
             0, 1, 0, -A/B; 
             -dt_K/A_K5, dt_K/A_K5, 1, 0; 
             0, 0, -1, 1];
         
         for k = 1:Ndt
             Qk5 = res5(1) - res5(2);
         
             b = [C_plus5; 
                  C_minus5; 
                  res5(3); 
                  (Zk_komin/(2*g*A_K5^2)) * Qk5 * abs(Qk5)];
         
             res5 = M\b; 
         end
         
         Q(j+1, N1+N2+N3+N4+N5)     = res5(1);
         Q(j+1, N1+N2+N3+N4+N5+1)   = res5(2);
         Hk5(j+1)       = res5(3);
         H(j+1, N1+N2+N3+N4+N5) = res5(4);
         H(j+1, N1+N2+N3+N4+N5+1) = res5(4);

 % Podmínka úpadnice Křečice
         res6= [Q(j,N1+N2+N3+N4+N5+N6); Q(j,N1+N2+N3+N4+N5+N6+1); Hk6(j); H(j,N1+N2+N3+N4+N5+N6)]; % průtok zleva, průtok zprava, výška v komíně, výška v uzlu
         C_plus6  = Q(j,N1+N2+N3+N4+N5+N6-1) + A/B * H(j,N1+N2+N3+N4+N5+N6-1) - dt_K*f/(2*A*D)*Q(j,N1+N2+N3+N4+N5+N6-1)*abs(Q(j,N1+N2+N3+N4+N5+N6-1));
         C_minus6 = Q(j,N1+N2+N3+N4+N5+N6+2) - A/B * H(j,N1+N2+N3+N4+N5+N6+2) - dt_K*f/(2*A*D)*Q(j,N1+N2+N3+N4+N5+N6+2)*abs(Q(j,N1+N2+N3+N4+N5+N6+2));
         
         M = [1, 0, 0, A/B; 
             0, 1, 0, -A/B; 
             -dt_K/A_K6, dt_K/A_K6, 1, 0; 
             0, 0, -1, 1];
         
         for k = 1:Ndt
             Qk6 = res6(1) - res6(2);
         
             b = [C_plus6; 
                  C_minus6; 
                  res6(3); 
                  (Zk_komin/(2*g*A_K6^2)) * Qk6 * abs(Qk6)];
         
             res6 = M\b; 
         end
         
         Q(j+1, N1+N2+N3+N4+N5+N6)     = res6(1);
         Q(j+1, N1+N2+N3+N4+N5+N6+1)   = res6(2);
         Hk6(j+1)       = res6(3);
         H(j+1, N1+N2+N3+N4+N5+N6) = res6(4);
         H(j+1, N1+N2+N3+N4+N5+N6+1) = res6(4);

  % Podmínka komín K8
         res8= [Q(j,N_pol); Q(j,N_pol+1); Hk8(j); H(j,N_pol)]; % průtok zleva, průtok zprava, výška v komíně, výška v uzlu
         C_plus8  = Q(j,N_pol-1) + A/B * H(j,N_pol-1) - dt_K*f/(2*A*D)*Q(j,N_pol-1)*abs(Q(j,N_pol-1));
         C_minus8 = Q(j,N_pol+2) - A/B * H(j,N_pol+2) - dt_K*f/(2*A*D)*Q(j,N_pol+2)*abs(Q(j,N_pol+2));
         
         M = [1, 0, 0, A/B; 
             0, 1, 0, -A/B; 
             -dt_K/A_K8, dt_K/A_K8, 1, 0; 
             0, 0, -1, 1];
         
         for k = 1:Ndt
             Qk8 = res8(1) - res8(2);
         
             b = [C_plus8; 
                  C_minus8; 
                  res8(3); 
                  (Zk_komin/(2*g*A_K8^2)) * Qk8 * abs(Qk8)];
         
             res8 = M\b; 
         end
         
         Q(j+1, N_pol)     = res8(1);
         Q(j+1, N_pol+1)   = res8(2);
         Hk8(j+1)       = res8(3);
         H(j+1, N_pol) = res8(4);
         H(j+1, N_pol+1) = res8(4);

  % Podmínka úpadnice Brtnice
         h11_max = 41.1;
         res11= [Q(j,N_pol+N8+N9+N10); Q(j,N_pol+N8+N9+N10+1); Hk11(j); H(j,N_pol+N8+N9+N10)]; % průtok zleva, průtok zprava, výška v komíně, výška v uzlu
         C_plus11  = Q(j,N_pol+N8+N9+N10-1) + A/B * H(j,N_pol+N8+N9+N10-1) - dt_K*f/(2*A*D)*Q(j,N_pol+N8+N9+N10-1)*abs(Q(j,N_pol+N8+N9+N10-1));
         C_minus11 = Q(j,N_pol+N8+N9+N10+2) - A/B * H(j,N_pol+N8+N9+N10+2) - dt_K*f/(2*A*D)*Q(j,N_pol+N8+N9+N10+2)*abs(Q(j,N_pol+N8+N9+N10+2));
         
         if res11(3) >= h11_max
             Qk11_preteceny = Qk11*dt_K;
             Qk11_preteceny_total = Qk11_preteceny_total + Qk11_preteceny;

             M = [1, 0, 0, A/B; 
                  0, 1, 0, -A/B; 
                  -dt_K/A_K11, dt_K/A_K11, 1, 0; 
                  0, 0, 0, 1];
            
             for k = 1:Ndt
                 Qk11 = res11(1) - res11(2);
                
                 b = [C_plus11; 
                      C_minus11; 
                      h11_max; 
                      (Zk_komin/(2*g*A_K11^2)) * Qk11 * abs(Qk11) + h11_max];
            
                 res11 = M\b; 
             end

         elseif res11(3) <= Hz(N_pol+N8+N9+N10)
             Hk11_podtlak(j) = 1;

             M = [1, 0, 0, A/B; 
                  0, 1, 0, -A/B; 
                  -dt_K/A_K11, dt_K/A_K11, 1, 0; 
                  0, 0, 0, 1];
            
             for k = 1:Ndt
                 Qk11 = res11(1) - res11(2);
                 
                 b = [C_plus11; 
                      C_minus11; 
                      0; 
                      (Zk_komin/(2*g*A_K11^2)) * Qk11 * abs(Qk11)];
            
                 res11 = M\b; 
             end
         else    

            M = [1, 0, 0, A/B; 
                0, 1, 0, -A/B; 
                -dt_K/A_K11, dt_K/A_K11, 1, 0; 
                0, 0, -1, 1];
            
            for k = 1:Ndt
                Qk11 = res11(1) - res11(2);
                
                b = [C_plus11; 
                     C_minus11; 
                     res11(3); 
                     (Zk_komin/(2*g*A_K11^2)) * Qk11 * abs(Qk11)];
            
                res11 = M\b; 
            end
         end

         Qk11_preteceny_vector(j) = Qk11_preteceny_total;
                  
         Q(j+1, N_pol+N8+N9+N10)     = res11(1);
         Q(j+1, N_pol+N8+N9+N10+1)   = res11(2);
         Hk11(j+1)       = res11(3);
         H(j+1, N_pol+N8+N9+N10) = res11(4);
         H(j+1, N_pol+N8+N9+N10+1) = res11(4);

 % Podmínka komín Čenětice
         h12_max = 92.8;
         res12= [Q(j,N_pol+N8+N9+N10+N11); Q(j,N_pol+N8+N9+N10+N11+1); Hk12(j); H(j,N_pol+N8+N9+N10+N11)]; % průtok zleva, průtok zprava, výška v komíně, výška v uzlu
         C_plus16  = Q(j,N_pol+N8+N9+N10+N11-1) + A/B * H(j,N_pol+N8+N9+N10+N11-1) - dt_K*f/(2*A*D)*Q(j,N_pol+N8+N9+N10+N11-1)*abs(Q(j,N_pol+N8+N9+N10+N11-1));
         C_minus16 = Q(j,N_pol+N8+N9+N10+N11+2) - A/B * H(j,N_pol+N8+N9+N10+N11+2) - dt_K*f/(2*A*D)*Q(j,N_pol+N8+N9+N10+N11+2)*abs(Q(j,N_pol+N8+N9+N10+N11+2));
         
         if res12(3) >= h12_max
             Qk13_preteceny = Qk12*dt_K;
             Qk12_preteceny_total = Qk12_preteceny_total + Qk12_preteceny;
             
             M = [1, 0, 0, A/B; 
                  0, 1, 0, -A/B; 
                  -dt_K/A_K12, dt_K/A_K12, 1, 0; 
                  0, 0, 0, 1];
            
             for k = 1:Ndt
                 Qk12 = res12(1) - res12(2);
                 
                 b = [C_plus16; 
                      C_minus16; 
                      h12_max; 
                      (Zk_komin/(2*g*A_K12^2)) * Qk12 * abs(Qk12) + h12_max];
            
                 res12 = M\b; 
             end

         elseif res12(3) <= Hz(N_pol+N8+N9+N10+N11)
             Hk12_podtlak(j) = 1;

             M = [1, 0, 0, A/B; 
                  0, 1, 0, -A/B; 
                  -dt_K/A_K12, dt_K/A_K12, 1, 0; 
                  0, 0, 0, 1];
            
             for k = 1:Ndt
                 Qk12 = res12(1) - res12(2);
                 
                 b = [C_plus16; 
                      C_minus16; 
                      0; 
                      (Zk_komin/(2*g*A_K12^2)) * Qk12 * abs(Qk12)];
            
                 res12 = M\b; 
             end
         else    
            M = [1, 0, 0, A/B; 
                0, 1, 0, -A/B; 
                -dt_K/A_K12, dt_K/A_K12, 1, 0; 
                0, 0, -1, 1];
            
            for k = 1:Ndt
                Qk12 = res12(1) - res12(2);
                
                b = [C_plus16; 
                     C_minus16; 
                     res12(3); 
                     (Zk_komin/(2*g*A_K12^2)) * Qk12 * abs(Qk12)];
            
                res12 = M\b; 
            end
         end

         Qk12_preteceny_vector(j) = Qk12_preteceny_total;
                  
         Q(j+1, N_pol+N8+N9+N10+N11)     = res12(1);
         Q(j+1, N_pol+N8+N9+N10+N11+1)   = res12(2);
         Hk12(j+1)       = res12(3);
         H(j+1, N_pol+N8+N9+N10+N11) = res12(4);
         H(j+1, N_pol+N8+N9+N10+N11+1) = res12(4);

  % Podmínka komín K13
         h13_max = 41;
         res13 = [Q(j,N_pol+N8+N9+N10+N11+N12); Q(j,N_pol+N8+N9+N10+N11+N12+1); Hk13(j); H(j,N_pol+N8+N9+N10+N11+N12)]; % průtok zleva, průtok zprava, výška v komíně, výška v uzlu
         C_plus17  = Q(j,N_pol+N8+N9+N10+N11+N12-1) + A/B * H(j,N_pol+N8+N9+N10+N11+N12-1) - dt_K*f/(2*A*D)*Q(j,N_pol+N8+N9+N10+N11+N12-1)*abs(Q(j,N_pol+N8+N9+N10+N11+N12-1));
         C_minus17 = Q(j,N_pol+N8+N9+N10+N11+N12+2) - A/B * H(j,N_pol+N8+N9+N10+N11+N12+2) - dt_K*f/(2*A*D)*Q(j,N_pol+N8+N9+N10+N11+N12+2)*abs(Q(j,N_pol+N8+N9+N10+N11+N12+2));

         if res13(3) >= h13_max
             Qk13_preteceny = Qk13*dt_K;
             Qk13_preteceny_total = Qk13_preteceny_total + Qk13_preteceny;

             M = [1, 0, 0, A/B; 
                  0, 1, 0, -A/B; 
                  -dt_K/A_K13, dt_K/A_K13, 1, 0; 
                  0, 0, 0, 1];
            
             for k = 1:Ndt
                 Qk13 = res13(1) - res13(2);
                
                 b = [C_plus17; 
                      C_minus17; 
                      h13_max; 
                      (Zk_komin/(2*g*A_K13^2)) * Qk13 * abs(Qk13) + h13_max];
            
                 res13 = M\b; 
             end

         elseif res13(3) <= Hz(N_pol+N8+N9+N10+N11+N12)
             Hk13_podtlak(j) = 1;

             M = [1, 0, 0, A/B; 
                  0, 1, 0, -A/B; 
                  -dt_K/A_K13, dt_K/A_K13, 1, 0; 
                  0, 0, 0, 1];
            
             for k = 1:Ndt
                 Qk13 = res13(1) - res13(2);
                 
                 b = [C_plus17; 
                      C_minus17; 
                      0; 
                      (Zk_komin/(2*g*A_K13^2)) * Qk13 * abs(Qk13)];
            
                 res13 = M\b; 
             end
         else    
            M = [1, 0, 0, A/B; 
                0, 1, 0, -A/B; 
                -dt_K/A_K13, dt_K/A_K13, 1, 0; 
                0, 0, -1, 1];
            
            for k = 1:Ndt
                Qk13 = res13(1) - res13(2);
                
                b = [C_plus17; 
                     C_minus17; 
                     res13(3); 
                     (Zk_komin/(2*g*A_K13^2)) * Qk13 * abs(Qk13)];
            
                res13 = M\b; 
            end
         end

         Qk13_preteceny_vector(j) = Qk13_preteceny_total;
         
         Q(j+1, N_pol+N8+N9+N10+N11+N12)     = res13(1);
         Q(j+1, N_pol+N8+N9+N10+N11+N12+1)   = res13(2);
         Hk13(j+1)       = res13(3);
         H(j+1, N_pol+N8+N9+N10+N11+N12) = res13(4);
         H(j+1, N_pol+N8+N9+N10+N11+N12+1) = res13(4);

 % Podmínka ventil napravo - OTEVÍRÁNÍ 
         if time<10

            Q(j+1,N_pol+N8+N9+N10+N11+N12+N13)=0;
            H(j+1,N_pol+N8+N9+N10+N11+N12+N13)=B/A*(Q(j,N_pol+N8+N9+N10+N11+N12+N13-1) + A/B * H(j,N_pol+N8+N9+N10+N11+N12+N13-1) ...
               - dt*f/(2*A*D)*Q(j,N_pol+N8+N9+N10+N11+N12+N13-1)*abs(Q(j,N_pol+N8+N9+N10+N11+N12+N13-1)));
         
         else
            Cplus_vent = Q(j,N_pol+N8+N9+N10+N11+N12+N13-1) + A/B * H(j,N_pol+N8+N9+N10+N11+N12+N13-1) - dt*f/(2*A*D)*Q(j,N_pol+N8+N9+N10+N11+N12+N13-1)*abs(Q(j,N_pol+N8+N9+N10+N11+N12+N13-1));
            a_q = 1;
            b_q = (C*A)^2*B/A;
            c_q = (C*A)^2*H_ventil - (C*A)^2*B/A*Cplus_vent;
            
            Diskr = b_q^2 - 4*a_q*c_q;

            Q1 = (-b_q + sqrt(Diskr)) / (2 * a_q);
            Q2 = (-b_q - sqrt(Diskr)) / (2 * a_q);
            Q(j+1, N_pol+N8+N9+N10+N11+N12+N13) = max(Q1, Q2);

            H(j+1, N_pol+N8+N9+N10+N11+N12+N13) = B/A*(Cplus_vent-Q(j+1, N_pol+N8+N9+N10+N11+N12+N13));
          end

 % Řešení samotných úseků
    for i = 2 : N1-1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    for i = N1+2 : N1+N2-1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    for i = N1+N2+2 : N1+N2+N3+1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    % První koleno
    i = N1+N2+N3+1;
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A_4*(Q(j, i-1)-Q(j, i+1))-B*dt*f_kol/(2*D_4*A_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A_4/B*(H(j, i-1)-H(j, i+1))-dt*f_kol/(2*D_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    for i = N1+N2+N3+2 : N1+N2+N3+N41+1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A_4*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D_4*A_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A_4/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    % Druhé koleno
    i = N1+N2+N3+N41+1;
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A_4*(Q(j, i-1)-Q(j, i+1))-B*dt*f_kol/(2*D_4*A_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A_4/B*(H(j, i-1)-H(j, i+1))-dt*f_kol/(2*D_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    for i = N1+N2+N3+N41+2 : N1+N2+N3+N41+N42+1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A_4*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D_4*A_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A_4/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    % Třetí koleno
    i = N1+N2+N3+N41+N42+1;
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A_4*(Q(j, i-1)-Q(j, i+1))-B*dt*f_kol/(2*D_4*A_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A_4/B*(H(j, i-1)-H(j, i+1))-dt*f_kol/(2*D_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    for i = N1+N2+N3+N41+N42+2 : N1+N2+N3+N4+1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A_4*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D_4*A_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A_4/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    % Čtvrté koleno
    i = N1+N2+N3+N4+1;
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A_4*(Q(j, i-1)-Q(j, i+1))-B*dt*f_kol/(2*D_4*A_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A_4/B*(H(j, i-1)-H(j, i+1))-dt*f_kol/(2*D_4*A_4)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    for i = N1+N2+N3+N4+2 : N1+N2+N3+N4+N5-1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    for i = N1+N2+N3+N4+N5+2 : N1+N2+N3+N4+N5+N6-1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    for i = N1+N2+N3+N4+N5+N6+2 : N1+N2+N3+N4+N5+N6+N7-1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    for i = N_pol+2 : N_pol+N8+1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    % Páté koleno
    i = N_pol+N8+1;
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f_kol/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f_kol/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    for i = N_pol+N8+2 : N_pol+N8+N91+1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A_9*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D_9*A_9*A_9)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A_9/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D_9*A_9)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    % Šesté koleno
    i = N_pol+N8+N91+1;
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f_kol/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f_kol/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    for i = N_pol+N8+N91+2 : N_pol+N8+N91+N92+1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A_9*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D_9*A_9*A_9)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A_9/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D_9*A_9)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    % Sedmé koleno
    i = N_pol+N8+N91+N92+1;
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f_kol/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f_kol/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    for i = N_pol+N8+N91+N92+2 : N_pol+N8+N9+1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A_9*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D_9*A_9*A_9)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A_9/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D_9*A_9)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    % Osmé koleno
    i = N_pol+N8+N9+1;
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f_kol/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f_kol/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    for i = N_pol+N8+N9+2 : N_pol+N8+N9+N10-1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    for i = N_pol+N8+N9+N10+2 : N_pol+N8+N9+N10+N11-1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    for i = N_pol+N8+N9+N10+N11+2 : N_pol+N8+N9+N10+N11+N12-1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
    for i = N_pol+N8+N9+N10+N11+N12+2 : N_pol+N8+N9+N10+N11+N12+N13-1
         H(j+1,i)=1/2*(H(j, i-1)+H(j, i+1)+B/A*(Q(j, i-1)-Q(j, i+1))-B*dt*f/(2*D*A*A)*(Q(j, i-1)*abs(Q(j, i-1))-Q(j, i+1)*abs(Q(j, i+1))));
         Q(j+1,i)=1/2*(Q(j, i-1)+Q(j, i+1)+A/B*(H(j, i-1)-H(j, i+1))-dt*f/(2*D*A)*(Q(j, i-1)*abs(Q(j, i-1))+Q(j, i+1)*abs(Q(j, i+1))));
    end
end

Hk2=Hk2-Hz(N1);
Hk3=Hk3-Hz(N1+N2);
Hk5=Hk5-Hz(N1+N2+N3+N4+N5);
Hk6=Hk6-Hz(N1+N2+N3+N4+N5+N6);
Hk8=Hk8-Hz(N_pol);
Hk11=Hk11-Hz(N_pol+N8+N9+N10);
Hk12=Hk12-Hz(N_pol+N8+N9+N10+N11);
Hk13=Hk13-Hz(N_pol+N8+N9+N10+N11+N12);

%% Grafické zpracování

s = get(0,'ScreenSize');
h=figure;
set(h,'Position',[5 10 0.99*s(3) 0.9*s(4)],'color',[1 1 1])
box;

% Spodní graf - profil přivaděče s průmětem tlakové výšky
h_subplot_viz = subplot(4,1,[3,4]);
hold on;
grid on;
xlabel('Poloha x [km]');
set(h_subplot_viz, 'xticklabel', {'0', '5', '10', '15', '20', '25', '30', '35', '40', '45', '50'});
title(h_subplot_viz, 'Vizualizace tlakové výšky', 'FontSize', 11);
xlim(h_subplot_viz, [0,L1+L2+L3+L4+L5+L6+L7+L8+L9+L10+L11+L12+L13]);
ylim(h_subplot_viz, [-120, 200]);
text(x_celk(1)+700, Hz(1)+30, 'Začátek přivaděče', 'Rotation', 90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k', 'FontSize', 10);
text(x_celk(N1)+250, Hz(N1)+40, 'Komín K2', 'Rotation', 90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k', 'FontSize', 10);
text(x_celk(N1+N2)-350, Hz(N1+N2)+15, 'Komín K3', 'Rotation', 90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k', 'FontSize', 10);
text(x_celk(N1+N2+N3)+450, Hz(N1+N2+N3)+50, 'Blanice', 'Rotation', 90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k', 'FontSize', 11);
text(x_celk(N1+N2+N3+N4+N5)-350, Hz(N1+N2+N3+N4+N5)+15, 'Komín K5', 'Rotation', 90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k', 'FontSize', 10);
text(x_celk(N1+N2+N3+N4+N5+N6)+200, Hz(N1+N2+N3+N4+N5+N6)+70, 'Úpadnice Křečice', 'Rotation', 90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k', 'FontSize', 10);
text(x_celk(N_pol)+250, Hz(N_pol)+90, 'Komín K8', 'Rotation', 90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k', 'FontSize', 10);
text(x_celk(N_pol+N8)+750, Hz(N_pol+N8)+35, 'Sázava', 'Rotation', 90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k', 'FontSize', 11);
text(x_celk(N_pol+N8+N9+N10)+450, Hz(N_pol+N8+N9+N10)+70, 'Úpadnice Brtnice', 'Rotation', 90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k', 'FontSize', 10);
text(x_celk(N_pol+N8+N9+N10+N11)-400, Hz(N_pol+N8+N9+N10+N11)+12, 'Komín Čenětice', 'Rotation', 90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k', 'FontSize', 10);
text(x_celk(N_pol+N8+N9+N10+N11+N12)+250, Hz(N_pol+N8+N9+N10+N11+N12)+55, 'Komín K13', 'Rotation', 90, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', 'k', 'FontSize', 10);

% Indikace přetečení a podtlaku
QK11_text = text(x_celk(N_pol+N8+N9+N10), h11_max - 90, {'Přetečeno:', '0 m^3'}, 'Color', 'k', 'BackgroundColor', 'w', 'EdgeColor', 'r', 'LineWidth', 2, 'HorizontalAlignment', 'center','FontSize', 11);
QK12_text = text(x_celk(N_pol+N8+N9+N10+N11), h12_max - 150, {'Přetečeno:', '0 m^3'}, 'Color', 'k', 'BackgroundColor', 'w', 'EdgeColor', 'r', 'LineWidth', 2, 'HorizontalAlignment', 'center','FontSize', 11);
QK13_text = text(x_celk(N_pol+N8+N9+N10+N11+N12), h13_max - 90, {'Přetečeno:', '0 m^3'}, 'Color', 'k', 'BackgroundColor', 'w', 'EdgeColor', 'r', 'LineWidth', 2, 'HorizontalAlignment', 'center','FontSize', 11);
Hk11_podtlak_text = text(x_celk(N_pol+N8+N9+N10), h11_max - 135, {'Vzniká podtlak'}, 'Color', 'k', 'BackgroundColor', 'w', 'EdgeColor', 'r', 'LineWidth', 2, 'HorizontalAlignment', 'center','FontSize', 11);
Hk12_podtlak_text = text(x_celk(N_pol+N8+N9+N10+N11), h12_max - 150, {'Vzniká podtlak'}, 'Color', 'k', 'BackgroundColor', 'w', 'EdgeColor', 'r', 'LineWidth', 2, 'HorizontalAlignment', 'center','FontSize', 11);
Hk13_podtlak_text = text(x_celk(N_pol+N8+N9+N10+N11+N12), h13_max - 135, {'Vzniká podtlak'}, 'Color', 'k', 'BackgroundColor', 'w', 'EdgeColor', 'r', 'LineWidth', 2, 'HorizontalAlignment', 'center','FontSize', 11);

% Vizualizace terénu
h_proti_konci = h_klicove_body-332;

h_teren = zeros(1,length(x_kliove_body)-1);

for i=1:length(x_kliove_body)-1
    h_teren(i) = plot(h_subplot_viz, [x_kliove_body(i), x_kliove_body(i+1)], [h_proti_konci(i), h_proti_konci(i+1)], 'Color', 'k','LineWidth', 1);
end

surface([x_celk; x_celk], [Hz;Hz], [zeros(size(x_celk)); zeros(size(x_celk))], [Hz; Hz], 'FaceColor', 'k','EdgeColor', [0.8 0.8 0.8], 'LineWidth', 14);
p_viz = surface([x_celk; x_celk], [Hz;Hz], [zeros(size(x_celk)); zeros(size(x_celk))], [H(1,:); H(1,:)], 'FaceColor', 'none','EdgeColor', 'interp', 'LineWidth', 8);

Hz_kominy = [Hz(N1) Hz(N1+N2) Hz(N1+N2+N3+N4+N5) Hz(N1+N2+N3+N4+N5+N6) Hz(N_pol) Hz(N_pol+N8+N9+N10) Hz(N_pol+N8+N9+N10+N11) Hz(N_pol+N8+N9+N10+N11+N12)];
Hz_kominy_nahore = [Hz(N1)+24.4 Hz(N1+N2)+74.6 Hz(N1+N2+N3+N4+N5)+153.8 Hz(N1+N2+N3+N4+N5+N6)+59.741 Hz(N_pol)+66.5 Hz(N_pol+N8+N9+N10)+44.121 Hz(N_pol+N8+N9+N10+N11)+95.8 Hz(N_pol+N8+N9+N10+N11+N12)+45];
x_kominy = [x_celk(N1) x_celk(N1+N2) x_celk(N1+N2+N3+N4+N5) x_celk(N1+N2+N3+N4+N5+N6) x_celk(N_pol) x_celk(N_pol+N8+N9+N10) x_celk(N_pol+N8+N9+N10+N11) x_celk(N_pol+N8+N9+N10+N11+N12)];
x_kominy_nahore = [x_celk(N1) x_celk(N1+N2) x_celk(N1+N2+N3+N4+N5) x_celk(N1+N2+N3+N4+N5+N6)-102.82 x_celk(N_pol) x_celk(N_pol+N8+N9+N10)+95.5 x_celk(N_pol+N8+N9+N10+N11) x_celk(N_pol+N8+N9+N10+N11+N12)];
pole_kominy = zeros(1,8);
clim([min(Hp(:)), max(Hp(:))]);
cb = colorbar;
ylabel(cb, 'Tlaková výška [m]');
set(h_subplot_viz,'position',[0.03 0.07 0.91 0.45]);
box

% Nádrž vlevo
H_nadrz_pozadi = linspace(Hz(1)+5, Hz(1) + vyska_nadrze, N_kominy);
x_nadrz = zeros(1, N_kominy);
surface([x_nadrz+200; x_nadrz+200], [H_nadrz_pozadi; H_nadrz_pozadi], [zeros(size(x_nadrz)); zeros(size(x_nadrz))], [H_nadrz_pozadi; H_nadrz_pozadi], ...
        'FaceColor', 'k', 'EdgeColor', [0.8 0.8 0.8], 'LineWidth', 8);
h_voda_nadrz = surface([x_nadrz+125; x_nadrz+125], [H_nadrz_pozadi; H_nadrz_pozadi], [zeros(size(x_nadrz)); zeros(size(x_nadrz))], [H_nadrz_pozadi; H_nadrz_pozadi], ...
        'FaceColor', 'none', 'EdgeColor', 'interp', 'LineWidth', 5);
yline(h_subplot_viz, Hz(1) + vyska_nadrze, '--k', 'LineWidth', 0.2);

% Přiřazení proprcionálních tlouštěk komínům
for i=1:8
    if i == 4 || i == 6
        sirka_komin = 14; % Tlustší
        sirka_voda = 8;
    elseif i == 8
        sirka_komin = 10; % Střední
        sirka_voda = 5;
    else
        sirka_komin = 6;  % Užší
        sirka_voda = 3;
    end

    % Vykreslení komínů
    Hk_pozadi = linspace(Hz_kominy(i) + offset_vyska, Hz_kominy_nahore(i), N_kominy);
    pomer_offset = offset_vyska / (Hz_kominy_nahore(i) - Hz_kominy(i));
    x_offset = x_kominy(i) + (x_kominy_nahore(i) - x_kominy(i)) * pomer_offset;
    x_pozadi = linspace(x_offset, x_kominy_nahore(i), N_kominy);

    surface([x_pozadi; x_pozadi], [Hk_pozadi; Hk_pozadi], [zeros(size(x_pozadi)); zeros(size(x_pozadi))], [Hk_pozadi; Hk_pozadi], ...
            'FaceColor', 'k', 'EdgeColor', [0.8 0.8 0.8], 'LineWidth', sirka_komin);
    pole_kominy(i) = surface([x_pozadi; x_pozadi], [Hk_pozadi; Hk_pozadi], [zeros(size(x_pozadi)); zeros(size(x_pozadi))], [Hk_pozadi; Hk_pozadi], ...
            'FaceColor', 'none', 'EdgeColor', 'interp', 'LineWidth', sirka_voda);
end

% Horní graf - průběh průtoku podél přivaděče
h_subplot_Q = subplot(4,1,1);
hold on;
grid on;
h_title=title(h_subplot_Q, 'Průtok Q', 'FontSize', 11);
ylabel('Q [m^3/s]');
xlim(h_subplot_Q, [0, L1+L2+L3+L4+L5+L6+L7+L8+L9+L10+L11+L12+L13]);
ylim(h_subplot_Q, [-2 10]);
set(h_subplot_Q, 'XTickLabel', []);
h_line_V = plot(h_subplot_Q, x_celk, Q(1,:), 'b-');
hold on

set(h_subplot_Q,'position',[0.03 0.78 0.91 0.18]);
box;

% Prostřední graf - průběh piezometrické a tlakové výšky
h_subplot_H = subplot(4,1,2);
hold on;
grid on;
title(h_subplot_H, 'Průběhy výšek', 'FontSize', 11);
xlim(h_subplot_H, [0, L1+L2+L3+L4+L5+L6+L7+L8+L9+L10+L11+L12+L13]);
yyaxis left
ylabel('Tlaková výška H_p [m]');
h_subplot_H.YAxis(1).Color = 'r';
ylim(h_subplot_H, [min(Hp(:)), max(Hp(:))]);
h_line_H = plot(h_subplot_H, x_celk, Hp(1,:), 'r-');
ylim([0 150])

yyaxis right
h_line_H_celk = plot(h_subplot_H, x_celk, Hp(1,:)+Hz, 'b-');
ylabel('Piezometrická výška H [m]');
h_subplot_H.YAxis(2).Color = 'b';
ylim([-10 70])
set(h_subplot_H, 'XTickLabel', []);
set(h_subplot_H,'position',[0.03 0.56 0.91 0.18]);
grid on
box

%vidObj = VideoWriter('Valve_opening','MPEG-4');
%vidObj.FrameRate=100;
%open(vidObj);

% Přiřazení vypočtených dat objektům v grafech
for k = 1:10:n-1
    
    set(h_line_V, 'YData', Q(k,:)); 
    set(h_line_H, 'YData', Hp(k,:));
    set(h_line_H_celk, 'YData', Hp(k,:)+Hz);

    set(h_title,'String',['Průtok Q (t=', num2str(k*dt, '%.0f'), ' s)'])

    set(p_viz, 'CData', [Hp(k,:); Hp(k,:)]);
    Hk_kominy = [Hk2(k) Hk3(k) Hk5(k) Hk6(k) Hk8(k) Hk11(k) Hk12(k) Hk13(k)];
    
    for i = 1:8
        Hk_aktualni = Hz_kominy(i) + linspace(0, Hk_kominy(i), N_kominy);
        Hk_tlakovy_profil = linspace(Hk_kominy(i), 0, N_kominy);
        vyska_pomer = Hk_kominy(i)/(Hz_kominy_nahore(i) - Hz_kominy(i));
        x_hladina = x_kominy(i) + (x_kominy_nahore(i) - x_kominy(i)) * vyska_pomer;
        x_aktualni = linspace(x_kominy(i),x_hladina, N_kominy);

        set(pole_kominy(i), 'XData', [x_aktualni; x_aktualni], 'YData', [Hk_aktualni; Hk_aktualni], 'CData', [Hk_tlakovy_profil; Hk_tlakovy_profil]);
    end
        
    H_nadrz_voda = Hz(1) + linspace(0, vyska_nadrze, N_kominy);
    C_data_nadrz = linspace(Hp(k,1), 0, N_kominy); 

    set(h_voda_nadrz, 'YData', [H_nadrz_voda; H_nadrz_voda], 'CData', [C_data_nadrz; C_data_nadrz]);

    % Zobrazení přeteklého objemu
    Qk11_preteceny_aktualni = Qk11_preteceny_vector(k);
    if Qk11_preteceny_aktualni > 0
        set(QK11_text, 'Visible', 'on', 'String', {'Přeteklo:', sprintf('%.2f m^3', Qk11_preteceny_vector(k))});
    else
        set(QK11_text, 'Visible', 'off');
    end

    Qk12_preteceny_aktualni = Qk12_preteceny_vector(k);
    if Qk12_preteceny_aktualni > 0
        set(QK12_text, 'Visible', 'on', 'String', {'Přeteklo:', sprintf('%.2f m^3', Qk12_preteceny_vector(k))});
    else
        set(QK12_text, 'Visible', 'off');
    end

    Qk13_preteceny_aktualni = Qk13_preteceny_vector(k);
    if Qk13_preteceny_aktualni > 0
        set(QK13_text, 'Visible', 'on', 'String', {'Přeteklo:', sprintf('%.2f m^3', Qk13_preteceny_vector(k))});
    else
        set(QK13_text, 'Visible', 'off');
    end

    % Zobrazení podtlaku
    if Hk11_podtlak(k) == 1
        set(Hk11_podtlak_text, 'Visible', 'on', 'String', 'Vzniká podtlak');
    else
        set(Hk11_podtlak_text, 'Visible', 'off');
    end

    if Hk12_podtlak(k) == 1
        set(Hk12_podtlak_text, 'Visible', 'on', 'String', 'Vzniká podtlak');
    else
        set(Hk12_podtlak_text, 'Visible', 'off');
    end

    if Hk13_podtlak(k) == 1
        set(Hk13_podtlak_text, 'Visible', 'on', 'String', 'Vzniká podtlak');
    else
        set(Hk13_podtlak_text, 'Visible', 'off');
    end

    %currFrame = getframe(h);
    %writeVideo(vidObj,currFrame); 
      
    pause(0.00001)
end

%close(vidObj);

%% Zobrazení průběhů ve vybraných bodech
cas = zeros(n,1);
for i=2:n
    cas(i)=i*dt;
end

g=figure;
set(g,'Position',[5 10 0.99*s(3) 0.9*s(4)],'color',[1 1 1])
box;

% Průtok
g_subplot_Q_i=subplot(3,1,1);
hold on;
grid on;
xlim(g_subplot_Q_i, [0, time]);
ylim(g_subplot_Q_i, [min(Q(:)), max(Q(:))]);
ylabel(g_subplot_Q_i, 'Q [m^3/s]');
set(g_subplot_Q_i, 'XTickLabel', []);
set(g_subplot_Q_i,'position',[0.03 0.69 0.85 0.26]);
title(g_subplot_Q_i, 'Průběh průtoků ve vybraných bodech', 'FontSize', 11);
plot(cas, Q(:,N1/2), 'Color', [255 128 0]/255, LineWidth=1);
plot(cas, Q(:,N1+N2+(N3+1)/2), 'Color', 'g', LineWidth=1);
plot(cas, Q(:,N1+N2+N3+N4+N5+(N6+1)/2), 'Color', 'b', LineWidth=1);
plot(cas, Q(:,N1+N2+N3+N4+N5+N6+N7+(N8+1)/2), 'Color', [0 153 0]/255, LineWidth=1);
plot(cas, Q(:,N_pol+N8+N9+N10+(N11+1)/2), 'Color', 'r', LineWidth=1);
plot(cas, Q(:,N_pol+N8+N9+N10+N11+(N12+1)/2), 'Color', 'c', LineWidth=1);
plot(cas, Q(:,N_pol+N8+N9+N10+N11+N12+N13/2), 'Color', [127 0 255]/255, LineWidth=1);

lgd1 = legend({'Úsek 1','Úsek 3','Úsek 6','Úsek 8','Úsek 11','Úsek 12','Úsek 13'});
set(lgd1, 'Units','normalized', 'FontSize', 10);
set(lgd1, 'Position',[0.89 0.69 0.085 0.26]);
hold off

% Piezometrická výška
g_subplot_H_i=subplot(3,1,2);
hold on;
grid on;
xlim(g_subplot_H_i, [0, time]);
ylim(g_subplot_H_i, [min(H(:)), max(H(:))]);
ylabel(g_subplot_H_i, 'H [m]');
set(g_subplot_H_i, 'XTickLabel', []);
set(g_subplot_H_i,'position',[0.03 0.38 0.85 0.26]);
title(g_subplot_H_i, 'Průběh piezometrických výšek ve vybraných bodech', 'FontSize', 11);
plot(cas, H(:,N1/2), 'Color', [255 128 0]/255, LineWidth=1);
plot(cas, H(:,N1+N2+(N3+1)/2), 'Color', 'g', LineWidth=1);
plot(cas, H(:,N1+N2+N3+N4+N5+(N6+1)/2), 'Color', 'b', LineWidth=1);
plot(cas, H(:,N1+N2+N3+N4+N5+N6+N7+(N8+1)/2), 'Color', [0 153 0]/255, LineWidth=1);
plot(cas, H(:,N_pol+N8+N9+N10+(N11+1)/2), 'Color', 'r', LineWidth=1);
plot(cas, H(:,N_pol+N8+N9+N10+N11+(N12+1)/2), 'Color', 'c', LineWidth=1);
plot(cas, H(:,N_pol+N8+N9+N10+N11+N12+N13/2), 'Color', [127 0 255]/255, LineWidth=1);

lgd2 = legend({'Úsek 1','Úsek 3','Úsek 6','Úsek 8','Úsek 11','Úsek 12','Úsek 13'});
set(lgd2, 'Units','normalized','FontSize', 10);
set(lgd2, 'Position',[0.89 0.38 0.085 0.26]);
hold off

% Výška hladin v komínech
g_subplot_hk_i=subplot(3,1,3);
hold on;
grid on;
xlim(g_subplot_hk_i, [0, time]);
xlabel(g_subplot_hk_i, 'Čas [s]');
ylabel(g_subplot_hk_i, 'H_k [m]');
set(g_subplot_hk_i,'position',[0.03 0.06 0.85 0.26]);
title(g_subplot_hk_i, 'Průběh výšek hladin v komínech', 'FontSize', 11);
plot(cas, Hk2(:), 'Color', [127 0 255]/255, LineWidth=1);
plot(cas, Hk3(:), 'Color', 'g', LineWidth=1);
plot(cas, Hk5(:), 'Color', 'k', LineWidth=1);
plot(cas, Hk6(:), 'Color', [255 102 178]/255, LineWidth=1);
plot(cas, Hk8(:), 'Color', [255 128 0]/255, LineWidth=1);
plot(cas, Hk11(:), 'Color', 'r', LineWidth=1);
plot(cas, Hk12(:), 'Color', 'b', LineWidth=1);
plot(cas, Hk13(:), 'Color', [0 153 0]/255, LineWidth=1);

lgd3 = legend({'Komín K2','Komín K3','Komín K5','Úpadnice Křešice','Komín K8','Úpadnice Brtnice','Komín Čenětice', 'Komín K13'});
set(lgd3, 'Units','normalized', 'FontSize', 10);
set(lgd3, 'Position',[0.9 0.06 0.085 0.26]);
hold off

%% Průběhy průtoku a piezometrické výšky v posledním uzlu
f=figure;
set(f,'Position',[5 10 0.99*s(3) 0.9*s(4)],'color',[1 1 1])
box;

f_subplot_Q_konec=subplot(2,1,1);
hold on;
grid on;
xlim(f_subplot_Q_konec, [0, time]);
ylim(f_subplot_Q_konec, [min(Q(:,end)), max(Q(:,end))]);
ylabel(f_subplot_Q_konec, 'Q [m^3/s]');
set(f_subplot_Q_konec, 'XTickLabel', []);
set(f_subplot_Q_konec,'position',[0.03 0.54 0.95 0.4]);
title(f_subplot_Q_konec, 'Průběh průtoku v posledním uzlu potrubí', 'FontSize', 11);
plot(cas, Q(:,end), 'Color', 'b', LineWidth=1);
hold off

f_subplot_H_konec=subplot(2,1,2);
hold on;
grid on;
xlim(f_subplot_H_konec, [0, time]);
ylim(f_subplot_H_konec, [min(H(:,end)), max(H(:,end))]);
xlabel(f_subplot_H_konec, 'Čas [s]');
ylabel(f_subplot_H_konec, 'H [m]');
set(f_subplot_H_konec,'position',[0.03 0.06 0.95 0.4]);
title(f_subplot_H_konec, 'Průběh piezometrické výšky v posledním uzlu potrubí', 'FontSize', 11);
plot(cas, H(:,end), 'Color', 'b', LineWidth=1);
hold off
