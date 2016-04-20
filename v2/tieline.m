% input
f = [0.1 0 -0.1 0.5];
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

N = length(f);

% Create delta_f
f_ones = ones(N,N);
f_hor = zeros(N);
f_ver = zeros(N);
for i = 1:N
    f_hor(i,:) = f(i) .* f_ones(i,:); 
    f_ver(:,i) = f(i) .* f_ones(:,i);
end
delta_f = f_hor - f_ver;

% Multiply delta_f with admittance and 2PI
tielines = delta_f .* Ymat .* 2 * pi;

% Integrate tielines

export = sum(tielines');


