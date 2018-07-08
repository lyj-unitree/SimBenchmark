% csv format
formatSpec = '%C%C%C%C%d%f';

% load csv
T = readtable(...
    '../../../data/anymal-stand/final.csv', ...
    'Delimiter', ',', ...
    'Format',formatSpec ...
    );


% constants
numIter = 50000;

% data from rai
RAI = T(T.SIM == 'RAI', :);
[RAI_G, RAI_numrows] = findgroups(RAI.NUMROW);
RAI_mins = splitapply(@min, RAI.TIME, RAI_G);

% data from bullet
BT = T(T.SIM == 'BULLET', :);
[BT_G, BT_numrows] = findgroups(BT.NUMROW);
BT_mins = splitapply(@min, BT.TIME, BT_G);

% data from dart-dantzig-bullet
DART_DAN_BT = T(...
    T.SIM == 'DART' ...
    & T.SOLVER == 'DANTZIG' ...
    & T.DETECTOR == 'BULLET', :);
[DART_DAN_BT_G, DART_DAN_BT_numrows] = findgroups(DART_DAN_BT.NUMROW);
DART_DAN_BT_mins = splitapply(...
    @min, ...
    DART_DAN_BT.TIME, ...
    DART_DAN_BT_G);

% data from dart-pgs-bullet
DART_PGS_BT = T(...
    T.SIM == 'DART' ...
    & T.SOLVER == 'PGS' ...
    & T.DETECTOR == 'BULLET', :);
[DART_PGS_BT_G, DART_PGS_BT_numrows] = findgroups(DART_PGS_BT.NUMROW);
DART_PGS_BT_mins = splitapply(...
    @min, ...
    DART_PGS_BT.TIME, ...
    DART_PGS_BT_G);

% data from mujoco-pgs
MJC_PGS = T(...
    T.SIM == 'MUJOCO' ...
    & T.SOLVER == 'PGS-NOSLIP', :);
[MJC_PGS_G, MJC_PGS_numrows] = findgroups(MJC_PGS.NUMROW);
MJC_PGS_mins = splitapply(...
    @min, ...
    MJC_PGS.TIME, ...
    MJC_PGS_G);

% data from mujoco-cg
MJC_CG = T(...
    T.SIM == 'MUJOCO' ...
    & T.SOLVER == 'CG-NOSLIP', :);
[MJC_CG_G, MJC_CG_numrows] = findgroups(MJC_CG.NUMROW);
MJC_CG_mins = splitapply(...
    @min, ...
    MJC_CG.TIME, ...
    MJC_CG_G);

% data from mujoco-newton
MJC_NEWTON = T(...
    T.SIM == 'MUJOCO' ...
    & T.SOLVER == 'NEWTON-NOSLIP', :);
[MJC_NEWTON_G, MJC_NEWTON_numrows] = findgroups(MJC_NEWTON.NUMROW);
MJC_NEWTON_mins = splitapply(...
    @min, ...
    MJC_NEWTON.TIME, ...
    MJC_NEWTON_G);

% data from ODE
ODE = T(T.SIM == 'ODE', :);
[ODE_G, ODE_numrows] = findgroups(ODE.NUMROW);
ODE_mins = splitapply(...
    @min, ...
    ODE.TIME, ...
    ODE_G);

%% plot
% linear
figure('Name', 'linear', 'Position', [0, 0, 600, 500])
plot(RAI_numrows.^2, ...
    numIter ./ RAI_mins ./ 1000, ...
    plotspec.RAIRAIRAI{1}, ...
    'color', plotspec.RAIRAIRAI{3}, ...
    'DisplayName', plotspec.RAIRAIRAI{2})
hold on
plot(BT_numrows.^2, ...
    numIter ./ BT_mins ./ 1000, ...
    plotspec.BULLETMULTIBODYBULLET{1}, ...
    'color', plotspec.BULLETMULTIBODYBULLET{3}, ...
    'DisplayName', plotspec.BULLETMULTIBODYBULLET{2})
plot(DART_DAN_BT_numrows.^2, ...
    numIter ./ DART_DAN_BT_mins ./ 1000, ...
    plotspec.DARTDANTZIGDART{1}, ...
    'color', plotspec.DARTDANTZIGDART{3}, ...
    'DisplayName', plotspec.DARTDANTZIGDART{2})
