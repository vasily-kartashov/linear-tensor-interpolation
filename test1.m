function test1

    grid = ltgrid([-1 1 -1 1], [1e2, 1e2]);
    
    f = @(x, y) min(1, max(0, sin(pi * x) .* exp(y .^ 2)));
    
    fs = zeros(grid.ns);
    for i = 1 : grid.ns(1)
        for j = 1 : grid.ns(2)
            fs(i, j) = f(grid.axes{1}(i), grid.axes{2}(j));
        end
    end
    
    g = @(x, y) ltinterp(grid, fs, [x, y]);
    h = @(x, y) f(x, y) - g(x, y);
    
    % display the approximation quality
    figure;
    subplot(1, 3, 1); ezsurf(f, grid.range);
    subplot(1, 3, 2); ezsurf(g, grid.range);
    subplot(1, 3, 3); ezsurf(h, grid.range);
    
    % benchmark
    n = 1e8;
    xs = randn(n, 1);
    ys = randn(n, 1);
    
    tic;
    g(xs, ys);
    fprintf('Vector size: %d, Time spent: %2.8f\n', n, toc);
    
end