%% Make graph
close all;
Acost = [0 2 1 0; 2 0 2 0; 1 2 0 4; 0 0 4 0];
Acap = [0 40 40 0; 40 0 10 0; 40 10 0 40; 0 0 40 0];
node_names = {'A','B','C','D'};
Gcost = graph(Acost,node_names);
G = graph(Acost, node_names);
G.Edges.Cap = Acap;
N = length(node_names);

%figure(1)
%plot(Gcost,'EdgeLabel', Gcost.Edges.Weight);

%figure(2)
%plot(Gcap,'EdgeLabel', Gcap.Edges.Weight);

%% Init
% Admittance matrix
T_12 = 0.20;
T_13 = 0.25;
T_21 = 0.20;
T_23 = 0.12;
T_31 = 0.25;
T_32 = 0.12;
T_34 = 0.15;
T_43 = 0.15;

con = 10000000;

Ymat = [0 con 0 0 0;
        con 0 T_12 T_13 0;
        0 T_21 0 T_23 0;
        0 T_31 T_32 0 T_34;
        0 0 0 T_43 0].*1000000;
    

%% START

% Demand input
G.Nodes.Demand = [20 0 20 10]';

% Create merrit lists
MO_up = xlsread('MO_up_all2');
MO_down = xlsread('MO_down');
MO_up = sortrows(MO_up, 1);
MO_down = sortrows(MO_down, 1);

% Initial guess 
[G.Nodes.Export, G.Nodes.Prod, orders, total_cost] = meritOrder(G.Nodes.Demand, MO_up, MO_down); 

%G.Nodes.Export = [-20 10 -20 -10]';

for i = 1:10

    %%%%%% CALCULATE POWER FLOW %%%%%%%%
    % Define power vectors:
    Pbus = [0 G.Nodes.Export'];
    Qbus = zeros(1,N+1);
    % run function to solve the power flow
    [Ebus, Ibus, Imat, iter] = power_flow_solver(Ymat, Pbus, Qbus, 1);

    G.Edges.Flow = Imat(2:(N+1), 2:(N+1));
    demand_left_OPF = Imat(1,2);
    demand_left = sum(G.Nodes.Demand) - sum(G.Nodes.Prod);
    %%%%%% DONE %%%%%%%
   
    % Get overload
    G.Edges.Overload = abs(G.Edges.Flow) - abs(G.Edges.Cap);
    overload_values = G.Edges.Overload(G.Edges.Overload > 0)
    
    if isempty(overload_values) == true 
        % Soulution is within capacities. 
        break; 
    end
end