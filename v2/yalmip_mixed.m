clear all;
test1; % load example data
demand = sum(demands);
[n, m] = size(Q_max);

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
prodSlackCost = sum(prod_slack)*10000

Objective = powerCost + clogCost;

% Solve the problem
res = optimize(Constraints,Objective)

% If no feasible solution, get best effort solution
if res.problem
    fprintf('NO FEASIBLE SOLUTION EXCIST. DEMAND CANNOT BE MET. FINDING BEST-EFFORT SOLUTION...\n');
    Constraints = [noOverproduction bidSizeMin bidSizeMax findAnglesWithSlack flowCapMin flowCapMax];
    Objective = powerCost + clogCost + prodSlackCost;
    optimize(Constraints,Objective)
end

% Store result in variables
bids = value(P);
prod_array = value(prod)';
flow_array = value(flow)';
cost.power = value(powerCost);
cost.clog = value(clogCost);

% Display
prod_array
flow_array
cost