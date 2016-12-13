% clear all
% clc
% %% INSERT POWER gives FLOW! this is maximum
% F = [0.001 0.002 0.005 0.006 0.008 0.01 0.02 0.05 0.06 0.08 0.09 0.1]/(10^3);   % flow 6[liter/min] gives 0.0001[m^3/s]
% P = 35;
% %% Calculate pressure diff
% d = 0.01;                               % [m]innerdiameter of the hose
% A_inner = (d/2)^2*pi;                   % inner area of hose [m^2]
% v = F(12)/A_inner;                          % velocity inside hose [m/s]
% rho = 1000;                             % [kg/m^3]
% L = 1.5;                                % [m] length of hose
% eta = 0.87*0.94;                        % efficiency
% %viskositet [m/s^2]
% visk = [1.792 1.519 1.308 1.005 .801 .656 .549 .469 .406 .357 .317 .284]./1000000;
% temp = [0 5 10 20 30 40 50 60 70 80 90 100];
% 
% for i=1:length(temp)
%     % Viskositet for water [m/s^2]
%     est_visk(i) = (-2.6*10^-12)*temp(i)^3 + (5.8*10^-10)*temp(i)^2 - (4.7*10^-8)*temp(i) + (1.8*10^-6);
%     % Reynholds tal
%     Re(i) = (v*d) / est_visk(i);     % reinholds tal for each temp ((velocity * innerdiameter) / viskositet)
%     % lambda
%     lambda(i) = 0.316 / nthroot(Re(i),4);
%     % diff_pressure
%     Diffp(i) = (lambda(i)*rho*L*v^2)/2*d;
%     % pump power dep on temp and flow? 
%     for j=1:10
%         P(i,j)=(F(j)*Diffp(i))/eta; 
%     end
% end
% %%
% for i=1:12
%     Power(i) = (((lambda(7)*rho*L*(F(i)/A_inner)^2) / (2*d))*F(i) ) / rho;
% end
% %%
% subplot(2,1,1)
% plot(temp,visk)
% hold on 
% plot(temp,est_visk)
% legend('real','est')
% title('Calculated viskositet, dep on temp')
% 
% subplot(2,1,2)
% % for i=1:j
% % plot(temp,P(:,i))
% % hold on
% % end
% plot(F,Power)
% legend('Power pump')
% title('Calculated power, dep on temp, max-effekt')
% 
% %% for a read-file
% 
% QAll = (TEMP-TEMP2)*0.4430;
% plot(QAll)
% hold on
% Tj = (1.3236*TEMP - 0.6659*TEMP2 - QAll)/0.6577;
% plot(TEMP)
% plot(Tj)
% legend('Qtot','TW','Tj')

%% Energy put into the system; Accumulation energy
% Qacc = QElem + QPump - QJacket - QMeat

clear all
close all

a = 1.675091827e-3;
b = 1.857536553e-4;
c = 5.373169834e-7;

fid = fopen('heating_PID_3L.txt');
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

figure, subplot(2,1,1);
plot(time1, Tw1, ':r', 'LineWidth', 2);
xlabel('Time [s]')
ylabel('Temp C')
title('Water heating')
hold on
plot(time1, Tr1, ':b', 'LineWidth', 2);
plot(time1, Tj1, ':m', 'LineWidth', 2);
plot(time1, refTemp, ':k', 'LineWidth', 2);

legend('Water temp', 'Room temp', 'Jacket temp', 'Reference temp', 'Location', 'NorthWest');
subplot(2,1,2);
plot(time1, power, ':b', 'LineWidth', 2);
xlabel('Time [s]')
ylabel('Power [W]')
legend('Power input')
%%
A =[-0.0003989310519145378]
B = [0.00010763]

sys=ss(A,B,1,0)
figure(2)
bode(sys)

