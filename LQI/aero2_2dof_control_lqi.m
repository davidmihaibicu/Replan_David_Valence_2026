%%
clear; clc; close all;

%%
% Load the AERO 2 Parameters
aero2_parameters;
% Load stiffness, damping, and thrust parameters values
aero2_parameters_id;

%% Create state-space model in MATLAB
A = [0 0 1 0 0 0;
     0 0 0 1 0 0;
     0 0 0 0 1 0;
     0 0 0 0 0 1;
     0 0 -Ksp/Jp 0 -Dp/Jp 0;
     0 0 0 0 0 -Dy/Jy];
B = [0 0; 0 0; 0 0; 0 0; Kpp*Dt/Jp Kpy*Dt/Jp; Kyp*Dt/Jy Kyy*Dt/Jy];
C = [0 0 1 0 0 0; 0 0 0 1 0 0];
D = zeros(2);
aero2_ss = ss(A,B,C,D)

% open-loop poles:
eig(aero2_ss)

R = ctrb(A, B)
disp(rank(R))
%% State-Feedback LQR Control Design
% PO_p_max = 5; % percentage
% PO_y_max = PO_p_max;
% tp_p_max = 2.5; % seconds
% tp_y_max = 3.5;
% PO_p = 4;
% PO_y = 4;
% tp_p = 2;
% tp_y = 3;
% 
% p1_p = ...; 
% p2_p = ...; 
% p1_y = ...; 
% p2_y = ...; 
% 
% % Calculate the desired characteristic equation coefficients
% desired_poles = [p1_p, p2_p, p1_y, p2_y];
% char_eq = poly(desired_poles);
% 
% % Display the characteristic equation
% disp('Desired characteristic equation coefficients:');
% disp(char_eq);

% calculate state-feedback gain K
Q = diag([1e-1 1e-2 5e4 5e4 2e4 1e4]);
R = eye(2);
K = lqr(A, B, Q, R);


% Verify the stability of the closed-loop system with state feedback
poles_closed = eig(A - B*K);
disp('Closed-loop poles:');
disp(poles_closed);
% Display state-feedback gain K
disp('State-feedback gain K:');
disp(K);
eig(A-B*K)


%% Control Simulation
open("s_aero2_2dof_lqi")
sim("s_aero2_2dof_lqi");

%% Plot response using the data logged from the Simulink scopes.  
load('SimLQIControl.mat');
% store in variables
t = SimLQIControl(1,:); % time (s)
Vp = SimLQIControl(2,:); % pitch voltage (V)
theta_d = SimLQIControl(3,:); % desired pitch angle (deg)
theta = SimLQIControl(4,:); % pitch angle (deg)
Vy = SimLQIControl(5,:); % yaw voltage (V)
yaw_d = SimLQIControl(6,:); % desired yaw angle (deg)
yaw = SimLQIControl(7,:); % yaw angle (deg)
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
cleanfigure
matlab2tikz('LQI_LinModel.tex','width','\textwidth');
