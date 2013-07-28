function grid = ltgrid(range, ns)

    grid = [];
    
    % store the data
    grid.range = range;
    grid.ns = ns;
    
    % add axes and steps along them
    d = numel(ns);
    grid.axes  = cell(d, 1);
    grid.dx    = zeros(d, 1);
    grid.ix    = zeros(d, 1);
    grid.lb    = zeros(d, 1);
    grid.ub    = zeros(d, 1);
    for i = 1 : d
        grid.axes{i} = linspace(range(i * 2 - 1), range(i * 2), ns(i))';
        grid.dx(i)   = grid.axes{i}(2) - grid.axes{i}(1);
        grid.ix(i)   = 1 / grid.dx(i);
        grid.lb(i)   = grid.axes{i}(1);
        grid.ub(i)   = grid.axes{i}(end);
    end

    % store the corners of the hypercube
    grid.corners = (dec2bin(0 : (2 ^ d - 1)) == '1');
    grid.cnum = size(grid.corners, 1);
    
    % grid index to linear index
    grid.gi2li = cumprod([1, ns(1 : end - 1)])';
    
    % corner offsets
    grid.coffs = grid.corners * grid.gi2li;
    
    % prepare data for c
    grid.ns      = int32(grid.ns);
    grid.corners = int32(grid.corners);
    grid.cnum    = int32(grid.cnum);
    grid.gi2li   = int32(grid.gi2li);
    grid.coffs   = int32(grid.coffs);
    
end