demands = [0 0 20 0]';

bidList = xlsread('FRR-A_bids_up_few');
[Q_min, Q_max, C] = generateBidMat(bidList, 4);

% TIE-LINE CONNECTION MATRIX
A = [   1  -1  0   0;   
        1   0   -1  0;
        0   1   -1  0;
        0   0   1   -1];

Y_12 = 0.20;
Y_13 = 0.25; 
Y_23 = 0.12; 
Y_34 = 0.15; 
    
Y = [Y_12 Y_13 Y_23 Y_34];
minFlowVector = -[40 40 10 40]';
maxFlowVector = [40 40 10 40]';
flowCost = 0.001;

% Negative suseptence 
D = diag(Y);      

% Admittance matrix
T_12 = 0.20;
T_13 = 0.25; 
T_23 = 0.12; 
T_34 = 0.15; 
T_14 = 0; 
T_24 = 0; 

% Admittance matrix must have zeros on diagonal
Ymat = [   0       T_12    T_13    T_14;
        T_12    0       T_23    T_24;
        T_13    T_23    0       T_34;
        T_14    T_24    T_34    0];

B_prime = diag(sum(Ymat')) - Ymat;









