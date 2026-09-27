% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

function sol = aim_closed_form(f, Zload, p, branch)
    % ===== Closed-form L-network matching solution =====
    % Compute the ideal continuous capacitor values required to transform
    % the antenna load toward the reference impedance.
    %
    % Two analytical branches are available:
    %   inductive  : Bint < 0, resulting in Xint > 0
    %   capacitive : Bint > 0, resulting in Xint < 0
    %
    % In auto mode, the inductive branch is used near 900 MHz and the
    % capacitive branch near 1800 MHz according to the project convention.

    %% ===== Input settings =====
    if nargin < 3 || isempty(p)
        p = aim_constants();
    end

    if nargin < 4 || isempty(branch)
        branch = 'auto';
    end

    %% ===== Load admittance =====
    w = 2*pi*f;

    Yload = 1./Zload;
    Gload = real(Yload);
    Bload = imag(Yload);

    %% ===== Intermediate matching condition =====
    % The shunt stage must produce an intermediate admittance whose
    % transformed resistance satisfies the target resistance Rref.
    radicand = Gload/p.Rref - Gload.^2;

    sol = struct();

    sol.f        = f;
    sol.Zload    = Zload;
    sol.Gload    = Gload;
    sol.Bload    = Bload;
    sol.radicand = radicand;

    % A negative radicand means that no real-valued intermediate
    % susceptance satisfies the selected matching condition.
    sol.feasibleReal = radicand >= -1e-14;

    if ~sol.feasibleReal
        sol.Bint        = NaN;
        sol.Xint        = NaN;
        sol.Cpar        = NaN;
        sol.Cseries     = NaN;
        sol.Zint        = NaN;
        sol.ZmatchIdeal = NaN;
        sol.branch      = 'none';
        sol.feasibleCaps = false;
        return
    end

    % Remove small negative values caused only by numerical round-off
    radicand = max(radicand,0);

    %% ===== Matching branch selection =====
    if strcmpi(branch,'auto')
        if abs(f-p.f1) <= abs(f-p.f2)
            branch = 'inductive';
        else
            branch = 'capacitive';
        end
    end

    switch lower(branch)
        case 'inductive'
            Bint = -sqrt(radicand);     % Bint < 0 gives Xint > 0

        case 'capacitive'
            Bint = +sqrt(radicand);     % Bint > 0 gives Xint < 0

        otherwise
            error(['Unknown branch "%s". Use inductive, capacitive, ' ...
                   'or auto.'],branch);
    end

    %% ===== Shunt capacitor solution =====
    % Cpar adjusts the total shunt susceptance to the selected Bint.
    Cpar = (Bint-Bload+1/(w*p.Lpar))/w;

    % Intermediate impedance after the shunt matching stage
    Yint = Gload + 1j*Bint;
    Zint = 1./Yint;
    Xint = imag(Zint);

    %% ===== Series capacitor solution =====
    % Cseries compensates the remaining series reactance so that the
    % final input reactance approaches Xref.
    den = w*(w*p.Lseries + Xint - p.Xref);

    if den <= 0
        Cseries = NaN;
    else
        Cseries = 1/den;
    end

    %% ===== Ideal matched impedance =====
    Xseries = w*p.Lseries - 1/(w*Cseries);
    ZmatchIdeal = Zint + 1j*Xseries;

    %% ===== Solution structure =====
    sol.Bint        = Bint;
    sol.Xint        = Xint;
    sol.Cpar        = Cpar;
    sol.Cseries     = Cseries;
    sol.Zint        = Zint;
    sol.ZmatchIdeal = ZmatchIdeal;
    sol.branch      = lower(branch);

    % The analytical solution is realizable only when both capacitors
    % remain inside the configured tuning range.
    sol.feasibleCaps = ...
        isfinite(Cpar) && ...
        isfinite(Cseries) && ...
        Cpar >= p.Cmin && Cpar <= p.Cmax && ...
        Cseries >= p.Cmin && Cseries <= p.Cmax;
end