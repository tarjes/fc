function export = meritOrder(demands, MO_up, MO_down)

% Define variables
PRICE = 1;
QUANTITY = 2;
AREA = 3;
LEFT = 4;

prod = zeros(length(demands),1);

% Sum demands
demand = sum(demands);

% If frequency is too low
if demand >= 0
    % Check if MO_up is empty
    for i = 1:length(MO_up)
        q = MO_up(i, QUANTITY);
        if demand > q
            prod(MO_up(i,AREA)) = prod(MO_up(i,AREA)) + q;
            demand = demand - q;
        else
             prod(MO_up(i,AREA)) = prod(MO_up(i,AREA)) + demand;
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
            demand = demand - q;
        else
             prod(MO_down(i,AREA)) = prod(MO_down(i,AREA)) - demand;
             demand = 0;
             break;
        end
    end
    if demand ~= 0
        % Not enough DOWN-bids
    end
end

% Solve bill settle problem
export = prod - sum(prod)/length(prod);


end


   
    
