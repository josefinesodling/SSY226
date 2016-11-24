k = 0.1;
m = 2;
c = 4.18;

A = [0,1,0;0,0,1;0,k^2, 2*k];
b = [0;-(2*k)/(m*c);-(3*k^2)/(m*c)];
C = [1,0,0];

sys = ss(A,b,C,0);

transf = tf([-2*k,k^2],[1,2*k,k^2,0]*(m*c))

step(sys)
hold on;
%bodeplot(sys)
%nyquist(sys)