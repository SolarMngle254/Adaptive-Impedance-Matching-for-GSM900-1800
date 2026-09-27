% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

% ===== Benchmark validation =====
% Validate the analytical AIM implementation against the reference
% benchmark results at 900 MHz and 1800 MHz.
%
% The test checks Cpar, Cseries, insertion loss, and net gain using
% the rounded values reported in the project benchmark table.

clear; clc;

root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root,'srcs'));

p = aim_constants();

%% ===== Reference benchmark data =====
% Columns: [Cpar (pF), Cseries (pF), IL (dB), Gain (dB)]

ref900 = [ ...
    5.21  2.61  0.47 -0.47;
    3.68  1.14  1.11  0.83;
    5.21  1.24  1.06  0.88;
    1.95  1.24  0.85  1.09;
    6.31  1.37  0.94  1.19;
    0.65  1.37  0.65  1.48];

ref1800 = [ ...
    1.30  0.65  0.56 -0.56;
    2.07  1.80  0.89  1.05;
    2.94  1.46  0.91  1.03;
    1.30  1.46  0.70  1.24;
    3.58  1.19  0.87  1.26;
    0.76  1.19  0.58  1.55];

%% ===== AIM benchmark calculation =====
T900  = aim_case_summary(p.f1,p);
T1800 = aim_case_summary(p.f2,p);

calc900 = [ ...
    T900.Cpar_pF ...
    T900.Cseries_pF ...
    T900.IL_dB ...
    T900.Gain_dB];

calc1800 = [ ...
    T1800.Cpar_pF ...
    T1800.Cseries_pF ...
    T1800.IL_dB ...
    T1800.Gain_dB];

%% ===== Validation error =====
err900  = max(abs(calc900-ref900),[],1);
err1800 = max(abs(calc1800-ref1800),[],1);

fprintf('Max abs error 900 MHz  [Cpar Cseries IL G] = ');
disp(err900);

fprintf('Max abs error 1800 MHz [Cpar Cseries IL G] = ');
disp(err1800);

%% ===== Validation criteria =====
% Tolerance accounts for rounding in the reference benchmark table.
tolerance = [0.02 0.02 0.02 0.02];

assert(all(err900 < tolerance), ...
    '900 MHz benchmark validation failed.');

assert(all(err1800 < tolerance), ...
    '1800 MHz benchmark validation failed.');

fprintf(['PASS: analytical implementation reproduces the benchmark ' ...
         'table within rounding tolerance.\n']);