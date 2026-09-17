clc
clear all
close all

%% 

load("SimModel.mat");
t = SimModel(1,:);
theta_measured = 180 / pi * SimModel(2,:);
theta_lin = 180 / pi * SimModel(3,:);
theta_nelin = 180 / pi * SimModel(4,:);
psi_measured = 180 / pi * SimModel(5,:);
psi_lin = 180 / pi * SimModel(6,:);
psi_nelin = 180 / pi * SimModel(7,:);

fig = figure;
subplot(2, 1, 1);
plot(t, theta_measured);
hold on
grid on
plot(t, theta_lin,t,theta_nelin);
ylabel(['Pitch - ','$\theta$', ' [deg]'], 'Interpreter', 'latex');
xlim([0 90]);
% legend('measured', 'linear model');
title("Linear Model vs QUARC Simulator")
subplot(2, 1, 2);
plot(t, psi_measured);
hold on
grid on
plot(t, psi_lin,t,psi_nelin);
xlabel('Time (s)');
ylabel(['Yaw - ', '$\psi$', ' [deg]'], 'Interpreter', 'latex');
xlim([0 90]);
legend('simulator', 'linear model', 'nonlinear model','Location','west');
set(gcf, "Visible", "on");
cleanfigure;
matlab2tikz('SimulationModelxp.tex','width','\textwidth')


%% 

load("RealModel.mat");
t = RealModel(1,:);
theta_measured = 180 / pi * RealModel(2,:);
theta_lin = 180 / pi * RealModel(3,:);
psi_measured = 180 / pi * RealModel(4,:);
psi_lin = 180 / pi * RealModel(5,:);

fig = figure;
subplot(2, 1, 1);
plot(t, theta_measured);
hold on
grid on
plot(t, theta_lin,t,theta_nelin);
ylabel(['Pitch - ','$\theta$', ' [deg]'], 'Interpreter', 'latex');
xlim([0 90]);
% legend('measured', 'linear model');
title("Linear Model vs Real Plant")
subplot(2, 1, 2);
plot(t, psi_measured);
hold on
grid on
plot(t, psi_lin,t,psi_nelin);
xlabel('Time (s)');
ylabel(['Yaw - ', '$\psi$', ' [deg]'], 'Interpreter', 'latex');
xlim([0 90]);
legend('real plant', 'linear model', 'nonlinear model','Location','west');
set(gcf, "Visible", "on");
cleanfigure;
matlab2tikz('RealModelxp.tex', 'width', '\textwidth');