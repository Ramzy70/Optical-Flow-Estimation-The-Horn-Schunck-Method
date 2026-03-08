%% Script: Question 10 - Residual Error Analysis
clc; clear; close all;
addpath('CODES');

%% 1. Setup & Run Optical Flow
image1_path = 'Road/0000.pgm';
image2_path = 'Road/0001.pgm';

if ~isfile(image1_path), error('Check path!'); end

Im1 = double(imread(image1_path));
Im2 = double(imread(image2_path));

alpha = 20;
iterations = 100;

fprintf('Computing Optical Flow (Alpha=%d)...\n', alpha);
[u, v] = HS_optical_flow(Im1, Im2, alpha, iterations);

%% 2. Calculate Residual Error (Using your new function)
% This satisfies the "Write a function" requirement of Q10
[mean_error, ResidualError, Im2_reconstructed] = calc_residual(Im1, Im2, u, v);

% PRINT IT to Command Window (so you can copy-paste to text report)
fprintf('------------------------------------------------\n');
fprintf('RESULT Q10: Mean Residual Error = %.4f gray levels\n', mean_error);
fprintf('------------------------------------------------\n');

%% 3. Visualization
figure('Name', 'Question 10: Residual Error');

% Show Original
subplot(2,2,1); imshow(uint8(Im1)); title('Original Image 1');

% Show Reconstructed
subplot(2,2,2); imshow(uint8(Im2_reconstructed)); title('Reconstructed from Im2');

% Show The Error Map
subplot(2,2,3); 
imshow(ResidualError, []); 
colormap(gca, 'jet'); 
colorbar;
title('Residual Error Map');

% Show Flow for context
subplot(2,2,4); 
imshow(Im1, []); hold on;
step=10;
[rows, cols] = size(Im1);
[X, Y] = meshgrid(1:cols, 1:rows);
quiver(X(1:step:end, 1:step:end), Y(1:step:end, 1:step:end), ...
       u(1:step:end, 1:step:end), -v(1:step:end, 1:step:end), 5, 'y');
title('Optical Flow Vectors');

% SAVE THE VALUE IN THE FIGURE TITLE
sgtitle(sprintf('Residual Analysis (Alpha=%d) | Mean Error: %.2f', alpha, mean_error));