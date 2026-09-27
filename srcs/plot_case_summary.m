% Author       : Le Minh Nhat - K22 HCMUT
% Faculty      : Electrical and Electronics Engineering
% Course       : Microwave Engineering - Semester 252
% Date modified: 27/09/2026

function T = plot_case_summary(f, saveFigure)
    % ===== AIM benchmark visualization =====
    % Compare the matching performance of load cases A-F at a selected
    % operating frequency.
    %
    % The figure summarizes VSWR recovery, required capacitances,
    % insertion loss and net gain, and Smith-chart transformation.

    %% ===== Input settings =====
    if nargin < 2
        saveFigure = false;
    end

    % Load system parameters and evaluate benchmark cases
    p = aim_constants();
    T = aim_case_summary(f,p);

    %% ===== Figure initialization =====
    fig = figure( ...
        'Name',sprintf('AIM benchmark %.0f MHz',f/1e6), ...
        'Color','w', ...
        'Position',[100 100 760 540]);

    t = tiledlayout(fig,2,2, ...
        'TileSpacing','compact', ...
        'Padding','compact');

    % Common monochrome figure style
    set(fig,'DefaultAxesFontName','Times New Roman');
    set(fig,'DefaultAxesFontSize',10);
    set(fig,'DefaultAxesLineWidth',0.8);
    set(fig,'DefaultLineLineWidth',1.2);

    %% ===== VSWR before and after matching =====
    ax1 = nexttile(t,1);

    b = bar(ax1,categorical(T.Case), ...
        [T.VSWR_Before T.VSWR_After], ...
        'grouped');

    % Dark and white bars distinguish the two matching states
    b(1).FaceColor = [0.25 0.25 0.25];
    b(1).EdgeColor = 'k';
    b(1).LineWidth = 0.8;

    b(2).FaceColor = 'w';
    b(2).EdgeColor = 'k';
    b(2).LineWidth = 1.0;

    ylabel(ax1,'VSWR');

    legend(ax1, ...
        {'Before','After'}, ...
        'Location','northwest', ...
        'Box','off', ...
        'FontSize',8);

    title(ax1,'(a) Mismatch recovery', ...
        'FontWeight','normal');

    grid(ax1,'on');
    ax1.GridAlpha = 0.12;
    ax1.MinorGridAlpha = 0.08;
    ax1.Box = 'on';

    %% ===== Required capacitances =====
    ax2 = nexttile(t,2);

    b = bar(ax2,categorical(T.Case), ...
        [T.Cpar_pF T.Cseries_pF], ...
        'grouped');

    b(1).FaceColor = [0.25 0.25 0.25];
    b(1).EdgeColor = 'k';
    b(1).LineWidth = 0.8;

    b(2).FaceColor = 'w';
    b(2).EdgeColor = 'k';
    b(2).LineWidth = 1.0;

    ylabel(ax2,'Capacitance (pF)');

    legend(ax2, ...
        {'C_{PAR}','C_{SERIES}'}, ...
        'Location','best', ...
        'Box','off', ...
        'FontSize',8);

    title(ax2,'(b) Required capacitances', ...
        'FontWeight','normal');

    grid(ax2,'on');
    ax2.GridAlpha = 0.12;
    ax2.Box = 'on';

    %% ===== Insertion loss and net gain =====
    ax3 = nexttile(t,3);

    b = bar(ax3,categorical(T.Case), ...
        [T.IL_dB T.Gain_dB], ...
        'grouped');

    b(1).FaceColor = [0.25 0.25 0.25];
    b(1).EdgeColor = 'k';
    b(1).LineWidth = 0.8;

    b(2).FaceColor = 'w';
    b(2).EdgeColor = 'k';
    b(2).LineWidth = 1.0;

    ylabel(ax3,'Magnitude (dB)');

    yline(ax3,0,'k:', ...
        'LineWidth',0.8, ...
        'HandleVisibility','off');

    legend(ax3, ...
        {'IL','G = RLR - IL'}, ...
        'Location','best', ...
        'Box','off', ...
        'FontSize',8);

    title(ax3,'(c) Insertion loss and net gain', ...
        'FontWeight','normal');

    grid(ax3,'on');
    ax3.GridAlpha = 0.12;
    ax3.Box = 'on';

    %% ===== Smith-chart transformation =====
    ax4 = nexttile(t,4);
    hold(ax4,'on');
    plot_smith_grid(ax4);

    cases = aim_load_cases();

    % Different markers identify load cases A-F in monochrome
    markers = {'o','s','^','v','d','x'};
    hCase = gobjects(numel(cases),1);

    for k = 1:numel(cases)
        % Analytical matching solution for the current load case
        sol = aim_closed_form( ...
            f,cases(k).Z,p,'auto');

        % Evaluate the resulting matched input impedance
        resp = aim_network_response( ...
            f,cases(k).Z, ...
            sol.Cpar,sol.Cseries,p);

        gl = z_to_gamma(cases(k).Z,p.Z0);
        gm = resp.GammaMatch;

        % Connect the original load to the transformed input point
        plot(ax4, ...
            [real(gl) real(gm)], ...
            [imag(gl) imag(gm)], ...
            'k-', ...
            'LineWidth',1.0, ...
            'HandleVisibility','off');

        % Initial load position
        hCase(k) = plot(ax4, ...
            real(gl),imag(gl), ...
            markers{k}, ...
            'Color','k', ...
            'MarkerSize',5.5, ...
            'LineWidth',1.0, ...
            'MarkerFaceColor','w');

        % Final matched input position
        plot(ax4, ...
            real(gm),imag(gm), ...
            'k.', ...
            'MarkerSize',8, ...
            'HandleVisibility','off');
    end

    % Explicit handles prevent Smith-grid curves from entering the legend
    legend(ax4, ...
        hCase,{cases.name}, ...
        'Location','southoutside', ...
        'Orientation','horizontal', ...
        'NumColumns',6, ...
        'Box','off', ...
        'FontSize',8);

    title(ax4,'(d) Load-to-input transformation', ...
        'FontWeight','normal');

    ax4.Box = 'on';

    %% ===== Figure title =====
    title(t, ...
        sprintf('Adaptive L-network benchmark at %.0f MHz',f/1e6), ...
        'FontName','Times New Roman', ...
        'FontSize',11, ...
        'FontWeight','normal');

    %% ===== Figure export =====
    if saveFigure
        root = fileparts(fileparts(mfilename('fullpath')));
        outDir = fullfile(root,'pics','sim');

        if ~exist(outDir,'dir')
            mkdir(outDir);
        end

        out = fullfile(outDir, ...
            sprintf('case_summary_%.0fMHz.png',f/1e6));

        exportgraphics(fig,out, ...
            'Resolution',400, ...
            'BackgroundColor','white');
    end
end