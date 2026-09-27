% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

% ===== Case E adaptive matching demo =====
% Demonstrate discrete DTC-based impedance tracking for antenna-load
% Case E at 900 MHz and export the Smith-chart tracking animation.

clear; close all; clc;

root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root,'srcs'));

p = aim_constants();

%% ===== Case E configuration =====
cases = aim_load_cases();
caseE = cases(strcmp({cases.name},'E'));

%% ===== Adaptive matching trajectory =====
h = simulate_aim_tracking( ...
    p.f1, ...
    caseE.Z, ...
    p, ...
    p.Cinit, ...
    p.Cinit, ...
    p.DTC_LSB);

%% ===== Smith-chart animation =====
gifPath = fullfile( ...
    root,'pics','sim','smith_tracking_case_E_900MHz.gif');

animate_smith_tracking(h,true,gifPath);

fprintf('Saved: %s\n',gifPath);