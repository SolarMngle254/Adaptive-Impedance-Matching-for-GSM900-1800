% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

function out = aim_network_response(f, Zload, Cpar, Cseries, p)
    % ===== Finite-Q L-network response =====
    % Evaluate the transformed input impedance and RF performance of the
    % adaptive L-network for a specified load and capacitor configuration.
    %
    % Component losses are represented by a first-order finite-Q model:
    % shunt reactive losses are converted to conductance, while series
    % reactive losses are converted to resistance.

    %% ===== Input settings =====
    if nargin < 5 || isempty(p)
        p = aim_constants();
    end

    %% ===== Load admittance =====
    w = 2*pi*f;

    Yload = 1/Zload;
    Gload = real(Yload);

    %% ===== Reactive components =====
    % Shunt branch susceptances
    BLpar = -1/(w*p.Lpar);
    BCpar =  w*Cpar;

    % Series branch reactances
    XLser =  w*p.Lseries;
    XCser = -1/(w*Cseries);

    %% ===== Finite-Q component losses =====
    % Parallel-element losses are represented by equivalent shunt
    % conductance, while series-element losses are represented by
    % equivalent series resistance.
    GparLoss = (abs(BLpar)+abs(BCpar))/p.Qe;
    RserLoss = (abs(XLser)+abs(XCser))/p.Qe;

    %% ===== L-network transformation =====
    % Intermediate impedance after the shunt matching stage
    Yint = Yload + GparLoss + 1j*(BLpar+BCpar);
    Zint = 1/Yint;

    % Final impedance after the series matching stage
    Zseries = RserLoss + 1j*(XLser+XCser);
    Zin = Zint + Zseries;

    %% ===== Reflection coefficient and VSWR =====
    GammaLoad  = z_to_gamma(Zload,p.Z0);
    GammaMatch = z_to_gamma(Zin,p.Z0);

    rhoLoad  = abs(GammaLoad);
    rhoMatch = abs(GammaMatch);

    VSWRload  = (1+rhoLoad)/max(1-rhoLoad,eps);
    VSWRmatch = (1+rhoMatch)/max(1-rhoMatch,eps);

    %% ===== RF performance metrics =====
    % Reflection-loss reduction associated with the original mismatch
    RLR = -10*log10(max(1-rhoLoad^2,eps));

    % First-order insertion loss introduced by finite-Q components
    IL = 10*log10( ...
        1 + GparLoss/max(Gload,eps) + RserLoss/p.Rref);

    % Net power-transfer improvement after accounting for network loss
    Gain = RLR - IL;

    %% ===== Network response structure =====
    out = struct();

    out.f       = f;
    out.Zload   = Zload;
    out.Cpar    = Cpar;
    out.Cseries = Cseries;

    out.GparLoss = GparLoss;
    out.RserLoss = RserLoss;

    out.Zint = Zint;
    out.Zin  = Zin;

    out.GammaLoad  = GammaLoad;
    out.GammaMatch = GammaMatch;

    out.VSWRload  = VSWRload;
    out.VSWRmatch = VSWRmatch;

    out.RLR  = RLR;
    out.IL   = IL;
    out.Gain = Gain;

    out.PunmatchedFrac = max(1-rhoLoad^2,0);
    out.PmatchedFrac   = 10^(-IL/10);
end