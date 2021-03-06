clear all
clc
close all

T1 = 19.5;
Tr = 24.8926;
U = 230;
Imax = 5.3;
c = 4180;
m = 2;
t = 10; % sample time
power = 100; % in percent
T_ref = 50;
Kp = 30;
Ki = 1.0;
pow_vec = 100;
seconds = 2500;
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

time1 = time1 - time1(1);
time = time-time(1);

figure, subplot(2,1,1);
plot(time(2:end)-time(2), T1(2:end), ':r', 'LineWidth', 2)
hold on
plot(time1(1:250)-time1(1), Tw1(1:250), ':b', 'LineWidth', 2)
plot(time(2:end), ref_vec(2:end), ':k', 'LineWidth', 2)
xlabel('Time [s]')
ylabel('Temp C')
title('Water temperature')
legend('Model', 'Implemented system', 'Reference temp', 'Location', 'NorthWest')
xlim([0,2500])
subplot(2,1,2);
plot(time(2:end)-time(2),(pow_vec(2:end)/100)*1218, ':r', 'Linewidth', 2);
hold on
plot(time1(1:250)-time1(1), power(1:250), ':b', 'LineWidth', 2)
xlabel('Time [s]')
ylabel('Power [W]')
title('Power input')
legend('Model', 'Implemented system')
xlim([0,2500])