function [u, v] = HS_optical_flow(img1, img2, alpha, max_iter)
% HS_OPTICAL_FLOW Computes optical flow using Horn-Schunck method
%   [u, v] = HS_optical_flow(img1, img2, alpha, max_iter)
%
%   Inputs:
%       img1, img2 : Two subsequent image frames (grayscale, double)
%       alpha      : Smoothness weight (parameter)
%       max_iter   : Number of iterations
%
%   Outputs:
%       u, v       : Horizontal and vertical velocity components

    % 1. Convert images to double precision for calculation
    img1 = double(img1);
    img2 = double(img2);

    % 2. Define the Kernels from the Paper (Horn & Schunck)
    % The derivatives are estimated at the center of a 2x2x2 cube.
    
    % Kernel for Ex (Horizontal gradient)
    Kx = (1/4) * [-1  1; 
                  -1  1];
              
    % Kernel for Ey (Vertical gradient)
    Ky = (1/4) * [-1 -1; 
                   1  1];

    % Kernel for Et (Temporal gradient)
    Kt = (1/4) * [ 1  1; 
                   1  1];
    
    % Kernel for Laplacian Averaging (Weighted Average of neighbors)
    % 1/12 for corners, 1/6 for direct neighbors
    HO = [1/12 1/6 1/12; 
          1/6   0  1/6; 
          1/12 1/6 1/12];

    % 3. Calculate Derivatives
    % Ex: Apply Kx to both images and sum
    Ex = imfilter(img1, Kx, 'replicate', 'same') + imfilter(img2, Kx, 'replicate', 'same');
    
    % Ey: Apply Ky to both images and sum
    Ey = imfilter(img1, Ky, 'replicate', 'same') + imfilter(img2, Ky, 'replicate', 'same');
    
    % Et: Difference between next frame (img2) and current (img1)
    Et = imfilter(img2, Kt, 'replicate', 'same') - imfilter(img1, Kt, 'replicate', 'same');

    % 4. Initialization
    % Initialize velocity vectors u and v to zero
    [rows, cols] = size(img1);
    u = zeros(rows, cols);
    v = zeros(rows, cols);

    % Pre-compute denominator for efficiency
    Denom = alpha^2 + Ex.^2 + Ey.^2;

    % 5. Iterative Loop (Gauss-Seidel)
    fprintf('Starting Horn-Schunck iterations...\n');
    
    for i = 1:max_iter
        % Compute local averages u_bar and v_bar
        u_bar = imfilter(u, HO, 'replicate', 'same');
        v_bar = imfilter(v, HO, 'replicate', 'same');
        
        % Update equations
        factor = (Ex .* u_bar + Ey .* v_bar + Et) ./ Denom;
        
        u = u_bar - Ex .* factor;
        v = v_bar - Ey .* factor;
        
        % Display progress every 20 iterations
        if mod(i, 20) == 0
            fprintf('Iteration %d / %d\n', i, max_iter);
        end
    end
    fprintf('Done.\n');
end