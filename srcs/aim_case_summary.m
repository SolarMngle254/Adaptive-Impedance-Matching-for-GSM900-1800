% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

function T = aim_case_summary(f, p)
    % ===== Benchmark case evaluation =====
    % Evaluate antenna-load cases A-F at a selected operating frequency
    % and summarize the matching solution and RF performance in a table.
    %
    % Both nominal benchmark values and exact values calculated from the
    % complex load impedance are retained for comparison.

    %% ===== Input settings =====
    if nargin < 2 || isempty(p)
        p = aim_constants();
    end

    cases = aim_load_cases();
    N = numel(cases);

    %% ===== Result initialization =====
    Case          = strings(N,1);
    Zload         = strings(N,1);
    Branch        = strings(N,1);

    VSWR_Before   = zeros(N,1);
    VSWR_From_Z   = zeros(N,1);
    VSWR_After    = zeros(N,1);

    RLR_dB        = zeros(N,1);
    RLR_Exact_dB  = zeros(N,1);

    Cpar_pF       = zeros(N,1);
    Cseries_pF    = zeros(N,1);

    IL_dB         = zeros(N,1);
    Gain_dB       = zeros(N,1);
    Gain_Exact_dB = zeros(N,1);

    Feasible      = false(N,1);

    %% ===== Evaluate benchmark cases =====
    for k = 1:N
        % Analytical capacitor solution for the current antenna load
        sol = aim_closed_form( ...
            f,cases(k).Z,p,'auto');

        % Finite-Q response of the resulting matching network
        resp = aim_network_response( ...
            f,cases(k).Z,sol.Cpar,sol.Cseries,p);

        % Nominal VSWR preserves the rounded benchmark scenario label
        Snom = cases(k).nominalVSWR;
        rhoNom = (Snom-1)/(Snom+1);
        RLRnom = -10*log10(max(1-rhoNom^2,eps));

        % Load and matching configuration
        Case(k) = string(cases(k).name);

        Zload(k) = sprintf( ...
            '%.3g%+.3gj', ...
            real(cases(k).Z), ...
            imag(cases(k).Z));

        Branch(k) = string(sol.branch);

        % VSWR before and after impedance matching
        VSWR_Before(k) = Snom;
        VSWR_From_Z(k) = resp.VSWRload;
        VSWR_After(k)  = resp.VSWRmatch;

        % Reflection-loss reduction
        RLR_dB(k)       = RLRnom;
        RLR_Exact_dB(k) = resp.RLR;

        % Required continuous capacitor values
        Cpar_pF(k)    = sol.Cpar*1e12;
        Cseries_pF(k) = sol.Cseries*1e12;

        % Finite-Q insertion loss and net gain
        IL_dB(k)         = resp.IL;
        Gain_dB(k)       = RLRnom-resp.IL;
        Gain_Exact_dB(k) = resp.Gain;

        Feasible(k) = sol.feasibleCaps;
    end

    %% ===== Benchmark summary table =====
    Frequency_MHz = repmat(f/1e6,N,1);

    T = table( ...
        Case, ...
        Frequency_MHz, ...
        Zload, ...
        Branch, ...
        VSWR_Before, ...
        VSWR_From_Z, ...
        VSWR_After, ...
        RLR_dB, ...
        RLR_Exact_dB, ...
        Cpar_pF, ...
        Cseries_pF, ...
        IL_dB, ...
        Gain_dB, ...
        Gain_Exact_dB, ...
        Feasible);
end