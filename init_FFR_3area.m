%% Init file for Simulink model FFR_3area.slx

clear all; 
%% Power system contants
% Area 1
D = [0.015 0.016 0.015];
H = [0.1667 0.2017 0.1247] .* 0.5;
R = [3 2.73 2.82];
T_g = [0.08 0.06 0.07];
T_t = [0.40 0.44 0.30];
beta = [0.3483 0.3827 0.3692];
T_12 = 0.20;
T_13 = 0.25;
T_21 = 0.20;
T_23 = 0.12;
T_31 = 0.25;
T_32 = 0.12;


%% Controller tuning
Ki = [-0.3 -0.2 -0.4];