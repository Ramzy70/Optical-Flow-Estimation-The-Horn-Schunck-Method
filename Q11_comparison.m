%% Script: Question 11 - Gradient Comparison
clc; clear; close all;
addpath('CODES');

%% 1. Setup
image1_path = 'Road/0000.pgm';
image2_path = 'Road/0001.pgm';

if ~isfile(image1_path), error('Check path!'); end

Im1 = double(imread(image1_path));
Im2 = double(imread(image2_path));

alpha = 20;
iterations = 100;

%% 2. Run Original Method (Horn-Schunck Cube)
fprintf('Running ORIGINAL method...\n');
tic;
[u1, v1] = HS_optical_flow(Im1, Im2, alpha, iterations);
time1 = toc;

%% 3. Run Alternative Method (Simple Gradient)
fprintf('Running ALTERNATIVE method...\n');
tic;
[u2, v2] = HS_optical_flow_simple(Im1, Im2, alpha, iterations);
time2 = toc;

%% 4. Calculate Errors for Both
% Function to get mean residual error
get_error = @(u,v) mean(mean(abs(Im1 - interp2(Im1, Im2, (1:size(Im1,2))+u, (1:size(Im1,1))+v, 'linear', 0)) .* (interp2(Im1, Im2, (1:size(Im1,2))+u, (1:size(Im1,1))+v, 'linear', 0) ~= 0)));

% Note: We reconstruct Im1 from Im2 using warp
[rows, cols] = size(Im1);
[X, Y] = meshgrid(1:cols, 1:rows);

% Error 1 (Original)
Im2_rec1 = interp2(X, Y, Im2, X+u1, Y+v1, 'linear', 0);
mask1 = Im2_rec1 ~= 0;
err1 = mean(abs(Im1(mask1) - Im2_rec1(mask1)));

% Error 2 (Alternative)
Im2_rec2 = interp2(X, Y, Im2, X+u2, Y+v2, 'linear', 0);
mask2 = Im2_rec2 ~= 0;
err2 = mean(abs(Im1(mask2) - Im2_rec2(mask2)));

%% 5. Display Comparison
fprintf('\n--- COMPARISON RESULTS ---\n');
fprintf('Original (HS Cube) Error: %.4f (Time: %.2fs)\n', err1, time1);
fprintf('Alternative (Simple) Error: %.4f (Time: %.2fs)\n', err2, time2);

figure('Name', 'Question 11 Comparison');
subplot(1,2,1); 
imshow(abs(Im1 - Im2_rec1), [0 50]); colormap(gca, 'jet'); title(['Original Error: ' num2str(err1, '%.2f')]);
colorbar;

subplot(1,2,2); 
imshow(abs(Im1 - Im2_rec2), [0 50]); colormap(gca, 'jet'); title(['Simple Gradient Error: ' num2str(err2, '%.2f')]);
colorbar;