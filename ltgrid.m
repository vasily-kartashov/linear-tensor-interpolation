% Copyright (c) 2013 Vasily Kartashov <info@kartashov.com>
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
% documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
% rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
% permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
% Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
% WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
% COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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