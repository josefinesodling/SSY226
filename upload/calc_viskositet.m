clear all
clc
%% INSERT POWER gives FLOW! this is maximum
F = [0.001 0.002 0.005 0.006 0.008 0.01 0.02 0.05 0.06 0.08 0.09 0.1]/(10^3);                         % flow 6[liter/min] gives 0.1/10^3[m^3/s]
P = 35;
%% Calculate pressure diff
d = 0.01;                               % [m]innerdiameter of the hose
A_inner = (d/2)^2*pi;                   % inner area of hose [m^2]
v = F(12)/A_inner;                          % velocity inside hose [m/s]
rho = 1000;                             % [kg/m^3]
L = 1.5;                                % [m] length of hose
eta = 0.87*0.94;                        % efficiensy
%viskositet [m/s^2]
visk = [1.792 1.519 1.308 1.005 .801 .656 .549 .469 .406 .357 .317 .284]./1000000;
temp = [0 5 10 20 30 40 50 60 70 80 90 100];

for i=1:length(temp)
    % Viskositet for water [m/s^2]
    est_visk(i) = (-2.6*10^-12)*temp(i)^3 + (5.8*10^-10)*temp(i)^2 - (4.7*10^-8)*temp(i) + (1.8*10^-6);
    % Reynholds tal
    Re(i) = (v*d) / est_visk(i);     % reinholds tal for each temp ((velocity * innerdiameter) / viskositet)
    % lambda
    lambda(i) = 0.316 / nthroot(Re(i),4);
    % diff_pressure
    Diffp(i) = (lambda(i)*rho*L*v^2)/2*d;
    % pump power dep on temp and flow? 
    for j=1:10
        P(i,j)=(F(j)*Diffp(i))/eta; 
    end
end
%%
for i=1:12
    Power(i) = (((lambda(7)*rho*L*(F(i)/A_inner)^2) / (2*d))*F(i) ) / rho;
end
%%
subplot(2,1,1)
plot(temp,visk)
hold on 
plot(temp,est_visk)
legend('real','est')
title('Calculated viskositet, dep on temp')

subplot(2,1,2)
% for i=1:j
% plot(temp,P(:,i))
% hold on
% end
plot(F,Power)
legend('Power pump')
title('Calculated power, dep on temp, max-effekt')

%% for a read-file

QAll = (TEMP-TEMP2)*0.4430;
plot(QAll)
hold on
Tj = (1.3236*TEMP - 0.6659*TEMP2 - QAll)/0.6577;
plot(TEMP)
plot(Tj)
legend('Qtot','TW','Tj')

%% Energy put into the system; Accumulation energy
% Qacc = QElem + QPump - QJacket - QMeat
dTEMP=(1/8362).*(0.9E-4+0.9E0.*PPump(t)+(-0.443E0).*((-297)+TW(t))+( ...
  -0.348734E-1).*TW(t)+(-0.651675E1).*(TW(t)+(-0.147514E1).*(( ...
  -0.191773E3)+(-0.943E0).*((-297)+TW(t))+0.13236E1.*TW(t))));
