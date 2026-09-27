% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

function Cq = aim_quantize_cap(C, p, step)
    % ===== Digital tunable capacitor quantization =====
    % Quantize a capacitance value to the nearest available DTC state
    % and constrain the result within the configured tuning range.

    % Use the default DTC resolution if no step size is specified
    if nargin < 3 || isempty(step)
        step = p.DTC_LSB;
    end

    % Quantize relative to Cmin so that the discrete states are aligned
    % with the physical capacitor tuning range
    Cq = p.Cmin + round((C-p.Cmin)/step)*step;

    % Clamp the quantized value to the allowable capacitance range
    Cq = min(max(Cq,p.Cmin),p.Cmax);
end