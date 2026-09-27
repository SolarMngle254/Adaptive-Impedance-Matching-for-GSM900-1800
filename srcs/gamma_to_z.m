% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

function Z = gamma_to_z(gamma, Z0)
    % ===== Reflection-to-impedance conversion =====
    % Convert reflection coefficient to complex impedance with respect
    % to the specified reference impedance.

    if nargin < 2
        Z0 = 50;
    end

    Z = Z0.*(1+gamma)./(1-gamma);
end