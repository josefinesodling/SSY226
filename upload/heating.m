clear all
close all

a = 1.675091827e-3;
b = 1.857536553e-4;
c = 5.373169834e-7;

fid = fopen('heating_2L.txt');
data1 = fscanf(fid, '%f');
fclose(fid);

time1 = data1(1:3:length(data1))/1000;
analog11 = data1(2:3:length(data1));
analog21 = data1(3:3:length(data1));

Rw1 = (2250600./analog11) - 2200;
Rwlog1 = log(Rw1);
Rr1 = (2250600./analog21) - 2200;
Rrlog1 = log(Rr1);

Tw1 = (1./(a + b.*Rwlog1 + c.*(Rwlog1.^3)))-273.15;
Tr1 = (1./(a + b.*Rrlog1 + c.*(Rrlog1.^3)))-273.15;

figure%, subplot(1,2,1);
plot(time1-time1(1), Tw1, '*r');
xlabel('Time [ms]')
ylabel('Temp C')
title('Water heating')

legend('2L')