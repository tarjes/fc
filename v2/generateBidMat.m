function [Q_min, Q_max, C] = generateBidMat(bidList, N)
    
    bids = zeros(1,N);
    
    [n_bids, ~] = size(bidList);
    
    % Count bids from each area
    for i = 1:n_bids
        AREA = bidList(i,3);
        bids(AREA) = bids(AREA) + 1;        
    end
    M = max(bids); 
    
    % Set size of bid matrices
    Q_min = zeros(N,M); Q_max = zeros(N,M); C = zeros(N,M);
    
    % Set data from bidList to bid matrices
    counter = zeros(1,N);
    for i = 1:n_bids
        PRICE = bidList(i,1); QUANTITY = bidList(i,2); AREA = bidList(i,3);
        
        if AREA <= N
            counter(AREA) = counter(AREA) + 1;
            C(AREA, counter(AREA)) = PRICE;
            if QUANTITY < 0
                Q_min(AREA, counter(AREA)) = QUANTITY;
                Q_max(AREA, counter(AREA)) = 0;
            else
                Q_min(AREA, counter(AREA)) = 0;
                Q_max(AREA, counter(AREA)) = QUANTITY;
            end
        end
    end
    
    if bids ~= counter
        msg = 'Error: generateBidMat - Matrix counter mismatch \n';
        error(msg)
    end
end