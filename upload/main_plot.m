clear all
close all

a = 1.675091827e-3;
b = 1.857536553e-4;
c = 5.373169834e-7;

fid = fopen('dataex3A_heatoff_pumpon_2.txt');
data1 = fscanf(fid, '%f');
fclose(fid);

fid = fopen('data4A_hpon_and_hpoff_2.txt');
data2 = fscanf(fid, '%f'); %remove 13 samples in the beginning
data2 = data2(73:end);
fclose(fid);

%fid = fopen('data6A_heatoff_pumpon_3.txt');
fid = fopen('data6A2_heatoff_pumpon_3.txt');
data3 = fscanf(fid, '%f');
data3 = data3(73:end);
fclose(fid);

fid = fopen('data5A_hpon_and_hpoff_3.txt'); %remove 12 samples
data4 = fscanf(fid, '%f');
data4 = data4(37:end);
fclose(fid);

fid = fopen('data7A_heaton_pumpon_2-5.txt'); %remove x samples
data5 = fscanf(fid, '%f');
data5 = data5(49:end);
fclose(fid);

fid = fopen('data8A_heaton_pumpoff_2-5.txt');
data6 = fscanf(fid, '%f');
data6 = data6(49:end);
fclose(fid);

time1 = data1(1:3:length(data1))/1000;
time1 = time1-time1(1);
analog11 = data1(2:3:length(data1));
analog21 = data1(3:3:length(data1));

time2 = data2(1:3:length(data2))/1000;
time2 = time2-time2(1);
analog12 = data2(2:3:length(data2));
analog22 = data2(3:3:length(data2));

time3 = data3(1:3:length(data3))/1000;
time3 = time3 - time3(1);
analog13 = data3(2:3:length(data3));
analog23 = data3(3:3:length(data3));

time4 = data4(1:3:length(data4))/1000;
time4 = time4 - time4(1);
analog14 = data4(2:3:length(data4));
analog24 = data4(3:3:length(data4));

time5 = data5(1:3:length(data5))/1000;
time5 = time5 - time5(1);
analog15 = data5(2:3:length(data5));
analog25 = data5(3:3:length(data5));

time6 = data6(1:3:length(data6))/1000;
time6 = time6 - time6(1);
analog16 = data6(2:3:length(data6));
analog26 = data6(3:3:length(data6));

Rw1 = (2250600./analog11) - 2200;
Rwlog1 = log(Rw1);
Rr1 = (2250600./analog21) - 2200;
Rrlog1 = log(Rr1);

Rw2 = (2250600./analog12) - 2200;
Rwlog2 = log(Rw2);
Rr2 = (2250600./analog22) - 2200;
Rrlog2 = log(Rr2);

Rw3 = (2250600./analog13) - 2200;
Rwlog3 = log(Rw3);
Rr3 = (2250600./analog23) - 2200;
Rrlog3 = log(Rr3);

Rw4 = (2250600./analog14) - 2200;
Rwlog4 = log(Rw4);
Rr4 = (2250600./analog24) - 2200;
Rrlog4 = log(Rr4);

Rw5 = (2250600./analog15) - 2200;
Rwlog5 = log(Rw5);
Rr5 = (2250600./analog25) - 2200;
Rrlog5 = log(Rr5);

Rw6 = (2250600./analog16) - 2200;
Rwlog6 = log(Rw6);
Rr6 = (2250600./analog26) - 2200;
Rrlog6 = log(Rr6);

Tw1 = (1./(a + b.*Rwlog1 + c.*(Rwlog1.^3)))-273.15;
Tr1 = (1./(a + b.*Rrlog1 + c.*(Rrlog1.^3)))-273.15;

Tw2 = (1./(a + b.*Rwlog2 + c.*(Rwlog2.^3)))-273.15;
Tr2 = (1./(a + b.*Rrlog2 + c.*(Rrlog2.^3)))-273.15;

Tw3 = (1./(a + b.*Rwlog3 + c.*(Rwlog3.^3)))-273.15;
Tr3 = (1./(a + b.*Rrlog3 + c.*(Rrlog3.^3)))-273.15;

Tw4 = (1./(a + b.*Rwlog4 + c.*(Rwlog4.^3)))-273.15;
Tr4 = (1./(a + b.*Rrlog4 + c.*(Rrlog4.^3)))-273.15;

Tw5 = (1./(a + b.*Rwlog5 + c.*(Rwlog5.^3)))-273.15;
Tr5 = (1./(a + b.*Rrlog5 + c.*(Rrlog5.^3)))-273.15;

Tw6 = (1./(a + b.*Rwlog6 + c.*(Rwlog6.^3)))-273.15;
Tr6 = (1./(a + b.*Rrlog6 + c.*(Rrlog6.^3)))-273.15;

[~, pos1] = min(abs(85-Tw1));
[~, pos2] = min(abs(85-Tw2));
[~, pos3] = min(abs(85-Tw3));
[~, pos4] = min(abs(85-Tw4));
[~, pos5] = min(abs(85-Tw5));
[~, pos6] = min(abs(85-Tw6));

figure, subplot(1,2,1);
plot(time1(pos1:end)-time1(pos1), Tw1(pos1:end), '*r');

hold on
plot(time2(pos2:end)-time2(pos2), Tw2(pos2:end), '^r');
plot(time3(pos3:end)-time3(pos3), Tw3(pos3:end), '*b');
plot(time4(pos4:end)-time4(pos4), Tw4(pos4:end), '^b');
plot(time5(pos5:end)-time5(pos5), Tw5(pos5:end), '*k');
plot(time6(pos6:end)-time6(pos6), Tw6(pos6:end), '^k');
legend('pump 2l','no pump 2l','pump 3l','no pump 3l','pump 2.5l','no pump 2.5l')
%subplot(1,2,2);
%plot(time1, Tr1, '*r');
%ylim([20,27])
k = [0.0001621, 0.000104, 0.0001246, 0.00008305, 0.0001337, 0.00009111];
timex = linspace(0,10000,1000);
a = 24.3;
b = 85-a;
tempx = {[a + b*exp(-k(1)*timex)],[a + b*exp(-k(2)*timex)],[a + b*exp(-k(3)*timex)],[a + b*exp(-k(4)*timex)],[a + b*exp(-k(5)*timex)],[a + b*exp(-k(6)*timex)]};
plot(timex, tempx{1},'r');
hold on
plot(timex, tempx{2},'r');
plot(timex, tempx{3},'b');
plot(timex, tempx{4},'b');
plot(timex, tempx{5},'k');
plot(timex, tempx{6},'k');
ylim([45,90]);