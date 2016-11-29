impulse)s3=% Model - Plant

% Constant input
k = 0.1;        % From measurements cooldowncoeff
m = 2;          % mass
c = 4.18;       % water heat capacity
Pc = 1200;        % constant effect, [Watt]

%A = [0,1,0;0,0,1;0,k^2, 2*k];
%b = [0;-(2*k)/(m*c);-(3*k^2)/(m*c)];
%C = [1,0,0];
%sys = ss(A,b,C,0);
%transf = tf([-2*k,k^2],[1,2*k,k^2,0]*(m*c))
A = [-k];
B = [Pc/m*c];
C = [1];
sys = ss(A,B,C,0,0);
impulse(sys)
hold on;
%% 

sys2 = ss(A2,B2,[1,0],0);

%q: rate to heat up
q = 0.003;
sys3 = tf([1,0],m*c*[1,q+k,q*k]);


%bodeplot(sys)
%nyquist(sys)