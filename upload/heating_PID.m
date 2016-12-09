clear all
close all

a = 1.675091827e-3;
b = 1.857536553e-4;
c = 5.373169834e-7;

fid = fopen('heating_PID_3L_ext.txt');
data1 = fscanf(fid, '%f');
fclose(fid);

%--------------------------------------------------
time1 = data1(1:6:length(data1))/1000;
analog11 = data1(2:6:length(data1));
analog21 = data1(3:6:length(data1));
analog31 = data1(4:6:length(data1));
refTemp = data1(5:6:length(data1));
power = 1218*data1(6:6:length(data1))/100;

Rw1 = (2250600./analog11) - 2200;
Rwlog1 = log(Rw1);
Rr1 = (2250600./analog21) - 2200;
Rrlog1 = log(Rr1);
Rj1 = (2250600./analog31) - 2200;
Rjlog1 = log(Rj1);

Tw1 = (1./(a + b.*Rwlog1 + c.*(Rwlog1.^3)))-273.15;
Tr1 = (1./(a + b.*Rrlog1 + c.*(Rrlog1.^3)))-273.15;
Tj1 = (1./(a + b.*Rjlog1 + c.*(Rjlog1.^3)))-273.15;
%----------------------------------------------------
%limit = 25;

%[~, pos1] = min(abs(limit-Tw1));

%time1x = time1(pos1:end)-time1(pos1);

time1 = time1 - time1(1);
time1x = time1(100:end) - time1(100);

figure, subplot(2,1,1);
plot(time1x, Tw1(100:end), ':r', 'LineWidth', 2);
xlabel('Time [s]')
s = sprintf('Temperature [%cC]', char(176));
ylabel(s)
title('Water temperature control')
hold on
%plot(time1, Tr1, ':b', 'LineWidth', 2);
%plot(time1, Tj1, ':m', 'LineWidth', 2);
plot(time1(100:end)-time1(100), refTemp(100:end), ':k', 'LineWidth', 2);
ylim([60,72])
xlim([0,3600])
%xlim([1000,length(time1)*10])
legend('Water temp', 'Reference temp')
%legend('Water temp', 'Room temp', 'Jacket temp', 'Reference temp', 'Location', 'NorthWest');
subplot(2,1,2);
plot(time1x, power(100:end), ':b', 'LineWidth', 2);
xlim([0,3600])
xlabel('Time [s]')
ylabel('Power [W]')
legend('Power input')
title('Power input')
