clear all;
test1; % load example data
demand = sum(demands);
[n, m] = size(Q_max);

% Decision variables
P = sdpvar(n,m,'full');
delta = sdpvar(n,1,'full');
delta(1) = 0; % Phase angle reference

% Help variables
flow = D*A*delta;
prod = sum(P')';

% Set contraints
matchTotalDemand = sum(prod) == demand;
bidSizeMin = Q_min <= P;
bidSizeMax = P <= Q_max;
findAngles = prod - demands == B_prime*delta;
flowCapMin = flow >= minFlowVector;
flowCapMax = flow <= maxFlowVector;

Constraints = [matchTotalDemand bidSizeMin bidSizeMax findAngles flowCapMin flowCapMax];

% Set objective function
powerCost = sum(sum(C .* abs(P)));
clogCost = sum(costFlowArray*abs(flow));

Objective = powerCost + clogCost;

% Solve the problem
optimize(Constraints,Objective)

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