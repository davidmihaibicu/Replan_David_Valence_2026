%%
clear; clc; close all;

%%
% Load measured data from past run
load('DataLQIControlSim.mat');
% store in variables
t = DataLQIControlSim(1,:); % time (s)
Vp = DataLQIControlSim(2,:); % pitch voltage (V)
theta_d = 180/pi*DataLQIControlSim(3,:); % desired pitch angle (deg)
theta = 180/pi*DataLQIControlSim(4,:); % pitch angle (deg)
Vy = DataLQIControlSim(5,:); % yaw voltage (V)
yaw_d = 180/pi*DataLQIControlSim(6,:); % desired yaw angle (deg)
yaw = 180/pi*DataLQIControlSim(7,:); % yaw angle (deg)
%
fig = figure;
subplot(2,2,1);
plot(t,theta_d,t,theta);
grid on
title('Pitch');
ylabel(['$\theta$' ' [deg]'], 'Interpreter','latex'); 
subplot(2,2,3);
plot(t,Vp);
grid on
ylabel(['$V_p$' ' [V]'], 'Interpreter','latex');
xlabel('time (s)');
% 
subplot(2,2,2);
plot(t,yaw_d,t,yaw);
grid on
title('Yaw');
ylabel(['$\psi$' ' [deg]'], 'Interpreter','latex');
subplot(2,2,4);
plot(t,Vy);
grid on
ylabel(['$V_y$' ' [V]'], 'Interpreter','latex');
xlabel('time (s)');
sgtitle('LQI Control Response');
set(gcf, "Visible", "on");
cleanfigure;
matlab2tikz('LQI_sim.tex','width','\textwidth');

%%
% Load measured data from past run
load('DataLQIControl.mat');
% store in variables
t = DataLQIControl(1,:); % time (s)
Vp = DataLQIControl(2,:); % pitch voltage (V)
theta_d = 180/pi*DataLQIControl(3,:); % desired pitch angle (deg)
theta = 180/pi*DataLQIControl(4,:); % pitch angle (deg)
Vy = DataLQIControl(5,:); % yaw voltage (V)
yaw_d = 180/pi*DataLQIControl(6,:); % desired yaw angle (deg)
yaw = 180/pi*DataLQIControl(7,:); % yaw angle (deg)
%
fig = figure;
subplot(2,2,1);
plot(t,theta_d,t,theta);
grid on
title('Pitch');
ylabel(['$\theta$' ' [deg]'], 'Interpreter','latex'); 
subplot(2,2,3);
plot(t,Vp);
grid on
ylabel(['$V_p$' ' [V]'], 'Interpreter','latex');
xlabel('time (s)');
% 
subplot(2,2,2);
plot(t,yaw_d,t,yaw);
grid on
title('Yaw');
ylabel(['$\psi$' ' [deg]'], 'Interpreter','latex');
subplot(2,2,4);
plot(t,Vy);
grid on
ylabel(['$V_y$' ' [V]'], 'Interpreter','latex');
xlabel('time (s)');
sgtitle('LQI Control Response');
set(gcf, "Visible", "on");
cleanfigure;
matlab2tikz('LQI_real_sine.tex','width','\textwidth');