clear all
clc
close all

T1 = 17;
Tr = 24;
U = 230;
Imax = 5.3;
c = 4180;
m = 2;
t = 10; % sample time
power = 0; % in percent
T_ref = 50;
Kp = 30;
Ki = 1.0;
pow_vec = 0;
seconds = 4000;
time = linspace(0,seconds,(seconds/t)+1);
ref_vec = T_ref;
I = 0;
state = 1;

for i = 1:(seconds/t)
    T1(i+1) = T1(i) + ((U*Imax)/(c*m))*(power/100)*t - (T1(i) - Tr)*(0.00001615*power + 0.000285)*(t/m);
    
    error = T_ref-T1(i+1);
    
    if (error < 1) && (error > 0)
        I = I + error*t;
    else
        I = 0;
    end
    
    power = round(Kp*error + I*Ki);
    
    if power > 100
        power = 100;
    elseif (power < 0) || (error < -0.05)
        power = 0;
    end
    
    pow_vec(i+1) = power;
    
    if i*t == 400
        T_ref = 60;
    end
    if i*t == 700
        T_ref = 70;
    end
    if i*t == 900
        T_ref = 90;
    end
    if i*t == 1300
       T_ref = 85; 
    end
    if i*t == 2000
        T_ref = 90;
    end
    ref_vec(i+1) = T_ref;
    
end

figure, subplot(2,1,1);
plot(time, T1, ':r', 'LineWidth', 2)
hold on
plot(time, ref_vec, ':k', 'LineWidth', 2)
xlabel('Time [s]')
ylabel('Temp C')
title('Water temperature')
xlim([0,2500])
subplot(2,1,2);
plot(time,(pow_vec/100)*1218, ':', 'Linewidth', 2);
xlabel('Time [s]')
ylabel('Power [W]')
title('Power input')
xlim([0,2500])