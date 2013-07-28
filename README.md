linear-tensor-interpolation
===========================

Linear tensor interpolation in Matlab over a uniform grid


Compilation
------------------
Compile the extension for you platform
    mex ltinterp.c


Setting up the grid
------------------
First step is to create a tensor domain over which you want to interpolate the function. The following line creates a grid with 
x-coordinate stretching from -1 to 1 and y-coordinate stretching from -2 to 3. There are 100 points in each direction. The grid is uniform.
    
    grid = ltgrid([-1 1 -2 3], [1e2, 1e2]);



Initializing the grid
------------------
The next step is to store the values of the function in the values hypermatrix. The property grid.ns gives you an initializing value for 
zeros constructor.

    fs = zeros(grid.ns);
    for i = 1 : grid.ns(1)
        for j = 1 : grid.ns(2)
            fs(i, j) = f(grid.axes{1}(i), grid.axes{2}(j));
        end
    end


Interpolation
------------------
Once the grid is set up and initialized you can use ltinterp to interpolate the values. 

    g = @(x, y) ltinterp(grid, fs, [x, y]);

You can interpolate multiple values at once by putting a multiple rows as third argument into ltinterp. The resulting vector always has 
1 column and as many rows as the third argument.