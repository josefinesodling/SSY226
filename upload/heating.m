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
limit = 25;

[~, pos1] = min(abs(limit-Tw1));
[~, pos2] = min(abs(limit-Tw2));
[~, pos3] = min(abs(limit-Tw3));

figure%, subplot(1,2,1);
plot(time1(pos1:end)-time1(pos1), Tw1(pos1:end), '*r');
xlabel('Time [s]')
ylabel('Temp C')
title('Water heating')

hold on
plot(time2(pos2:end)-time2(pos2), Tw2(pos2:end), '*b');
plot(time3(pos3:end)-time3(pos3), Tw3(pos3:end), '*k');

legend('2L, max power', '2.5L, max power', '3L, max power')