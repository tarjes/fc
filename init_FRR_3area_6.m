%% Init file for Simulink model FFR_3area_5.slx
% The demand from PI-controllers goes to control centre. Control Centre
% sets both delta_P_m and delta_tielines
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

L = 1000; % [MW] Power base value
K = 0.4 * L; % [MW/Hz] Regulation Strength

%% Tie-line capacities
T_cap = [inf 50 100; 50 inf 10; 100 10 inf];

%% Controller tuning
%Ki = [-0.3 -0.2 -0.4];
Kp = [-0.5 -0.5 -0.5];
Ki = [-0.006 -0.005 -0.004];

%% Sample time FRR-A
sample_time_frr_a = 10;

%% Load Merit Order Lists and sort w/ respect to price
% load('MO_1', 'MO_1'); load('MO_2', 'MO_2'); load('MO_3', 'MO_3');
% MO_1 = sortrows(MO_1, 3);
% MO_2 = sortrows(MO_2, 3);
% MO_3 = sortrows(MO_3, 3);
MO_up = xlsread('MO_up');
MO_down = xlsread('MO_down');
MO_up = sortrows(MO_up, 1);
MO_down = sortrows(MO_down, 1);