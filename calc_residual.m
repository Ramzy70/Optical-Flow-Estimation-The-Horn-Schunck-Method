function [mean_err, err_map, Im_rec] = calc_residual(Im1, Im2, u, v)
% CALC_RESIDUAL Warps Im2 back to Im1 using flow (u,v) and computes error.
%   [mean_err, err_map, Im_rec] = calc_residual(Im1, Im2, u, v)
%
%   Ref: TP2 Exercise 1, Question 10

    [rows, cols] = size(Im1);
    [X, Y] = meshgrid(1:cols, 1:rows);

    % 1. Determine coordinates in Image 2
    X_warped = X + u;
    Y_warped = Y + v;

    % 2. Interpolate Image 2 at these new positions (Warping)
    % Fill out-of-bounds with 0
    Im_rec = interp2(X, Y, Im2, X_warped, Y_warped, 'linear', 0);

    % 3. Calculate absolute difference (Residual Error)
    % Formula: | I(x,y,t) - I(x+dx, y+dy, t+dt) |
    err_map = abs(Im1 - Im_rec);

    % 4. Calculate Mean Error
    % Only consider valid pixels (where Im_rec is not 0 due to border)
    mask = Im_rec ~= 0;
    
    if sum(mask(:)) > 0
        mean_err = mean(err_map(mask));
    else
        mean_err = 0; % Edge case if everything is out of bounds
    end
end