plot(DART_PGS_BT_numrows.^2, ...
    numIter ./ DART_PGS_BT_mins ./ 1000, ...
    plotspec.DARTPGSDART{1}, ...
    'color', plotspec.DARTPGSDART{3}, ...
    'DisplayName', plotspec.DARTPGSDART{2})
plot(MJC_PGS_numrows.^2, ...
    numIter ./ MJC_PGS_mins ./ 1000, ...
    plotspec.MUJOCOPGSEULER{1}, ...
    'color', plotspec.MUJOCOPGSEULER{3}, ...
    'DisplayName', plotspec.MUJOCOPGSEULER{2})
plot(MJC_CG_numrows.^2, ...
    numIter ./ MJC_CG_mins ./ 1000, ...
    plotspec.MUJOCOCGEULER{1}, ...
    'color', plotspec.MUJOCOCGEULER{3}, ...
    'DisplayName', plotspec.MUJOCOCGEULER{2})
plot(MJC_NEWTON_numrows.^2, ...
    numIter ./ MJC_NEWTON_mins ./ 1000, ...
    plotspec.MUJOCONEWTONEULER{1}, ...
    'color', plotspec.MUJOCONEWTONEULER{3}, ...
    'DisplayName', plotspec.MUJOCONEWTONEULER{2})
plot(ODE_numrows.^2, ...
    numIter ./ ODE_mins ./ 1000, ...
    plotspec.ODESTANDARDODE{1}, ...
    'color', plotspec.ODESTANDARDODE{3}, ...
    'DisplayName', plotspec.ODESTANDARDODE{2})
% plot(DART_DAN_ODE_numrows.^2, DART_DAN_ODE_mins, '-m.') % redundant
% plot(DART_PGS_ODE_numrows.^2, DART_PGS_ODE_mins, '-mo') % redundant
xlabel('number of robots (n)')
ylabel(sprintf('timestep per second (kHz) \n FAST →'))
legend('Location', 'eastoutside')
title('ANYmal PD control test')
hold off
% saveas(gcf,'anymal-pd-plots/speed-number.eps','epsc')
% saveas(gcf,'anymal-pd-plots/speed-number.fig','fig')
% saveas(gcf,'anymal-pd-plots/speed-number.png')

% log scale
h = figure('Name', 'log', 'Position', [0, 0, 600, 500])
plot(RAI_numrows.^2, ...
    numIter ./ RAI_mins ./ 1000, ...
    plotspec.RAIRAIRAI{1}, ...
    'color', plotspec.RAIRAIRAI{3}, ...
    'DisplayName', plotspec.RAIRAIRAI{2})
hold on
plot(BT_numrows.^2, ...
    numIter ./ BT_mins ./ 1000, ...
    plotspec.BULLETMULTIBODYBULLET{1}, ...
    'color', plotspec.BULLETMULTIBODYBULLET{3}, ...
    'DisplayName', plotspec.BULLETMULTIBODYBULLET{2})
plot(DART_DAN_BT_numrows.^2, ...
    numIter ./ DART_DAN_BT_mins ./ 1000, ...
    plotspec.DARTDANTZIGDART{1}, ...
    'color', plotspec.DARTDANTZIGDART{3}, ...
    'DisplayName', plotspec.DARTDANTZIGDART{2})
plot(DART_PGS_BT_numrows.^2, ...
    numIter ./ DART_PGS_BT_mins ./ 1000, ...
    plotspec.DARTPGSDART{1}, ...
    'color', plotspec.DARTPGSDART{3}, ...
    'DisplayName', plotspec.DARTPGSDART{2})
plot(MJC_PGS_numrows.^2, ...
    numIter ./ MJC_PGS_mins ./ 1000, ...
    plotspec.MUJOCOPGSEULER{1}, ...
    'color', plotspec.MUJOCOPGSEULER{3}, ...
    'DisplayName', plotspec.MUJOCOPGSEULER{2})
plot(MJC_CG_numrows.^2, ...
    numIter ./ MJC_CG_mins ./ 1000, ...
    plotspec.MUJOCOCGEULER{1}, ...
    'color', plotspec.MUJOCOCGEULER{3}, ...
    'DisplayName', plotspec.MUJOCOCGEULER{2})
