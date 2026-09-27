% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

function ax = plot_smith_grid(ax)
    % ===== Lightweight Smith-chart grid =====
    % Generate a monochrome Smith-chart background without requiring
    % RF Toolbox. The grid contains constant normalized-resistance circles
    % and normalized-reactance arcs in the reflection-coefficient plane.

    %% ===== Axes initialization =====
    if nargin < 1 || isempty(ax)
        figure('Color','w');
        ax = axes();
    end

    hold(ax,'on');
    axis(ax,'equal');
    box(ax,'on');

    %% ===== Smith-chart boundary =====
    % Unit circle represents the boundary |Gamma| = 1
    theta = linspace(0,2*pi,600);

    plot(ax, ...
        cos(theta),sin(theta), ...
        'k-', ...
        'LineWidth',1.1, ...
        'HandleVisibility','off');

    % Horizontal diameter corresponds to zero normalized reactance
    plot(ax, ...
        [-1 1],[0 0], ...
        '-', ...
        'Color',[0.72 0.72 0.72], ...
        'LineWidth',0.7, ...
        'HandleVisibility','off');

    %% ===== Constant-resistance circles =====
    rValues = [0.2 0.5 1 2 5];
    x = linspace(-20,20,800);

    for r = rValues
        z = r + 1j*x;
        gamma = (z-1)./(z+1);

        plot(ax, ...
            real(gamma),imag(gamma), ...
            '-', ...
            'Color',[0.84 0.84 0.84], ...
            'LineWidth',0.6, ...
            'HandleVisibility','off');
    end

    %% ===== Constant-reactance arcs =====
    xValues = [0.2 0.5 1 2 5];
    r = linspace(0,12,800);

    for x = xValues
        % Positive and negative reactance form the upper and lower arcs
        for signX = [-1 1]
            z = r + 1j*signX*x;
            gamma = (z-1)./(z+1);

            plot(ax, ...
                real(gamma),imag(gamma), ...
                '-', ...
                'Color',[0.88 0.88 0.88], ...
                'LineWidth',0.6, ...
                'HandleVisibility','off');
        end
    end

    %% ===== Axes style =====
    xlim(ax,[-1.08 1.08]);
    ylim(ax,[-1.08 1.08]);

    xlabel(ax,'Re\{\Gamma\}');
    ylabel(ax,'Im\{\Gamma\}');

    set(ax, ...
        'FontName','Times New Roman', ...
        'FontSize',10, ...
        'LineWidth',0.8, ...
        'Box','on');
end