function [u, v] = HS_optical_flow_simple(img1, img2, alpha, max_iter)
% HS_OPTICAL_FLOW_SIMPLE 
% Same as standard HS, but uses SIMPLE gradients (Central Difference)
% instead of the 2x2x2 Cube average.

    % 1. Convert to double
    img1 = double(img1);
    img2 = double(img2);

    % 2. Alternative Gradient Calculation
    % Instead of the complex Horn-Schunck cube, we use simple filters.
    
    % Simple Central Difference Kernel for Spatial
    % (Looks at left/right neighbors instead of the cube)
    Kx = [-1/2, 0, 1/2];
    Ky = [-1/2; 0; 1/2];
    
    % Calculate Ex and Ey using only the first image (Standard approach)
    % (Or average of both, but simple method usually just uses frame 1)
    Ex = imfilter(img1, Kx, 'replicate', 'same');
    Ey = imfilter(img1, Ky, 'replicate', 'same');
    
    % Calculate Et as simple difference
    Et = img2 - img1;

    % 3. Laplacian Kernel (Same as original)
    HO = [1/12 1/6 1/12; 
          1/6   0  1/6; 
          1/12 1/6 1/12];

    % 4. Initialization
    [rows, cols] = size(img1);
    u = zeros(rows, cols);
    v = zeros(rows, cols);

    Denom = alpha^2 + Ex.^2 + Ey.^2;

    % 5. Iterative Loop (Same as original)
    fprintf('Starting Simple-Gradient iterations...\n');
    for i = 1:max_iter
        u_bar = imfilter(u, HO, 'replicate', 'same');
        v_bar = imfilter(v, HO, 'replicate', 'same');
        
        factor = (Ex .* u_bar + Ey .* v_bar + Et) ./ Denom;
        
        u = u_bar - Ex .* factor;
        v = v_bar - Ey .* factor;
    end
    fprintf('Done.\n');
end