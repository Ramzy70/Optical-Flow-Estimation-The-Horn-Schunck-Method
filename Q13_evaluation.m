%% Script: Question 13 - Evaluation with Ground Truth (Middlebury)
clc; clear; close all;
addpath('CODES');

%% 1. Select Sequence
% Options in your folder: 'Dimetrodon', 'Grove2', 'Hydrangea', 'RubberWhale', 'Urban2', 'Urban3'
seq_name = 'RubberWhale'; 

fprintf('Evaluating on sequence: %s\n', seq_name);

%% 2. Load Images & Ground Truth
% Load Frame 10 and 11
im1_path = fullfile('SEQUENCES_GT', seq_name, 'frame10.png');
im2_path = fullfile('SEQUENCES_GT', seq_name, 'frame11.png');
gt_path  = fullfile('FLOTS_GT', seq_name, 'flow10.flo'); % The Ground Truth file

if ~isfile(gt_path), error('GT file not found: %s', gt_path); end

Im1_raw = imread(im1_path);
Im2_raw = imread(im2_path);

% Convert to grayscale for Horn-Schunck
if size(Im1_raw, 3) == 3
    Im1 = rgb2gray(Im1_raw);
    Im2 = rgb2gray(Im2_raw);
else
    Im1 = Im1_raw;
    Im2 = Im2_raw;
end

% Load Ground Truth Flow using provided function
FlowGT = readFlowFile(gt_path);
u_gt = FlowGT(:,:,1);
v_gt = FlowGT(:,:,2);

%% 3. Run Horn-Schunck Algorithm
alpha = 15;        % Tuning parameter
iterations = 100;

fprintf('Running Horn-Schunck...\n');
[u_est, v_est] = HS_optical_flow(Im1, Im2, alpha, iterations);

%% 4. Compute Errors (AEPE & AAE)

% A. End Point Error (EPE)
% Distance between estimated vector and GT vector
% EPE = sqrt( (u_est - u_gt)^2 + (v_est - v_gt)^2 )
diff_u = u_est - u_gt;
diff_v = v_est - v_gt;
EPE_map = sqrt(diff_u.^2 + diff_v.^2);

% Handle "Unknown" flow values in GT (Middlebury uses 1e9 for unknown flow)
valid_mask = (abs(u_gt) < 1e9) & (abs(v_gt) < 1e9);
AEPE = mean(EPE_map(valid_mask));

% B. Angular Error (AAE)
% Dot product formula
% AAE = arccos( (u_est*u_gt + v_est*v_gt + 1) / (norm_est * norm_gt) )
% The "+1" comes from the time component (dt=1)
dot_prod = u_est .* u_gt + v_est .* v_gt + 1;
norm_est = sqrt(u_est.^2 + v_est.^2 + 1);
norm_gt  = sqrt(u_gt.^2  + v_gt.^2  + 1);

Arg = dot_prod ./ (norm_est .* norm_gt);
% Clamp values to [-1, 1] to avoid complex numbers due to float precision
Arg(Arg > 1) = 1; 
Arg(Arg < -1) = -1;

AngularError_map = acos(Arg); % Result in radians
AAE = mean(AngularError_map(valid_mask)); % Average in radians
AAE_deg = rad2deg(AAE); % Convert to degrees

%% 5. Display Results
fprintf('---------------------------------\n');
fprintf('Results for %s (Alpha=%d)\n', seq_name, alpha);
fprintf('AEPE (Average End Point Error): %.4f pixels\n', AEPE);
fprintf('AAE  (Average Angular Error):   %.4f degrees\n', AAE_deg);
fprintf('---------------------------------\n');

figure('Name', 'Question 13: Ground Truth Evaluation');

% Show GT Flow Color
subplot(2,2,1); 
if exist('flowToColor', 'file')
    imshow(flowToColor(FlowGT)); 
    title('Ground Truth Flow');
else
    imshow(Im1_raw); title('Ground Truth (Color func missing)');
end

% Show Estimated Flow Color
subplot(2,2,2); 
if exist('computeColor', 'file')
    imshow(computeColor(u_est, v_est)); 
    title('Estimated Flow (HS)');
end

% Show EPE Heatmap
subplot(2,2,3);
imshow(EPE_map, [0 5]); % Display error range 0 to 5 pixels
colormap(gca, 'jet'); colorbar;
title('End Point Error Map');

% Show Mask (Where GT is valid)
subplot(2,2,4);
imshow(valid_mask);
title('Valid GT Pixels (White)');