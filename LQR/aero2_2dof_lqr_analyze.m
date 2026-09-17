%%
clear; clc; close all;

%%
% Load measured data from past run
load('DataLQRControl.mat');
% store in variables
t = DataLQRControl(1,:); % time (s)
Vp = DataLQRControl(2,:); % pitch voltage (V)
theta_d = 180/pi*DataLQRControl(3,:); % desired pitch angle (deg)
theta = 180/pi*DataLQRControl(4,:); % pitch angle (deg)
Vy = DataLQRControl(5,:); % yaw voltage (V)
yaw_d = 180/pi*DataLQRControl(6,:); % desired yaw angle (deg)
yaw = 180/pi*DataLQRControl(7,:); % yaw angle (deg)
%
figure;
subplot(2,2,1);
plot(t,theta_d,t,theta);
title('Pitch');
ylabel('Angle (deg)');
subplot(2,2,3);
plot(t,Vp);
ylabel('Pitch Motor (V)');
xlabel('time (s)');
% 
subplot(2,2,2);
plot(t,yaw_d,t,yaw);
title('Yaw');
ylabel('Angle (deg)');
subplot(2,2,4);
plot(t,Vy);
ylabel('Yaw Motor (V)');
xlabel('time (s)');
sgtitle('LQR Control Response');
