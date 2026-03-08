function [u, v] = HS_optical_flow_warm(img1, img2, alpha, max_iter, u_init, v_init)
% HS_OPTICAL_FLOW_WARM Same as HS, but accepts initial u_init, v_init
% This allows "Temporal Initialization" from the previous frame.

    img1 = double(img1);
    img2 = double(img2);

    % Derivatives (Standard 2x2x2 Cube)
    Kx = (1/4) * [-1  1; -1  1];
    Ky = (1/4) * [-1 -1;  1  1];
    Kt = (1/4) * [ 1  1;  1  1];
    HO = [1/12 1/6 1/12; 1/6 0 1/6; 1/12 1/6 1/12];

    Ex = imfilter(img1, Kx, 'replicate', 'same') + imfilter(img2, Kx, 'replicate', 'same');
    Ey = imfilter(img1, Ky, 'replicate', 'same') + imfilter(img2, Ky, 'replicate', 'same');
    Et = imfilter(img2, Kt, 'replicate', 'same') - imfilter(img1, Kt, 'replicate', 'same');

    % INITIALIZATION: Use the input guess instead of zeros
    if nargin < 5 || isempty(u_init)
        u = zeros(size(img1));
        v = zeros(size(img1));
    else
        u = u_init;
        v = v_init;
    end

    Denom = alpha^2 + Ex.^2 + Ey.^2;

    % Iterations
    for i = 1:max_iter
        u_bar = imfilter(u, HO, 'replicate', 'same');
        v_bar = imfilter(v, HO, 'replicate', 'same');
        
        factor = (Ex .* u_bar + Ey .* v_bar + Et) ./ Denom;
        
        u = u_bar - Ex .* factor;
        v = v_bar - Ey .* factor;
    end
end