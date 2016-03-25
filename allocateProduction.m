% Demand input
demands = [20 0 20 10]';
N = length(demands);

% Create merrit lists
MO_up = xlsread('MO_up_all2');
MO_down = xlsread('MO_down');
MO_up = sortrows(MO_up, 1);
MO_down = sortrows(MO_down, 1);

prod = zeros(N,1);

% Sum demands
demand = sum(demands);
% orders = zeros(max(length(MO_up),length(MO_down)),3);
orders = zeros(1,3);
export = prod - demands;
% Set capacities
capMat = [0 40 40 0; 40 0 10 0; 40 10 0 40; 0 0 40 0];

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
    
Qbus = zeros(1,N+1);
Pbus = [0 export'];
%% START



% If frequency is too low
if demand >= 0
    % Check if MO_up is empty
    for i = 1:length(MO_up)
        % Define variables
        PRICE = MO_up(i, 1);
        QUANTITY = MO_up(i, 2);
        AREA = MO_up(i, 3);
       
        prod_try = min(demand, QUANTITY);
        while 2 > 1
            export = prod - demands;
            Pbus = [0 export'];
            %%%%%% FLOW SOLVER  %%%%%%
            Pbus(AREA+1) = Pbus(AREA+1) + prod_try;
            [Ebus, Ibus, Imat, iter] = power_flow_solver(Ymat, Pbus, Qbus, 1);
            flowMat = Imat(2:(N+1), 2:(N+1));
            %%%%%%     DONE     %%%%%%%

            % Get overload
            overloadMat = abs(flowMat) - abs(capMat);
            overload_values = overloadMat(overloadMat > 0);
            
            % Check whether any tie-lines will be overloaded
            if isempty(overload_values) == true 
                % Soulution is within capacities.
                prod(AREA) = prod(AREA) + prod_try; % update prodction
                demand = demand - prod_try; % Update demand
                % UPDATE SOME LISTS AND STUFF
                orders = [orders; PRICE prod_try AREA] 
                break;
            else
                % Try a lower production
                prod_try = max(0, prod_try - 1);
            end
        end
        if demand == 0
            break;
        end
    end
    
    
    
% If frequency is too high
else
    demand = abs(demand); % Change sign of demand
    % Check if MO_down is empty
    for i = 1:length(MO_down)
        % Define variables
        PRICE = MO_down(i, 1);
        QUANTITY = MO_down(i, 2);
        AREA = MO_down(i, 3);
        LEFT = MO_down(i, 4);
        
        q = QUANTITY;
        if demand > q
            prod(AREA) = prod(AREA) - q;
            orders(i,:) = MO_down(i,:);
            demand = demand - q;
        else
            prod(AREA) = prod(AREA) - demand;
            orders(i,:) = MO_down(i,:);
            orders(i,2) = demand;
            demand = 0;
            break;
        end
    end
    if demand ~= 0
        % Not enough DOWN-bids
    end
end


% Find flow between areas
export = prod - demands;

% TESTING simulink-matlab
y = 0;
coder.extrinsic('myFunc')
y = myFunc(42);

% Find total cost
total_cost = 0;
[rows, columns] = size(orders);
for i = 1:rows
    total_cost = total_cost + orders(i,1) * orders(i,2);
end