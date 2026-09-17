%%
clear; clc; close all;

%%
% Load the AERO 2 Parameters
aero2_parameters;
% Load stiffness, damping, and thrust parameters values
aero2_parameters_id;

%% Create state-space model in MATLAB
A = ...;
B = ...;
C = ...;
D = ...;
aero2_ss = ss(A,B,C,D)

% open-loop poles:
eig(aero2_ss)

%% State-Feedback LQR Control Design
PO_p_max = 5; % percentage
PO_y_max = PO_p_max;
tp_p_max = 2.5; % seconds
tp_y_max = 3.5;
PO_p = 4;
PO_y = 4;
tp_p = 2;
tp_y = 3;

p1_p = ...; 
p2_p = ...; 
p1_y = ...; 
p2_y = ...; 

% Calculate the desired characteristic equation coefficients
desired_poles = [p1_p, p2_p, p1_y, p2_y];
char_eq = poly(desired_poles);

% Display the characteristic equation
disp('Desired characteristic equation coefficients:');
disp(char_eq);


% calculate state-feedback gain K
Q = ...;
R = ...;
K = lqr(A,B,Q,R);

% Verify the stability of the closed-loop system with state feedback
poles_closed = eig(A - B*K);
disp('Closed-loop poles:');
disp(poles_closed);
% Display state-feedback gain K
disp('State-feedback gain K:');
disp(K);
eig(A-B*K)


%% Control Simulation
open("s_aero2_2dof_lqr")
sim("s_aero2_2dof_lqr")

%% Plot response using the data logged from the Simulink scopes.  
t = Aero2_LQR_Sim_Vp.time; % time (s)
Vp = Aero2_LQR_Sim_Vp.signals.values; % pitch voltage (V)
theta_d_sim = Aero2_LQR_Sim_Pitch.signals(1).values; % desired/command pitch angle (rad)
theta_sim = Aero2_LQR_Sim_Pitch.signals(2).values; % pitch angle response (rad)
Vy = Aero2_LQR_Sim_Vy.signals.values; % yaw voltage (V)
psi_d_sim = Aero2_LQR_Sim_Yaw.signals(1).values; % desired/command yaw angle (rad)
psi_sim = Aero2_LQR_Sim_Yaw.signals(2).values; % yaw angle response (rad)
% 
figure;
subplot(2,2,1);
plot(t,theta_d_sim,t,theta_sim);
title('Pitch Angle');
ylabel('pitch (deg)'); 
subplot(2,2,2);
plot(t,psi_d_sim,t,psi_sim);
title('Yaw Angle');
ylabel('yaw (deg)'); 
subplot(2,2,3);
plot(t,Vp);
title('Pitch Rotor/Motor Voltage');
ylabel('rotor 0 (V)'); 
subplot(2,2,4);
plot(t,Vy);
title('Yaw Rotor/Motor Voltage');
ylabel('rotor 1 (V)'); 
sgtitle('LQR Control Simulation');

