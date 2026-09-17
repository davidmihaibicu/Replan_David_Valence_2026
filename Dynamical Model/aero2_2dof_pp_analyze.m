%%
clear; clc; close all;

%%
% Load measured data from past run
load('SimModel.mat');
% store in variables
t = SimModel(1,:); % time (s)
theta_quarc = 180/pi*SimModel(2,:); % pitch voltage (V)
theta_lin = 180/pi*SimModel(3,:); % desired pitch angle (deg)
theta_nelin = 180/pi*SimModel(4,:); % pitch angle (deg)
yaw_quarc = 180/pi * SimModel(5,:); % yaw voltage (V)
yaw_lin = 180/pi*SimModel(6,:); % desired yaw angle (deg)
yaw_nelin = 180/pi*SimModel(7,:); % yaw angle (deg)
% %
% fig = figure;
% subplot(2,2,1);
% plot(t,theta_d,t,theta);
% grid on
% title('Pitch');
% ylabel(['$\theta$' ' [deg]'], 'Interpreter','latex'); 
% subplot(2,2,3);
% plot(t,Vp);
% grid on
% ylabel(['$V_p$' ' [V]'], 'Interpreter','latex');
% xlabel('time (s)');
% % 
% subplot(2,2,2);
% plot(t,yaw_d,t,yaw);
% grid on
% title('Yaw');
% ylabel(['$\psi$' ' [deg]'], 'Interpreter','latex');
% subplot(2,2,4);
% plot(t,Vy);
% grid on
% ylabel(['$V_y$' ' [V]'], 'Interpreter','latex');
% xlabel('time (s)');
% sgtitle('Pole placement PD Control Response');
% set(gcf, "Visible", "on");
% cleanfigure
% matlab2tikz('PPsimQUARC_ftj.tex','width','\textwidth');
% Load measured data from past run
% store in variables
% t = DataPPControlReal(1,:); % time (s)
theta_real = 180 / pi * RealModel(2,:); % pitch voltage (V)
% theta_d = 180/pi*DataPPControlReal(3,:); % desired pitch angle (deg)
% theta = 180/pi*DataPPControlReal(4,:); % pitch angle (deg)
yaw_real = 180 / pi * RealModel(5,:); % yaw voltage (V)
% yaw_d = 180/pi*DataPPControlReal(6,:); % desired yaw angle (deg)
% yaw = 180/pi*DataPPControlReal(7,:); % yaw angle (deg)

%%

fig = figure;
subplot(2,1,1);
plot(t,theta_lin,'k--');
hold on
grid on
plot(t, theta_nelin, 'k:');
plot(t, theta_quarc, 'r');
plot(t, theta_real, 'b');
title(['Pitch (' '$\theta$' ')'], 'Interpreter','latex');
ylabel(['$\theta$' ' [deg]'], 'Interpreter','latex'); 
subplot(2,1,2);
plot(t,yaw_lin,'k--');
hold on
grid on
plot(t, yaw_nelin, 'k:');
plot(t, yaw_quarc, 'r');
plot(t, yaw_real, 'b');
title(['Yaw (' '$\psi$' ')'], 'Interpreter','latex');
ylabel(['$\psi$' ' [deg]'], 'Interpreter','latex'); 
legend({'linear model', 'nonlinear model', 'QUARC simulator', 'Real plant'},'Location','northwest',NumColumns=2 )
cleanfigure;
matlab2tikz('Simulation.tex')