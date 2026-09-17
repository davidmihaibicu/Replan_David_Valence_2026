%%
clear; clc; close all;

%%
% Load the AERO 2 Parameters
aero2_parameters;
% Load stiffness, damping, and thrust parameters values
aero2_parameters_id;

%% Create state-space model in MATLAB
load("PPlin_20.mat")

% open-loop poles:
eig(aero2_ss)

%% State-Feedback Pole Placement Control Design
PO_p_max = 5; % percentage
PO_y_max = PO_p_max;
tp_p_max = 2.5; % seconds
tp_y_max = 3.5;
PO_p = 4.5;
PO_y = 4.5;
tp_p = 1.5;
tp_y = 1.5;

zeta_p = log(100/PO_p)/sqrt(pi^2 + log(100/PO_p)^2);
wn_p = pi/tp_p/sqrt(1 - zeta_p^2);

zeta_y = log(100/PO_y)/sqrt(pi^2 + log(100/PO_y)^2);
wn_y = pi/tp_y/sqrt(1 - zeta_y^2);

p1_p = -zeta_p*wn_p + 1i*wn_p*sqrt(1 - zeta_p^2); 
p2_p = -zeta_p*wn_p - 1i*wn_p*sqrt(1 - zeta_p^2);
p1_y = -zeta_y*wn_y + 1i*wn_y*sqrt(1 - zeta_y^2);
p2_y = -zeta_y*wn_y - 1i*wn_y*sqrt(1 - zeta_y^2);

% Calculate the desired characteristic equation coefficients
desired_poles = [p1_p, p2_p, p1_y, p2_y];
char_eq = poly(desired_poles);

% Display the characteristic equation
disp('Desired characteristic equation coefficients:');
disp(char_eq);

% calculate state-feedback gain K
K = place(A, B, desired_poles);
% Verify the stability of the closed-loop system with state feedback
poles_closed = eig(A - B*K);
disp('Closed-loop poles:');
disp(poles_closed);
% Display state-feedback gain K
disp('State-feedback gain K:');
disp(K);
eig(A-B*K)


%% Control Simulation
open("s_aero2_2dof_pp")
sim("s_aero2_2dof_pp")

%% Plot response using the data logged from the Simulink scopes.  
t = Aero2_PP_Sim_Vp.time; % time (s)
Vp = Aero2_PP_Sim_Vp.signals.values; % pitch voltage (V)
theta_d_sim = Aero2_PP_Sim_Pitch.signals(1).values; % desired/command pitch angle (rad)
theta_sim = Aero2_PP_Sim_Pitch.signals(2).values; % pitch angle response (rad)
Vy = Aero2_PP_Sim_Vy.signals.values; % yaw voltage (V)
psi_d_sim = Aero2_PP_Sim_Yaw.signals(1).values; % desired/command yaw angle (rad)
psi_sim = Aero2_PP_Sim_Yaw.signals(2).values; % yaw angle response (rad)
% 
figure;
subplot(2,2,1);
plot(t,theta_d_sim,t,theta_sim);
grid on
title('Pitch Angle');
ylabel('pitch (deg)'); 
subplot(2,2,2);
plot(t,psi_d_sim,t,psi_sim);
grid on
title('Yaw Angle');
ylabel('yaw (deg)'); 
subplot(2,2,3);
plot(t,Vp);
title('Pitch Rotor/Motor Voltage');
ylabel('rotor 0 (V)'); 
grid on
subplot(2,2,4);
plot(t,Vy);
title('Yaw Rotor/Motor Voltage');
ylabel('rotor 1 (V)'); 
grid on
sgtitle('PP Control Simulation');

