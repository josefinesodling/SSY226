clear all
close all

a = 1.675091827e-3;
b = 1.857536553e-4;
c = 5.373169834e-7;

fid = fopen('heating_PID_2L_eggs.txt');
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

time1 = time1(40:end);
Tw1 = Tw1(40:end);
refTemp = refTemp(40:end);
power = power(40:end);
time1 = time1 - time1(1);

g = gausswin(50); % <-- this value determines the width of the smoothing window
g = g/sum(g);
g2 = gausswin(25); % <-- this value determines the width of the smoothing window
g2 = g2/sum(g2);

p_smooth = smooth(smooth(smooth(smooth(power))));
p_smooth = conv(power, g, 'same');
t_smooth = conv(Tw1, g2, 'same');

figure, subplot(2,1,1);
plot(time1(1:end-25), Tw1(1:end-25), ':r', 'LineWidth', 2);
xlabel('Time [s]')
ylabel('Temp C')
title('Heating water and eggs')
hold on
plot(time1(1:end-25), refTemp(1:end-25), ':k', 'LineWidth', 2);
%plot(time1, t_smooth, ':b', 'LineWidth', 2);

legend('Water temp', 'Reference temp', 'Location', 'NorthWest');
subplot(2,1,2);
plot(time1(1:end-25), power(1:end-25), ':b', 'LineWidth', 2);
hold on;
plot(time1(1:end-25), p_smooth(1:end-25), ':k', 'LineWidth', 2);
xlabel('Time [s]')
ylabel('Power [W]')
legend('Power input', 'Smoothed power input')
title('Power input')
