%% Script: Question 14 - Temporal Initialization
clc; clear; close all;
addpath('CODES');

% Load 3 consecutive frames from Road sequence
Im0 = double(imread('Road/0000.pgm'));
Im1 = double(imread('Road/0001.pgm'));
Im2 = double(imread('Road/0002.pgm'));

alpha = 20;
iterations = 50; % Fewer iterations needed if we initialize well!

%% Step 1: Compute Flow for Frame 0 -> 1 (Standard Start)
fprintf('Computing Flow 0->1 (Standard Cold Start)...\n');
tic;
[u_prev, v_prev] = HS_optical_flow_warm(Im0, Im1, alpha, iterations, [], []);
time_cold = toc;

%% Step 2: Compute Flow for Frame 1 -> 2 (Warm Start)
% We pass u_prev, v_prev as the starting point
fprintf('Computing Flow 1->2 (Temporal Warm Start)...\n');
tic;
[u_warm, v_warm] = HS_optical_flow_warm(Im1, Im2, alpha, iterations, u_prev, v_prev);
time_warm = toc;

%% Visualization
figure('Name', 'Question 14: Temporal Initialization');
subplot(1,2,1); 
imshow(computeColor(u_prev, v_prev)); title('Frame 0->1 (Cold Start)');
subplot(1,2,2); 
imshow(computeColor(u_warm, v_warm)); title('Frame 1->2 (Warm Start)');

fprintf('Temporal initialization implemented successfully.\n');