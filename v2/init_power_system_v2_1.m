%% Init file for Simulink model power_system_v2.1.slx
% 
clear all;

%% System wide settings
N = 5; % Number of control areas
L = 1000; % [MW] Power base value

%% Control Center
% Sample time for generating new AGC set-points
sample_time_frr_a = 10;

% Extract FRR-A bids to matrices 
bidListUp = xlsread('FRR-A_bids_up_few');
bidListDown = xlsread('FRR-A_bids_down');
[Q_min_up, Q_max_up, C_up] = generateBidMat(bidListUp, N);
[Q_min_down, Q_max_down, C_down] = generateBidMat(bidListDown, N);

flowCost = 0.001;

%% Parameters for control areas
% parameters = [T_g T_t H D R beta Kp Ki] Obs! Kp not in model
area_param_1 = [0.08 0.40 0.0833 0.015 3.00 0.3483 0 -0.004];
area_param_2 = [0.06 0.46 0.1008 0.016 2.73 0.3827 0 -0.005];
area_param_3 = [0.07 0.30 0.0624 0.015 2.82 0.3692 0 -0.006];
area_param_4 = [0.06 0.35 0.0667 0.015 2.90 0.3500 0 -0.004];
area_param_5 = [0.06 0.35 0.0667 0.015 2.90 0.3500 0 -0.004];


%% Tieline Parameters
% TIE-LINE CONNECTION MATRIX
% [branches, nodes]
A = [   1  -1  0   0    0;   
        1   0   -1  0   0;
        0   1   -1  0   0;
        0   0   1   -1  0;
        0   0   0   1   -1];
    
% Capacity
minFlowVector = -[40 40 10 40 40]';
maxFlowVector = [40 40 10 40 40]';

%% Tieline Admittance
Y_12 = 0.20;
Y_13 = 0.25; 
Y_23 = 0.12; 
Y_34 = 0.15;
Y_45 = 0.15; 

Y = [Y_12 Y_13 Y_23 Y_34 Y_45];

% Admittance matrix must have zeros on diagonal
Ymat = [0       Y_12    Y_13    0       0;
        Y_12    0       Y_23    0       0;
        Y_13    Y_23    0       Y_34    0;
        0       0       Y_34    0       Y_45;
        0       0       0       Y_45    0];

B_prime = diag(sum(Ymat,2)') - Ymat;  

% Negative suseptence 
D = diag(Y);      