plot(MJC_NEWTON_numrows.^2, ...
    numIter ./ MJC_NEWTON_mins ./ 1000, ...
    plotspec.MUJOCONEWTONEULER{1}, ...
    'color', plotspec.MUJOCONEWTONEULER{3}, ...
    'DisplayName', plotspec.MUJOCONEWTONEULER{2})
plot(ODE_numrows.^2, ...
    numIter ./ ODE_mins ./ 1000, ...
    plotspec.ODESTANDARDODE{1}, ...
    'color', plotspec.ODESTANDARDODE{3}, ...
    'DisplayName', plotspec.ODESTANDARDODE{2})
% plot(DART_DAN_ODE_numrows.^2, DART_DAN_ODE_mins, '-m.') % redundant
% plot(DART_PGS_ODE_numrows.^2, DART_PGS_ODE_mins, '-mo') % redundant
xlabel('the number of robots')
ylabel(sprintf('timestep per second (kHz)'))
legend('Location', 'northeast')
hold off
title('ANYmal PD control test')
ylim([0, 10^2.5])
xlim([0, 10^2.5])
set(gca, ...
    'YScale', 'log', ...
    'XScale', 'log', ...
    'YMinorTick', 'off', ...
    'XMinorTick', 'off', ...
    'YMinorGrid', 'off', ...
    'XMinorGrid', 'off')
box on
grid on
% saveas(gcf,'anymal-pd-plots/anymal-plot-log.eps','epsc')
% saveas(gcf,'anymal-pd-plots/anymal-plot-log.fig','fig')
% saveas(gcf,'anymal-pd-plots/anymal-plot-log.png')

% speed bar graph (1 anymal)
c = categorical({...
    'Rai';...
    'BtMultibody';...
    'DartDantzig';...
    'DartPGS';...
    'MjcPGS';...
    'MjcCG';...
    'MjcNewton';...
    'OdeStd'
    });
values = [...
    numIter / RAI_mins(1)           / 1000; ...
    numIter / BT_mins(1)            / 1000; ...
    numIter / DART_DAN_BT_mins(1)   / 1000; ...
    numIter / DART_PGS_BT_mins(1)   / 1000; ...
    numIter / MJC_PGS_mins(1)       / 1000; ...
    numIter / MJC_CG_mins(1)        / 1000; ...
    numIter / MJC_NEWTON_mins(1)    / 1000; ...
    numIter / ODE_mins(1)           / 1000 ...
    ];

T2 = table(c, values);
T2.Properties.VariableNames = {'sim','speed'};
T2 = sortrows(T2, 2, 'descend');

T2.sim = reordercats(T2.sim,cellstr(T2.sim));

figure('Name', 'speed', 'Position', [0, 0, 600, 500])
bar(T2.sim(1), T2.speed(1), 'FaceColor', plotspec.RAIRAIRAI{3})            
hold on
bar(T2.sim(2), T2.speed(2), 'FaceColor', plotspec.MUJOCOPGSEULER{3})         
bar(T2.sim(3), T2.speed(3), 'FaceColor', plotspec.MUJOCOCGEULER{3})          
bar(T2.sim(4), T2.speed(4), 'FaceColor', plotspec.MUJOCONEWTONEULER{3})      
bar(T2.sim(5), T2.speed(5), 'FaceColor', plotspec.BULLETMULTIBODYBULLET{3})   
bar(T2.sim(6), T2.speed(6), 'FaceColor', plotspec.DARTDANTZIGDART{3})       
bar(T2.sim(7), T2.speed(7), 'FaceColor', plotspec.DARTPGSDART{3})      
bar(T2.sim(8), T2.speed(8), 'FaceColor', plotspec.ODESTANDARDODE{3})  
hold off
title('ANYmal PD control test')
% numbers on bars
text(1:length(T2.speed), ...
    T2.speed, ...
    num2str(T2.speed, '%0.2f'),...
    'vert', 'bottom', ...
    'horiz','center', ...
    'FontWeight','bold');
ylabel(sprintf('timestep per second (kHz)'))
ylim([0, 120])

% saveas(gcf,'anymal-pd-plots/anymal-speed-bar.eps','epsc')
% saveas(gcf,'anymal-pd-plots/anymal-speed-bar.fig','fig')
% saveas(gcf,'anymal-pd-plots/anymal-speed-bar.png')