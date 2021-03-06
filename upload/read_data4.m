clear all
close all

% 3L, pump off while cooling
fid = fopen('data5A_heaton_pumpon_3.txt')
data = fscanf(fid, '%f');
fclose(fid);

time = data(1:3:length(data))/1000;
analog1 = data(2:3:length(data));
analog2 = data(3:3:length(data));

R = (2250600./analog1) - 2200;
Rlog = log(R);
R2 = (2250600./analog2) - 2200;
Rlog2 = log(R2);

a = 1.675091827e-3;
b = 1.857536553e-4;
c = 5.373169834e-7;
TEMP = (1./(a + b.*Rlog + c.*(Rlog.^3)))-273.15;
TEMP2 = (1./(a + b.*Rlog2 + c.*(Rlog2.^3)))-273.15;

figure, subplot(1,2,1);
plot(time, TEMP, '*r');
hold on
subplot(1,2,2);
plot(time, TEMP2, '*r');
ylim([20,27])