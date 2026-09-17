%%
clear; clc; close all;

%%
% Load the AERO 2 Parameters
aero2_parameters;
% Load stiffness, damping, and thrust parameters values
aero2_parameters_id;

%% Create state-space model in MATLAB
theta = deg2rad(-45);
xref = [theta, 0, 0, 0]';
[xstar, ustar, ystar,~] = trim('nonlinear_model_pin', xref, [], [], ones(4,1), [], [])
[A, B, C, D] = linmod('nonlinear_model_pin', xstar, ustar);
aero2_ss = ss(A,B,C,D)

%save('PPlin_20.mat', "A", "B", "C", "D", "aero2_ss", "ustar","ystar","xstar");

disp('A = ')
disp(A);
disp('B = ')
disp(B)

% open-loop poles:
eig(A)

% controlability
R = ctrb(A, B)
disp(rank(R))

% observability
O = obsv(A, C)
disp(rank(O))

disp('A = ')
disp(A);
disp('B = ')
disp(B)

% open-loop poles:
eig(A)

% controlability
R = ctrb(A, B)
disp(rank(R))

% observability
O = obsv(A, C)
disp(rank(O))

%% 
Vp = linspace(-24,24,20);
Vy = linspace(-24,24,20);

%% 
theta = zeros(20, 20);
psi = zeros(20, 20);
theta_dot = zeros(20, 20);
psi_dot = zeros(20, 20);

x0 = [0 1 0.3 0.5]'; % Vector explicit de stări inițiale

for i = 1:20
    for j = 1:20
        uref = [Vp(i); Vy(j)]; % Corectat: Vy(j) în loc de Vp(j)
        try
            [xstar, ~, ~, ~] = trim('nonlinear_model_pin', x0, uref, [], [], ones(2,1), []);
            theta(i, j) = xstar(1);
            if(theta(i, j) > 0.89 | theta(i,j) < -0.89)
                theta(i, j) = NaN; % Set theta to NaN if out of bounds
                psi(i, j) = NaN;
                theta_dot(i, j) = NaN;
                psi_dot(i, j) = NaN;
                continue;
            end
            psi(i, j) = xstar(2);
            theta_dot(i, j) = xstar(3);
            psi_dot(i, j) = xstar(4);
        catch
            % Dacă nu există soluție de echilibru pentru o anumită combinație de tensiuni
            theta(i, j) = NaN;
            psi(i, j) = NaN;
            theta_dot(i, j) = NaN;
            psi_dot(i, j) = NaN;
        end
    end
end

%% 

save("statepoint.mat","psi_dot","theta_dot","psi","theta","Vy","Vp")

%% 

figure;
subplot(2,2,1)
hold on
mesh(Vp, Vy, -0.89*ones(20));
surf(Vp, Vy, theta);
mesh(Vp, Vy, 0.89*ones(20));
ylim([15 24])
zlim([-1.1, 1.1])
xlabel('$V_{p_0}\rm{ [V]}$','Interpreter','latex');
ylabel('$V_{y_0}\rm{ [V]}$','Interpreter','latex');
zlabel('$\theta\rm{ [rad]}$','Interpreter','latex');
grid on;
view(-37.5+90, 30)
subplot(2,2,2)
hold on
mesh(Vp, Vy, ones(20));
surf(Vp, Vy, psi);
ylim([15 24])
xlabel('$V_{p_0}\rm{ [V]}$','Interpreter','latex');
ylabel('$V_{y_0}\rm{ [V]}$','Interpreter','latex');
zlabel('$\psi\rm{ [rad]}$','Interpreter','latex');
grid on;
view(-37.5+90, 30)
subplot(2,2,3)
hold on
mesh(Vp, Vy, zeros(20));
surf(Vp, Vy, theta_dot);
ylim([15 24])
xlabel('$V_{p_0}\rm{ [V]}$','Interpreter','latex');
ylabel('$V_{y_0}\rm{ [V]}$','Interpreter','latex');
zlabel('$\dot{\theta}\rm{ [rad/s]}$','Interpreter','latex');
grid on;
view(-37.5+90, 30)
subplot(2,2,4)
hold on
mesh(Vp, Vy, zeros(20));
surf(Vp, Vy, psi_dot);
ylim([15 24])
xlabel('$V_{p_0}\rm{ [V]}$','Interpreter','latex');
ylabel('$V_{y_0}\rm{ [V]}$','Interpreter','latex');
zlabel('$\dot{\psi}\rm{ [rad/s]}$','Interpreter','latex');
grid on;
view(-37.5+90, 30)

cleanfigure
matlab2tikz('StatePoint.tex', 'width', '\textwidth');
%% 

theta_max = rad2deg(max(theta,[],"all"))
theta_min = rad2deg(min(theta,[],"all"))

%% 
Ts = 0.2;

xref = [0 0 0 0]';
[xref, uref, ~, ~] = trim('nonlinear_model_pin', xref, [], [], ones(4,1), [], [])
% feval('nonlinear_model_pin', [], [], [], 'term');
[A, B, C, D] = linmod('nonlinear_model_pin', xref, uref);
ss_c = ss(A,B,C,D);
save("lin_disc_7071.mat","ss_c")
%% 


ss_d = c2d(ss_c,Ts,'zoh')
%% 

ss_c
%% 

eig(ss_d.A)
disp(rank(ctrb(ss_d)))
disp(rank(obsv(ss_d)))

%% 

A = ss_d.A;
B = ss_d.B;
C = ss_d.C;
D = ss_d.D;




%% 

