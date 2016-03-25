function [export, prod, orders, total_cost] = meritOrder(demands, MO_up, MO_down)

% Define variables
PRICE = 1;
QUANTITY = 2;
AREA = 3;
LEFT = 4;

prod = zeros(length(demands),1);

% Sum demands
demand = sum(demands);
orders = zeros(max(length(MO_up),length(MO_down)),3);

% If frequency is too low
if demand >= 0
    % Check if MO_up is empty
    % orders = zeros(length(MO_up),3); % Declare max size of orders output
    for i = 1:length(MO_up)
        q = MO_up(i, QUANTITY);
        if demand > q
            prod(MO_up(i,AREA)) = prod(MO_up(i,AREA)) + q;
            orders(i,:) = MO_up(i,:);
            demand = demand - q;
        else
            prod(MO_up(i,AREA)) = prod(MO_up(i,AREA)) + demand;
            orders(i,:) = MO_up(i,:);
            orders(i,QUANTITY) = demand;
            demand = 0;
            break;
        end
    end
    if demand ~= 0
        % Not enough UP-bids
    end
% If frequency is too high
else
    demand = abs(demand); % Change sign of demand
    % Check if MO_down is empty
    for i = 1:length(MO_down)
        q = MO_down(i, QUANTITY);
        if demand > q
            prod(MO_down(i,AREA)) = prod(MO_down(i,AREA)) - q;
            orders(i,:) = MO_down(i,:);
            demand = demand - q;
        else
            prod(MO_down(i,AREA)) = prod(MO_down(i,AREA)) - demand;
            orders(i,:) = MO_down(i,:);
            orders(i,QUANTITY) = demand;
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
for i = 1:length(orders)
    total_cost = total_cost + orders(i,PRICE) * orders(i,QUANTITY);
end