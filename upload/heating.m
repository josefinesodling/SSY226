clear all
close all

a = 1.675091827e-3;
b = 1.857536553e-4;
c = 5.373169834e-7;

fid = fopen('heating_2L.txt');
data1 = fscanf(fid, '%f');
fclose(fid);

fid = fopen('heating_2-5L.txt');
data2 = fscanf(fid, '%f');
fclose(fid);

fid = fopen('heating_3L.txt');
data3 = fscanf(fid, '%f');
fclose(fid);

fid = fopen('heating_2-25L.txt');
data4 = fscanf(fid, '%f');
fclose(fid);

fid = fopen('heating_2-75L.txt');
data5 = fscanf(fid, '%f');
fclose(fid);

%--------------------
time1 = data1(1:3:length(data1))/1000;
analog11 = data1(2:3:length(data1));
analog21 = data1(3:3:length(data1));

Rw1 = (2250600./analog11) - 2200;
Rwlog1 = log(Rw1);
Rr1 = (2250600./analog21) - 2200;
Rrlog1 = log(Rr1);

Tw1 = (1./(a + b.*Rwlog1 + c.*(Rwlog1.^3)))-273.15;
Tr1 = (1./(a + b.*Rrlog1 + c.*(Rrlog1.^3)))-273.15;
%----------------------------------------------------
time2 = data2(1:3:length(data2))/1000;
analog12 = data2(2:3:length(data2));
analog22 = data2(3:3:length(data2));

Rw2 = (2250600./analog12) - 2200;
Rwlog2 = log(Rw2);
Rr2 = (2250600./analog22) - 2200;
Rrlog2 = log(Rr2);

Tw2 = (1./(a + b.*Rwlog2 + c.*(Rwlog2.^3)))-273.15;
Tr2 = (1./(a + b.*Rrlog2 + c.*(Rrlog2.^3)))-273.15;
%---------------------------------------------------
time3 = data3(1:3:length(data3))/1000;
analog13 = data3(2:3:length(data3));
analog23 = data3(3:3:length(data3));

Rw3 = (2250600./analog13) - 2200;
Rwlog3 = log(Rw3);
Rr3 = (2250600./analog23) - 2200;
Rrlog3 = log(Rr3);

Tw3 = (1./(a + b.*Rwlog3 + c.*(Rwlog3.^3)))-273.15;
Tr3 = (1./(a + b.*Rrlog3 + c.*(Rrlog3.^3)))-273.15;
%---------------------------------------------------
time4 = data4(1:3:length(data4))/1000;
analog14 = data4(2:3:length(data4));
analog24 = data4(3:3:length(data4));

Rw4 = (2250600./analog14) - 2200;
Rwlog4 = log(Rw4);
Rr4 = (2250600./analog24) - 2200;
Rrlog4 = log(Rr4);

Tw4 = (1./(a + b.*Rwlog4 + c.*(Rwlog4.^3)))-273.15;
Tr4 = (1./(a + b.*Rrlog4 + c.*(Rrlog4.^3)))-273.15;
%---------------------------------------------------
time5 = data5(1:3:length(data5))/1000;
analog15 = data5(2:3:length(data5));
analog25 = data5(3:3:length(data5));

Rw5 = (2250600./analog15) - 2200;
Rwlog5 = log(Rw5);
Rr5 = (2250600./analog25) - 2200;
Rrlog5 = log(Rr5);

Tw5 = (1./(a + b.*Rwlog5 + c.*(Rwlog5.^3)))-273.15;
Tr5 = (1./(a + b.*Rrlog5 + c.*(Rrlog5.^3)))-273.15;
%---------------------------------------------------
limit = 25;

[~, pos1] = min(abs(limit-Tw1));
[~, pos2] = min(abs(limit-Tw2));
[~, pos3] = min(abs(limit-Tw3));
[~, pos4] = min(abs(limit-Tw4));
[~, pos5] = min(abs(limit-Tw5));

time1x = time1(pos1:end)-time1(pos1);
time2x = time2(pos2:end)-time2(pos2);
time3x = time3(pos3:end)-time3(pos3);
time4x = time4(pos4:end)-time4(pos4);
time5x = time5(pos5:end)-time5(pos5);
Tw1x = Tw1(pos1:end);
Tw2x = Tw2(pos2:end);
Tw3x = Tw3(pos3:end);
Tw4x = Tw4(pos4:end);
Tw5x = Tw5(pos5:end);

sr = 1; %4

figure, subplot(2,1,1);
plot(downsample(time1x, sr), downsample(Tw1x, sr), ':r', 'LineWidth', 2);
xlabel('Time [s]')
s = sprintf('Temperature [%cC]', char(176));
ylabel(s)
title('Water heating')

hold on
plot(downsample(time2x, sr), downsample(Tw2x, sr), ':b', 'LineWidth', 2);
plot(downsample(time3x, sr), downsample(Tw3x, sr), ':k', 'LineWidth', 2);
plot(downsample(time4x, sr), downsample(Tw4x, sr), ':m', 'LineWidth', 2);
plot(downsample(time5x, sr+2), downsample(Tw5x, sr+2), ':', 'Color', [0.9412 0.4706 0], 'LineWidth', 2);

legend('2L, max power', '2.5L, max power', '3L, max power', '2.3L, max power', '2.8 L, max power', 'Location','southeast')

k(1) = k_exp(2,6);
k(2) = k_exp(2,0);
k(3) = k_exp(3,6);
k(4) = k_exp(3,0);
k(5) = k_exp(2.5,6);
k(6) = k_exp(2.5,0);
k(7) = k_exp(2.3,6);
T_r = 24.3;

Txx1(1) = Tw1x(1);
a = 24.3;
kon = exp(-k(1));
Tx(1) = a + abs(Tw1x(1) - a)*kon;
Txx2(1) = Tw2x(1);
Txx3(1) = Tw3x(1);
for i = 1:600-1
   Txx1(1+i) = Txx1(i) + ((1218/(4180)) -(Txx1(i)-T_r)*0.0019)/2;
   %Tx(1+i) = Tx(i) + ((1218/(4180)))/2;
   %Tx(1+i) = T_r + abs(Tx(i+1) - T_r)*kon;
   Txx2(1+i) = Txx2(i) + ((1218/(4180)) -(Txx2(i)-T_r)*0.0019)/2.5;
   Txx3(1+i) = Txx3(i) + ((1218/(4180)) -(Txx3(i)-T_r)*0.0019)/3;
   %Txx(1+i) = T_r - (Txx(i) - T_r)*exp(-k(1));
end

%plot(linspace(1,600,600), Txx1, '.g');
%plot(linspace(1,600,600), Txx2, '.k');
%plot(linspace(1,600,600), Txx3, '.b');