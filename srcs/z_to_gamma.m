% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

function gamma = z_to_gamma(Z, Z0)
    % ===== Impedance-to-reflection conversion =====
    % Convert complex impedance to reflection coefficient with respect
    % to the specified reference impedance.

    if nargin < 2
        Z0 = 50;
    end

    gamma = (Z-Z0)./(Z+Z0);
end