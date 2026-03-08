%% Script: Run Optical Flow on Middlebury Sequence (Question 8 - Part 2)
clc; clear; close all;

% Add the CODES folder to path for visualization tools
addpath('CODES'); 

%% 1. Load Images (Middlebury Sequence)
% We will use 'RubberWhale' as the example.
% You can change 'RubberWhale' to 'Dimetrodon', 'Urban2', etc.
seq_name = 'RubberWhale'; 

% Construct paths based on your file structure
image1_path = fullfile('SEQUENCES_GT', seq_name, 'frame10.png');
image2_path = fullfile('SEQUENCES_GT', seq_name, 'frame11.png');

% Check if files exist
if ~isfile(image1_path)
   error('Cannot find images at: %s. \nCheck that you are in the "Files_TP2" folder!', image1_path);
end

% Read images
Im1_raw = imread(image1_path);
Im2_raw = imread(image2_path);

% IMPORTANT: Horn-Schunck works on brightness (grayscale).
% If images are RGB (Color), we must convert them.
if size(Im1_raw, 3) == 3
    Im1 = rgb2gray(Im1_raw);
    Im2 = rgb2gray(Im2_raw);
else
    Im1 = Im1_raw;
    Im2 = Im2_raw;
end

% Display original frame
figure; imshow(Im1_raw); title(['Original Frame 1: ' seq_name]);

%% 2. Parameters (Question 6)
% Middlebury sequences are often cleaner than the Road sequence,
% but they might have larger motion.
alpha = 15;        % Smoothness weight
iterations = 100;  % Number of iterations

%% 3. Run Algorithm (Question 7)
fprintf('Running Optical Flow on %s...\n', seq_name);
[u, v] = HS_optical_flow(Im1, Im2, alpha, iterations);

%% 4. Visualization (Question 9)

% A. Grayscale Components
figure;
subplot(1,2,1); imshow(u, []); title('Horizontal Flow (u)'); colormap(gca, 'gray');
subplot(1,2,2); imshow(v, []); title('Vertical Flow (v)'); colormap(gca, 'gray');

% B. Quiver (Vector Field)
% Downsample for visibility (plot every 10th pixel)
step = 10; 
[x, y] = meshgrid(1:size(u,2), 1:size(u,1));

figure;
imshow(Im1); hold on;
title(['Optical Flow Vectors: ' seq_name]);
% Note: Using -v to correct coordinate system display
quiver(x(1:step:end, 1:step:end), y(1:step:end, 1:step:end), ...
       u(1:step:end, 1:step:end), -v(1:step:end, 1:step:end), 5, 'y');
hold off;

% C. Color Representation
% Using the provided computeColor function
if exist('computeColor', 'file')
    imgColor = computeColor(u, v);
    figure; imshow(imgColor); title(['Color Flow: ' seq_name]);
else
    disp('computeColor function not found in path.');
end