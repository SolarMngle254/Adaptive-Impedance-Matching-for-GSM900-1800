% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

function p = aim_constants()
    % ===== Adaptive impedance matching system parameters =====
    % Define the electrical, DTC, and visualization parameters used
    % throughout the dual-band adaptive L-network simulation.

    %% ===== Reference impedance =====
    p.Z0   = 50;       % Reference impedance [ohm]
    p.Rref = 50;       % Target matched resistance [ohm]
    p.Xref = 0;        % Target matched reactance [ohm]

    %% ===== Operating frequencies =====
    p.f1 = 900e6;      % Lower operating band [Hz]
    p.f2 = 1800e6;     % Upper operating band [Hz]

    %% ===== L-network components =====
    p.Lpar    = 6e-9;      % Fixed shunt inductor [H]
    p.Lseries = 12e-9;     % Fixed series inductor [H]

    p.Cmin = 0.5e-12;      % Tunable-capacitor lower bound [F]
    p.Cmax = 7.0e-12;      % Tunable-capacitor upper bound [F]

    p.Qe = 50;             % Element quality factor

    %% ===== Digital Tunable Capacitor (DTC) =====
    % The reference-paper simulation uses a 5-bit capacitor
    % quantization, corresponding to 32 discrete tuning states.
    p.DTC_bits   = 5;
    p.DTC_levels = 2^p.DTC_bits;

    % Uniform capacitance step over the configured tuning range
    p.DTC_LSB = (p.Cmax-p.Cmin)/(p.DTC_levels-1);

    %% ===== Visualization parameters =====
    p.Cinit = 5.0e-12;     % Initial capacitor state [F]

    % No physical counter clock is defined in the current model.
    % Therefore tuning progress is represented by counter updates.
    p.f_counter = NaN;

    p.animationPause = 0.01;    % MATLAB animation pause [s]
end