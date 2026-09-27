% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

% ===== AIM result generation =====
% Reproduce the benchmark figures, Smith-chart tracking animation,
% and benchmark result table for the complete AIM simulation.

clear; close all; clc;

root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root,'srcs'));

p = aim_constants();

%% ===== Benchmark figures =====
plot_case_summary(p.f1,true);
plot_case_summary(p.f2,true);

plot_phase_sweep(p.f1,4.3,true);
plot_phase_sweep(p.f2,4.3,true);

%% ===== Smith-chart tracking animation =====
cases = aim_load_cases();
caseE = cases(strcmp({cases.name},'E'));

h = simulate_aim_tracking( ...
    p.f1, ...
    caseE.Z, ...
    p, ...
    p.Cinit, ...
    p.Cinit, ...
    p.DTC_LSB);

gifPath = fullfile( ...
    root,'pics','sim','smith_tracking_case_E_900MHz.gif');

animate_smith_tracking(h,true,gifPath);

%% ===== Benchmark result table =====
T900  = aim_case_summary(p.f1,p);
T1800 = aim_case_summary(p.f2,p);
T = [T900; T1800];

resultsDir = fullfile(root,'results');

if ~exist(resultsDir,'dir')
    mkdir(resultsDir);
end

writetable(T, ...
    fullfile(resultsDir,'benchmark_results.csv'));

fprintf('All AIM figures and results generated successfully.\n');