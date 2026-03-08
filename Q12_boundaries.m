%% Script: Question 12 - Motion Boundaries vs Object Boundaries
clc; clear; close all;
addpath('CODES');

%% 1. Setup & Run Optical Flow
image1_path = 'Road/0000.pgm';
image2_path = 'Road/0001.pgm';

if ~isfile(image1_path), error('Check path!'); end

Im1 = double(imread(image1_path));
Im2 = double(imread(image2_path));

% Use standard parameters
alpha = 20;
iterations = 100;

fprintf('Computing Optical Flow...\n');
[u, v] = HS_optical_flow(Im1, Im2, alpha, iterations);

%% 2. Calculate Real Object Boundaries (Image Edges)
% We use the Canny edge detector on the original image
% normalizing to 0-1 range for the edge function
Im1_norm = (Im1 - min(Im1(:))) / (max(Im1(:)) - min(Im1(:)));
Edges_Image = edge(Im1_norm, 'canny', 0.1); 

%% 3. Calculate Motion Boundaries (Flow Gradients)
% We want to see where u and v change rapidly.
% Calculate gradients of the velocity field.
[ux, uy] = gradient(u);
[vx, vy] = gradient(v);

% Magnitude of the flow gradient (The "Smoothness Error")
% 
Flow_Gradient_Mag = sqrt(ux.^2 + uy.^2 + vx.^2 + vy.^2);

% Threshold the flow gradient to make binary "edges" for easier comparison
% You might need to tune this threshold (e.g., 0.1 or 0.5) depending on results
Motion_Edges = Flow_Gradient_Mag > 0.1; 

%% 4. Visualization & Comparison
figure('Name', 'Question 12: Boundaries');

% A. Original Image
subplot(2,2,1); 
imshow(uint8(Im1)); 
title('Original Image');

% B. Image Edges (Canny)
subplot(2,2,2); 
imshow(Edges_Image); 
title('Real Object Boundaries (Canny)');

% C. Motion Gradient (Heatmap)
subplot(2,2,3); 
imshow(Flow_Gradient_Mag, []); 
colormap(gca, 'jet'); colorbar;
title('Motion Gradient Magnitude');

% D. Comparison (Overlay)
% Green = Image Edges, Magenta = Motion Edges
subplot(2,2,4); 
imshow(imfuse(Edges_Image, Motion_Edges, 'falsecolor', 'Scaling', 'joint', 'ColorChannels', [1 2 0]));
title('Overlay: Green=Image, Magenta=Motion');

sgtitle('Comparison of Structural vs. Motion Boundaries');