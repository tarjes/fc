function valid_flow = solveFlow(Pbus, Ymat, capMat)

N = length(Pbus);

Qbus = zeros(1,N);

%%%%%% FLOW SOLVER  %%%%%%
[~, ~, Imat, ~] = power_flow_solver(Ymat, Pbus, Qbus, 1);
flowMat = Imat(2:(N), 2:(N));
%%%%%%     DONE     %%%%%%%

% Get overload
overloadMat = abs(flowMat) - abs(capMat);
overload_values = overloadMat(overloadMat > 0);

if isempty(overload_values) == true
    valid_flow = 1;
else
    valid_flow = 0;
end

end