% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

% ===== AIM benchmark reproduction =====
% Reproduce the analytical benchmark results for antenna-load cases A-F
% at 900 MHz and 1800 MHz and export the combined result table.

clear; clc;

root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root,'srcs'));

p = aim_constants();

%% ===== Benchmark calculation =====
T900  = aim_case_summary(p.f1,p);
T1800 = aim_case_summary(p.f2,p);

T = [T900; T1800];

disp(T);

%% ===== Result export =====
resultsDir = fullfile(root,'results');

if ~exist(resultsDir,'dir')
    mkdir(resultsDir);
end

out = fullfile(resultsDir,'benchmark_results.csv');

writetable(T,out);

fprintf('Saved: %s\n',out);