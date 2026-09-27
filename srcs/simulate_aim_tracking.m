% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

function h = simulate_aim_tracking(f, Zload, p, Cpar0, Cseries0, step)
    % ===== Adaptive impedance matching tracking simulation =====
    % Generate a discrete DTC tuning trajectory from the initial capacitor
    % states toward the analytical AIM solution.
    %
    % The two cascaded tuning actions are visualized sequentially:
    %   1st loop: Cpar adjusts the real-part matching condition.
    %   2nd loop: Cseries compensates the remaining reactance.
    %
    % This model represents the tuning trajectory of an Up/Down
    % switched-capacitor controller. It does not simulate the internal
    % detector or digital counter circuitry.

    %% ===== Input settings =====
    if nargin < 3 || isempty(p)
        p = aim_constants();
    end

    if nargin < 4 || isempty(Cpar0)
        Cpar0 = p.Cinit;
    end

    if nargin < 5 || isempty(Cseries0)
        Cseries0 = p.Cinit;
    end

    if nargin < 6 || isempty(step)
        step = p.DTC_LSB;
    end

    %% ===== Analytical matching target =====
    % Determine the continuous capacitor solution before DTC quantization
    sol = aim_closed_form(f,Zload,p,'auto');

    if ~sol.feasibleCaps
        error('Requested load is outside the configured capacitor tuning region.');
    end

    %% ===== DTC quantization =====
    % Quantize both initial states and analytical targets to realizable
    % capacitor states.
    Cpar0    = aim_quantize_cap(Cpar0,p,step);
    Cseries0 = aim_quantize_cap(Cseries0,p,step);

    CtPar = aim_quantize_cap(sol.Cpar,p,step);
    CtSer = aim_quantize_cap(sol.Cseries,p,step);

    %% ===== Cascaded tuning trajectory =====
    % First loop: tune Cpar while Cseries remains at its initial state
    cp = localStepVector(Cpar0,CtPar,step);

    % Second loop: hold Cpar and tune Cseries to its target state
    cs = localStepVector(Cseries0,CtSer,step);

    CparHist = [ ...
        cp(:); ...
        repmat(CtPar,numel(cs)-1,1)];

    CserHist = [ ...
        repmat(Cseries0,numel(cp),1); ...
        cs(2:end).'];

    % Identify which AIM loop is active at each counter update
    phase = [ ...
        repmat("1st loop: Cpar",numel(cp),1); ...
        repmat("2nd loop: Cseries",numel(cs)-1,1)];

    %% ===== Tracking history initialization =====
    N = numel(CparHist);

    Zin   = complex(zeros(N,1));
    Gamma = complex(zeros(N,1));
    VSWR  = zeros(N,1);
    IL    = zeros(N,1);
    Gain  = zeros(N,1);

    %% ===== Network response along tuning trajectory =====
    % Recalculate the complete L-network response at every DTC update
    for k = 1:N
        r = aim_network_response( ...
            f,Zload,CparHist(k),CserHist(k),p);

        Zin(k)   = r.Zin;
        Gamma(k) = r.GammaMatch;
        VSWR(k)  = r.VSWRmatch;
        IL(k)    = r.IL;
        Gain(k)  = r.Gain;
    end

    %% ===== Simulation output =====
    h = struct();

    h.f        = f;
    h.Zload    = Zload;
    h.solution = sol;

    % Counter-update index is used when no physical counter clock is known
    h.step = (0:N-1).';

    h.DTC_bits = p.DTC_bits;
    h.DTC_LSB  = step;

    % Convert counter updates to physical time only when f_counter is known
    if isfinite(p.f_counter) && p.f_counter > 0
        h.time = h.step/p.f_counter;
    else
        h.time = [];
    end

    h.phase   = phase;
    h.Cpar    = CparHist;
    h.Cseries = CserHist;

    h.Zin   = Zin;
    h.Gamma = Gamma;
    h.VSWR  = VSWR;
    h.IL    = IL;
    h.Gain  = Gain;

    h.targetGamma = 0;
    h.p = p;
end


function v = localStepVector(a,b,step)
    % ===== Discrete capacitor-state sequence =====
    % Generate uniformly spaced DTC states from the initial capacitance
    % toward the target capacitance without overshooting the final state.

    if abs(a-b) < 0.5*step
        v = b;
        return
    end

    direction = sign(b-a);
    N = floor(abs(b-a)/step);

    v = a + direction*(0:N)*step;

    % Force the final state to coincide exactly with the quantized target
    if abs(v(end)-b) > 0.25*step
        v(end+1) = b;
    else
        v(end) = b;
    end
end