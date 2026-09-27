% =========================================================================
% MAIN - ADAPTIVE IMPEDANCE MATCHING FOR DUAL-BAND L-NETWORK
% =========================================================================
%
% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
%
% Description  :
%   Main simulation script for a dual-band Adaptive Impedance Matching
%   (AIM) L-network operating at 900 MHz and 1800 MHz.
%
%   This script performs:
%       1. Benchmark evaluation for load cases A-F
%       2. Discrete DTC-based impedance tracking
%       3. Smith-chart matching animation
%       4. Benchmark performance visualization
%       5. Constant-VSWR load-phase sweep
%
% Related functions:
%   aim_constants.m             - System and DTC parameters
%   aim_load_cases.m            - Predefined load cases A-F
%   aim_case_summary.m          - Benchmark evaluation
%   aim_closed_form.m           - Analytical matching solution
%   aim_network_response.m      - L-network response and RF metrics
%   aim_quantize_cap.m          - DTC capacitance quantization
%   simulate_aim_tracking.m     - Discrete tuning trajectory
%   animate_smith_tracking.m    - Smith-chart tracking animation
%   plot_case_summary.m         - Benchmark result visualization
%   plot_phase_sweep.m          - Constant-VSWR phase sweep
%   plot_smith_grid.m           - Smith-chart grid
%   z_to_gamma.m                - Impedance-to-reflection conversion
%   gamma_to_z.m                - Reflection-to-impedance conversion
%
% Reference    :
%   A. van Bezooijen et al., "Adaptive Impedance-Matching Techniques
%   for Controlling L Networks," IEEE Trans. Circuits Syst. I,
%   vol. 57, no. 2, pp. 495-505, Feb. 2010.
%   DOI: 10.1109/TCSI.2009.2023764
%
% Last modified: 27/09/2026
% =========================================================================

clear; close all; clc;


%% 1. Initialization

% Locate repository root and add source directory
thisFile = mfilename('fullpath');
repoRoot = fileparts(fileparts(thisFile));
addpath(fullfile(repoRoot,'srcs'));

% Load AIM parameters
p = aim_constants();


%% 2. Output directories

resultsDir = fullfile(repoRoot,'results');
simDir     = fullfile(repoRoot,'pics','sim');

if ~exist(resultsDir,'dir')
    mkdir(resultsDir);
end

if ~exist(simDir,'dir')
    mkdir(simDir);
end


%% 3. Benchmark evaluation

% Evaluate load cases A-F at both operating frequencies
T900  = aim_case_summary(p.f1,p);
T1800 = aim_case_summary(p.f2,p);

disp('=== 900 MHz ===');
disp(T900);

disp('=== 1800 MHz ===');
disp(T1800);

% Export numerical results
Tall = [T900; T1800];

writetable(Tall, ...
    fullfile(resultsDir,'benchmark_results.csv'));


%% 4. Adaptive impedance-tracking demonstration

% Select demonstration case and operating frequency
cases = aim_load_cases();
selectedCase = cases(strcmp({cases.name},'E'));
selectedFreq = p.f1;      % 900 MHz

% Simulate discrete DTC tuning trajectory
h = simulate_aim_tracking( ...
    selectedFreq, ...
    selectedCase.Z, ...
    p, ...
    p.Cinit, ...
    p.Cinit, ...
    p.DTC_LSB);

% Define animation output
gifPath = fullfile(simDir, sprintf( ...
    'smith_tracking_case_%s_%.0fMHz.gif', ...
    selectedCase.name, selectedFreq/1e6));

animate_smith_tracking(h,true,gifPath);


%% 5. Close animation

% Close animation before displaying static figures
animFig = findall( ...
    0, ...
    'Type','figure', ...
    'Name','Adaptive Impedance Matching - Smith Tracking');

if ~isempty(animFig)
    close(animFig);
end


%% 6. Benchmark visualization

plot_case_summary(p.f1,true);
plot_case_summary(p.f2,true);


%% 7. Constant-VSWR phase sweep

plot_phase_sweep(p.f1,4.3,true);
plot_phase_sweep(p.f2,4.3,true);


%% 8. Complete

fprintf('\n========================================\n');
fprintf('Adaptive Impedance Matching completed.\n');
fprintf('Results saved to: %s\n',resultsDir);
fprintf('Figures saved to: %s\n',simDir);
fprintf('========================================\n');