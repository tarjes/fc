%% Init file for Simulink model FFR_1_1.slx
% PID controller. Just for fun. 
clear all; 
%% Power system contants
T_g = 0.08;
T_t = 0.40;
R = 3;
H = 0.0833;
D = 0.015;

%% Controller tuning
Kp = -0.5;
Ki = -2;
Kd = -1;
D_filter = 100;