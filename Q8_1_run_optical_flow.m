%% Script: Run Optical Flow (Question 8)
clc; clear; close all;

% Add the CODES folder to path so we can use provided tools later
addpath('CODES'); 

%% 1. Load Images (Road Sequence)
% Adjust path if necessary. Based on your file list:
% Road images are 'Road/0000.pgm', 'Road/0001.pgm', etc.

image1_path = 'Road/0000.pgm';
image2_path = 'Road/0001.pgm';

% Check if files exist
if ~isfile(image1_path)
   error('Cannot find images. Check the path! Current folder: %s', pwd);
end

Im1 = imread(image1_path);
Im2 = imread(image2_path);

% Display original image
figure; imshow(Im1); title('Original Frame 1');

%% 2. Parameters (Question 6)
% alpha: Smoothness weight (try 10-50 for real images)
% iterations: Need enough to propagate flow (e.g., 100)
alpha = 20; 
iterations = 100;

%% 3. Run Algorithm (Question 7)
[u, v] = HS_optical_flow(Im1, Im2, alpha, iterations);

%% 4. Visualization (Question 9)

% Display flow as grayscale components
figure;
subplot(1,2,1); imshow(u, []); title('Horizontal Flow (u)'); colormap(gca, 'gray');
subplot(1,2,2); imshow(v, []); title('Vertical Flow (v)'); colormap(gca, 'gray');

% Display vectors using quiver
% We downsample because plotting a vector for every pixel is messy
step = 10; 
[x, y] = meshgrid(1:size(u,2), 1:size(u,1));

figure;
imshow(Im1); hold on;
title('Optical Flow Vectors');
% Plot arrows: quiver(x, y, u, v, scale)
quiver(x(1:step:end, 1:step:end), y(1:step:end, 1:step:end), ...
       u(1:step:end, 1:step:end), v(1:step:end, 1:step:end), 5, 'y');
hold off;

%% 5. Color Visualization (Using provided computeColor.m if available)
% If computeColor exists in CODES, use it:
if exist('computeColor', 'file')
    imgColor = computeColor(u, v);
    figure; imshow(imgColor); title('Color Flow Representation');
else
    disp('computeColor function not found in path.');
end