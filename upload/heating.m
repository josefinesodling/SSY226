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

sr = 4;

figure%, subplot(1,2,1);
plot(downsample(time1(pos1:end)-time1(pos1), sr), downsample(Tw1(pos1:end), sr), ':r', 'LineWidth', 2);
xlabel('Time [s]')
ylabel('Temp C')
title('Water heating')

hold on
plot(downsample(time2(pos2:end)-time2(pos2), sr), downsample(Tw2(pos2:end), sr), ':b', 'LineWidth', 2);
plot(downsample(time3(pos3:end)-time3(pos3), sr), downsample(Tw3(pos3:end), sr), ':k', 'LineWidth', 2);
plot(downsample(time4(pos4+8:end)-time4(pos4+8), sr), downsample(Tw4(pos4+8:end), sr), ':m', 'LineWidth', 2);
plot(downsample(time5(pos5+8:end)-time5(pos5+8), sr+2), downsample(Tw5(pos5+8:end), sr+2), ':', 'Color', [0.9412 0.4706 0], 'LineWidth', 2);

legend('2L, max power', '2.5L, max power', '3L, max power', '2.3L, max power', '2.8 L, max power', 'Location','southeast')