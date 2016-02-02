%% Init file for Simulink model FFR_1_0.slx
% The simulation achieves the exact same results as in Fig. 2.6 in
% (Bevrani)
clear all; 
%% Power system contants
T_g = 0.08;
T_t = 0.40;
R = 3;
H = 0.0833;
D = 0.015;

%% Controller tuning
Ki = -0.3;