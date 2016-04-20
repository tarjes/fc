function [production, export, shortage, bids, FRR_A_cost] = yalmip_power_flow(demands, Q_min, Q_max, C, B_prime, D, A, minFlowVector, maxFlowVector, flowCost)
fprintf('\n\n********** ALLOCATING PRODUCTION... ****************\n');

demand = sum(demands);

if demand < 0
    fprintf('Production DOWN\n');
    if sum(sum(Q_min)) > demand
        fprintf('NOT ENOUGH BIDS TO COVER DEMAND\n');
    end
else
    fprintf('Production UP\n');
    if sum(sum(Q_max)) < demand
        fprintf('NOT ENOUGH BIDS TO COVER DEMAND\n');
    end
end

[n, m] = size(Q_max);

fprintf('***** Finding solution... ***** \n');

% Decision variables
P = sdpvar(n,m,'full');
prod_slack = sdpvar(n,1,'full');
delta = sdpvar(n,1,'full');
delta(1) = 0; % Phase angle reference

% Help variables
flow = D*A*delta;

prod = sum(P,2);

% Set contraints
matchTotalDemand = sum(prod) == demand;
noOverproduction = prod_slack >= 0; 
bidSizeMin = Q_min <= P;
bidSizeMax = P <= Q_max;
findAngles = prod - demands == B_prime*delta;
findAnglesWithSlack = prod - demands + prod_slack == B_prime*delta;
flowCapMin = flow >= minFlowVector;
flowCapMax = flow <= maxFlowVector;

Constraints = [matchTotalDemand bidSizeMin bidSizeMax findAngles flowCapMin flowCapMax];

% Set objective function
powerCost = sum(sum(C .* abs(P)));
clogCost = flowCost*sum(abs(flow));
prodSlackCost = sum(prod_slack)*10000;

Objective = powerCost + clogCost;

% Solve the problem
res = optimize(Constraints,Objective);
no_solution = res.problem;

% If no feasible solution, get best effort solution
if no_solution
    fprintf('\n ***** Failed to find feasible solution. Demand cannot be met. ***** \n');
    fprintf('***** Finding best-effort solution... ***** \n');
    Constraints = [noOverproduction bidSizeMin bidSizeMax findAnglesWithSlack flowCapMin flowCapMax];
    Objective = powerCost + clogCost + prodSlackCost;
    res = optimize(Constraints,Objective);
    no_solution = res.problem;
    if no_solution
        fprintf('***** ERROR: No solution. Applying zero FRR-A production  ***** \n');
    else
        fprintf('***** Best-effort solution found ***** \n');
    end
else
    fprintf('***** Solution found ***** \n');
    prod_slack = zeros(n,1);
end

% Store result in variables
bids = value(P);
production = value(prod);
shortage = value(prod_slack);
cost.power = value(powerCost);
cost.clog = value(clogCost);
FRR_A_cost = cost.power;
export = production - demands;

% Zero FRR-A production
if no_solution
    bids = zeros(n,m);
    production = zeros(n,1);
    shortage = demands;
    cost.power = 0;
    cost.clog = 0;
    FRR_A_cost = cost.power;
    export = production - demands;
end

% Print to Matlab
prod_array = production';
flow_array = value(flow)';
shortage_array = shortage';
prod_array
flow_array
shortage_array
cost
fprintf('********** DONE ****************\n');