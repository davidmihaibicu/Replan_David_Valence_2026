%%
clc; clear; close all;


%%
% Load parameters
load("lin_disc_7071.mat");


% Discretize the system

import casadi.*

Ts = 0.2; % Sampling time
sys_disc = c2d(ss_c, Ts, 'zoh'); % Discretize the system using zero-order hold

[A, B, C, D] = ssdata(sys_disc);
% Initial conditions
[dx, du] = size(B);
dy = size(C, 1);
x0 = [0; 0; 0; 0];
u0 = zeros(du, 1);

% Constraints
umin = -24;
umax = 24;
delta_u_min = -5;
delta_u_max = 5;
theta_min = -0.89;
theta_max = +0.89;

% Weighting matrices
Q = diag([1e4 5e3 1e1 5]);
R = 1e-1*eye(2);
P = 1e1*Q;

% Horizons
Npred = 20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=======================================
solver = casadi.Opti();

% Variables and Parameters
x = solver.variable(dx, Npred+1);
u = solver.variable(du, Npred);
xinit = solver.parameter(dx, 1);
uinit = solver.parameter(du, 1);
xref = solver.parameter(dx, 1);

% Constraints
solver.subject_to(x(:,1) == xinit);
for k = 1:Npred
    solver.subject_to(x(:,k+1) == A * x(:,k) + B * u(:,k));
    solver.subject_to(umin <= u(:,k));
    solver.subject_to(u(:,k) <= umax);
    solver.subject_to(theta_min <= x(1,k+1));
    solver.subject_to(x(1,k+1) <= theta_max);
    
end

% Cost
objective = 0;
for k = 1:Npred
    objective = objective + (x(:,k) - xref)' * Q * (x(:,k) - xref) + u(:,k)' * R * u(:,k);
end
objective = objective + (x(:,Npred+1) - xref)' * P * (x(:,Npred+1) - xref);
solver.minimize(objective);

% Solver options
opts = struct('qpsol', 'qrqp', 'print_time', false);
solver.solver('sqpmethod', opts);

%%
Tfinal = 30;
t = 0:Ts:Tfinal;
t = t(1:end-1);
Nsim = length(t);
% Reference (tracking only theta)
ref1 = -deg2rad(20) * square(2*pi*0.05*t);
ref2 = -deg2rad(45) * square(2*pi*0.04*t);
ref = [ref1; ref2; zeros(2,Nsim)];

%% Simulation loop
xsim = zeros(dx, Nsim+1);
xsim(:,1) = x0;
usim = zeros(du, Nsim);
ysim = zeros(dy, Nsim);
usiminit = u0;

timer = tic;
for i = 1:Nsim
    xref_val = ref(:,i);
    solver.set_value(xinit, xsim(:,i));
    solver.set_value(xref, xref_val);
    solver.set_value(uinit, usiminit);

    sol = solver.solve();
    u_mpc = sol.value(u(:,1));

    usim(:,i) = u_mpc;
    usiminit = u_mpc;
    xsim(:,i+1) = A*xsim(:,i) + B*u_mpc;
    ysim(:,i) = C*xsim(:,i) + D*u_mpc;
    solver.set_initial(sol.value_variables());
end
time_CasAdi = toc(timer);

%% Plotting
figure;
subplot(2,2,1)
plot(t, ysim(1,:)); hold on;
plot(t, ref(1,:),'--'); grid on
ylabel('\theta [rad]');
title('Pitch');
subplot(2,2,2)
plot(t, ysim(2,:)); hold on;
plot(t, ref(2,:),'--'); grid on
ylabel('\psi [rad]');
title('Yaw');
subplot(2,2,3)
plot(t, usim(1,:)); grid on
xlabel('Time [s]');
ylabel('V_p [V]');
subplot(2,2,4)
plot(t, usim(2,:)); grid on
xlabel('Time [s]');
ylabel('V_y [V]');
%% 

cleanfigure;
matlab2tikz('MPClin.tex','width','\textwidth')
%% Errors
% ref = ref(1:Nsim);
% error = abs(ysim - ref);
% AvgError = mean(error, 2);
% fprintf('Average error θ: %.4f rad\n', AvgError(1));
% fprintf('Average control effort: %.4f V\n', mean(abs(usim)));

%% Time
fprintf("Total  simulation time: %f seconds. \n", time_CasAdi);

