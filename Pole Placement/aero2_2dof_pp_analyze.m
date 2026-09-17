%%
clear; clc; close all;

%%
% Load measured data from past run
load('SimModel.mat');
% store in variables
t = SimModel(1,:); % time (s)
theta_quarc = SimModel(2,:); % pitch voltage (V)
theta_lin = 180/pi*SimModel(3,:); % desired pitch angle (deg)
theta_nelin = 180/pi*SimModel(4,:); % pitch angle (deg)
yaw_quarc = SimModel(5,:); % yaw voltage (V)
yaw_lin = 180/pi*SimModel(6,:); % desired yaw angle (deg)
yaw_nelin = 180/pi*SimModel(7,:); % yaw angle (deg)
%
% figure;
% subplot(2,2,1);
% plot(t,theta_d,t,theta);
% grid on
% title('Pitch');
% ylabel('Angle (deg)');
% subplot(2,2,3);
% plot(t,Vp);
% grid on
% ylabel('Pitch Motor (V)');
% xlabel('time (s)');
% % 
% subplot(2,2,2);
% plot(t,yaw_d,t,yaw);
% grid on
% title('Yaw');
% ylabel('Angle (deg)');
% subplot(2,2,4);
% plot(t,Vy);
% grid on
% ylabel('Yaw Motor (V)');
% xlabel('time (s)');
% cleanfigure
% matlab2tikz('PPsimQUARC_20.tex','width', '\textwidth');

%% 
load('RealModel.mat');
% store in variables
% t = RealModel(1,:); % time (s)
theta_real = Rea_Model(2,:); % pitch voltage (V)
% theta_d = 180/pi*RealModel(3,:); % desired pitch angle (deg)
% theta = 180/pi*RealModel(4,:); % pitch angle (deg)
yaw_real = Rea_Model(5,:); % yaw voltage (V)
% yaw_d = 180/pi*RealModel(6,:); % desired yaw angle (deg)
% yaw = 180/pi*RealModel(7,:); % yaw angle (deg)
%
% figure;
% subplot(2,2,1);
% plot(t,theta_d,t,theta);
% grid on
% title('Pitch');
% ylabel('Angle (deg)');
% subplot(2,2,3);
% plot(t,Vp);
% grid on
% ylabel('Pitch Motor (V)');
% xlabel('time (s)');
% % 
% subplot(2,2,2);
% plot(t,yaw_d,t,yaw);
% grid on
% title('Yaw');
% ylabel('Angle (deg)');
% subplot(2,2,4);
% plot(t,Vy);
% grid on
% ylabel('Yaw Motor (V)');
% xlabel('time (s)');
% cleanfigure
% matlab2tikz('PPrealQUARC_20.tex','width', '\textwidth');
%% 

figure
subplot(2,1,1)
plot(t, theta_quarc, "Color", "r");
hold on
grid on
plot(t, theta_real, "Color", "b");
plot(t, theta_lin, 'k--');
plot(t, theta_nelin, 'k:');
ylabel(['$\theta$' ' [rad]'],'Interpreter','latex');
subplot(2,1,2)
plot(t, yaw_quarc, "Color", "r");
hold on
grid on
plot(t, yaw_real, "Color", "b");
plot(t, yaw_lin, 'k--');
plot(t, yaw_nelin, 'k:');
ylabel(['$\psi$' ' [rad]'],'Interpreter','latex');
xlabel('Time (s)');
set(gcf,'visible','on')
