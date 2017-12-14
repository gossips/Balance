%% Pre-process
% No pre-process is required

%% Load time series
% Load only if the time series is not already loaded
if (~exist('comf', 'var'))
    filename = 'timeseries.mat';
    load(filename, 'comf');
end

%% Extract information
% Choose an individual
i = 99;

% Extract the relevant time series
APs = comf.copAPs_pmc_dt(i,1:end-1);
MLs = comf.copMLs_pmc_dt(i,1:end-1);
Tots = sqrt(APs.^2 + MLs.^2);
time_steps = numel(APs(:));

% Extract the physical times
sampling_period = 1e-3;
ts = 0:sampling_period:sampling_period*(time_steps-1);

% Compute speeds
AP_speeds = gradient(APs, ts);
ML_speeds = gradient(MLs, ts);

% Compute accelerations
AP_accels = gradient(AP_speeds, ts);
ML_accels = gradient(ML_speeds, ts);

%% Plot results
% Pre-measure to choose appropriate scales
AP_max = max(abs(APs));
ML_max = max(abs(MLs));
plot_lims = max(AP_max, ML_max);

% Pre-define axis labels
time_label = 't (s)';
disp_label = 's (cm)';
speed_label = 'v (cm/s)';
accel_label = 'a (cm/s^2)';

% Plot the time series
figure;

subplot(2, 2, 1);
plot(APs, MLs, 'Color', 'k');
axis equal; xlim([-plot_lims, plot_lims]); ylim([-plot_lims, plot_lims]);
title(sprintf('COP. Patient %i', i));

subplot(2, 2, 2);
plot(ts, MLs, 'Color', 'k');
ylim([-plot_lims, plot_lims]);
title('ML');
xlabel(time_label);
ylabel(disp_label);

subplot(2, 2, 3);
plot(ts, APs, 'Color', 'k');
ylim([-plot_lims, plot_lims]);
camroll(-90);
title('AP');
xlabel(time_label);
ylabel(disp_label);

subplot(2, 2, 4);
plot(ts, Tots, 'Color', 'k');
ylim([0, plot_lims]);
title('Totals');
xlabel(time_label);
ylabel(disp_label);

% Plot time series and derivatives
figure;

subplot(3, 2, 1);
plot(ts, APs, 'Color', 'k');
ylim([-plot_lims, plot_lims]);
title('AP');
xlabel(time_label);
ylabel(disp_label);

subplot(3, 2, 2);
plot(ts, MLs, 'Color', 'k');
ylim([-plot_lims, plot_lims]);
title('ML');
xlabel(time_label);
ylabel(disp_label);

subplot(3, 2, 3);
plot(ts, AP_speeds, 'Color', 'b');
title('AP speed');
xlabel(time_label);
ylabel(speed_label);

subplot(3, 2, 4);
plot(ts, ML_speeds, 'Color', 'b');
title('ML speed');
xlabel(time_label);
ylabel(speed_label);

subplot(3, 2, 5);
plot(ts, AP_accels, 'Color', 'r');
title('AP acceleration');
ylim([-1.5, 1.5]);
xlabel(time_label);
ylabel(accel_label);

subplot(3, 2, 6);
plot(ts, ML_accels, 'Color', 'r');
title('ML acceleration');
ylim([-1.5, 1.5]);
xlabel(time_label);
ylabel(accel_label);