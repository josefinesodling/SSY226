clear all
clc
close all

Tr = 24;
U = 230;
Imax = 5.3;
c = 4180;
m = 2;
v = 6;
t = 10; % sample time
power = 100; % in percent
T_ref = 50;
Kp = 30;
Ki = 1.0;
pow_vec = 100;
seconds = 900;
time = linspace(0,seconds,(seconds/t)+1);
ref_vec = T_ref;
I = 0;
state = 1;

% /Heating
T1 = 25;
for i = 1:(seconds/t)
    k = 0.00001615*power + 0.000015770*v + 0.00019;
    T1(i+1) = T1(i) + ((U*Imax)/(c*m))*(power/100)*t - (T1(i) - Tr)*(k)*(t/m);
    pow_vec(i+1) = power;
end
T2 = 25;
m = 2.5;
for i = 1:(seconds/t)
    k = 0.00001615*power + 0.000015770*v + 0.00019;
    T2(i+1) = T2(i) + ((U*Imax)/(c*m))*(power/100)*t - (T2(i) - Tr)*(k)*(t/m);
end
T3 = 25;
m = 3;
for i = 1:(seconds/t)
    k = 0.00001615*power + 0.000015770*v + 0.00019;
    T3(i+1) = T3(i) + ((U*Imax)/(c*m))*(power/100)*t - (T3(i) - Tr)*(k)*(t/m);
end

% / Cooling'seconds = 900;
seconds2 = 5000;
time2 = linspace(0,seconds2,(seconds2/t)+1);
Tc1 = 68;
power = 0;
m = 2;
v = 6;
for i = 1:(seconds2/t)
    k = 0.00001615*power + 0.000015770*v + 0.00019;
    Tc1(i+1) = Tc1(i) + ((U*Imax)/(c*m))*(power/100)*t - (Tc1(i) - Tr)*(k)*(t/m);
end

Tc2 = 68;
m = 2.5;
v = 6;
for i = 1:(seconds2/t)
    k = 0.00001615*power + 0.000015770*v + 0.00019;
    Tc2(i+1) = Tc2(i) + ((U*Imax)/(c*m))*(power/100)*t - (Tc2(i) - Tr)*(k)*(t/m);
end

Tc3 = 68;
m = 3;
v = 6;
for i = 1:(seconds2/t)
    k = 0.00001615*power + 0.000015770*v + 0.00019;
    Tc3(i+1) = Tc3(i) + ((U*Imax)/(c*m))*(power/100)*t - (Tc3(i) - Tr)*(k)*(t/m);
end

Tcn1 = 68;
power = 0;
m = 2;
v = 0;
for i = 1:(seconds2/t)
    k = 0.00001615*power + 0.000015770*v + 0.00019;
    Tcn1(i+1) = Tcn1(i) + ((U*Imax)/(c*m))*(power/100)*t - (Tcn1(i) - Tr)*(k)*(t/m);
end

Tcn2 = 68;
m = 2.5;
v = 0;
for i = 1:(seconds2/t)
    k = 0.00001615*power + 0.000015770*v + 0.00019;
    Tcn2(i+1) = Tcn2(i) + ((U*Imax)/(c*m))*(power/100)*t - (Tcn2(i) - Tr)*(k)*(t/m);
end

Tcn3 = 68;
m = 3;
v = 0;
for i = 1:(seconds2/t)
    k = 0.00001615*power + 0.000015770*v + 0.00019;
    Tcn3(i+1) = Tcn3(i) + ((U*Imax)/(c*m))*(power/100)*t - (Tcn3(i) - Tr)*(k)*(t/m);
end

figure, subplot(2,1,1);
plot(time(1:60), T1(1:60), ':r', 'LineWidth', 2)
hold on
plot(time(1:75), T2(1:75), ':b', 'LineWidth', 2)
plot(time(1:90), T3(1:90), ':k', 'LineWidth', 2)
legend('2L, max power', '2.5L, max power', '3L, max power', 'Location', 'SouthEast')
%xlim([0,1000])
xlabel('Time [s]')
s = sprintf('Temperature [%cC]', char(176));
ylabel(s)
title('Water heating')
subplot(2,1,2);
plot(time2,Tc1, ':r', 'Linewidth', 2);
hold on
plot(time2,Tc2, ':b', 'Linewidth', 2);
plot(time2,Tc3, ':k', 'Linewidth', 2);

plot(downsample(time2,3),downsample(Tcn1,3), '*r', 'MarkerSize', 1);
plot(time2,Tcn2, '*b', 'MarkerSize', 1);
plot(time2,Tcn3, '*k', 'MarkerSize', 1);

legend('pump, 2L', 'pump, 2.5L', 'pump, 3L', 'no pump, 2L', 'no pump, 2.5', 'no pump, 3L', 'Location', 'NorthEast')

ylim([55,70])
xlabel('Time [s]')
s = sprintf('Temperature [%cC]', char(176));
ylabel(s)
title('Cooling water down')