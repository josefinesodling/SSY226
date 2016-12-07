clear all
clc
close all

T1 = 17;
Tr = 24;
U = 230;
Imax = 5.3;
c = 4180;
m = 2;
v = 0;
t = 10; % sample time
power = 100; % in percent
T_ref = 50;
Kp = 30;
Ki = 1.0;
pow_vec = 100;
seconds = 4000;
time = linspace(0,seconds,(seconds/t)+1);
ref_vec = T_ref;
I = 0;
state = 1;

for i = 1:(seconds/t)
    
    if i*t == 400
        power = 50;
    end
    
    if i*t == 500
        power = 25;
    end
    
    if i*t == 600
        power = 10;
    end
    
    if i*t == 700
        power = 5;
    end
    
    if i*t == 800
        power = 0;
    end
    
    k = 0.00001615*power + 0.000015770*v + 0.00019;
    
    T1(i+1) = T1(i) + ((U*Imax)/(c*m))*(power/100)*t - (T1(i) - Tr)*(k)*(t/m);
    pow_vec(i+1) = power;
end

figure, subplot(2,1,1);
plot(time, T1, ':r', 'LineWidth', 2)
xlim([0,1000])
xlabel('Time [s]')
ylabel('Temp C')
title('Water heating')
subplot(2,1,2);
plot(time,(pow_vec/100)*1218, ':', 'Linewidth', 2);
xlim([0,1000])
xlabel('Time [s]')
ylabel('Power [W]')
title('Power input')