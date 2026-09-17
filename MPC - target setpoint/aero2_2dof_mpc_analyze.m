%
clear; clc; close all;

%% 

load("mpc_set_sim.mat")

fig = figure;
subplot(2,2,1)
plot(Ts*(1:Nsim), 180/pi*xsim(1,1:Nsim),'b-');
hold on 
grid on
plot(Ts*(1:Nsim), -20*ones(1,Nsim), 'k-.');
% plot(Ts*(1:Nsim), 180/pi*theta_min*ones(Nsim), 'k:',Ts*(1:Nsim), 180/pi*theta_max*ones(Nsim), 'k:')
xlim([0 20]);
ylabel(['$\theta$' ' [deg]'], 'Interpreter','latex');
subplot(2,2,3)
plot(Ts*(1:Nsim), usim(1,:),'r-');
grid on
hold on
plot(Ts*(1:Nsim), umin*ones(1,Nsim), 'k:',Ts*(1:Nsim), umax*ones(1,Nsim), 'k:');
xlim([0 20]);
ylim([-25 25]);
ylabel(['$V_p$' ' [V]'], 'Interpreter','latex');
xlabel('Time (s)')

subplot(2,2,2)
plot(Ts*(1:Nsim), 180/pi*xsim(2,1:Nsim),'b-');
hold on 
grid on
plot(Ts*(1:Nsim), 45*ones(1,Nsim), 'k-.');
xlim([0 20]);
ylabel(['$\psi$' ' [deg]'],'Interpreter','latex');
subplot(2,2,4)
plot(Ts*(1:Nsim), usim(2,:),'r-');
grid on
hold on
plot(Ts*(1:Nsim), umin*ones(1,Nsim), 'k:',Ts*(1:Nsim), umax*ones(1,Nsim), 'k:');
xlim([0 20]);
ylim([-25 25]);
ylabel(['$V_y$' ' [V]'], 'Interpreter','latex');
xlabel('Time (s)')
set(gcf, 'visible', 'on')
cleanfigure;
matlab2tikz('MPCset_sim.tex','width','\textwidth');

%% 

load("mpc_track_sim.mat")

fig = figure;
subplot(2,2,1)
plot(Ts*(1:Nsim), 180/pi*xsim(1,1:Nsim),'b-',180/pi*xref(1,1:Nsim),'k-.');
hold on 
grid on
plot(Ts*(1:Nsim), -20*ones(Nsim), 'k-.');
% plot(Ts*(1:Nsim), 180/pi*theta_min*ones(Nsim), 'k:',Ts*(1:Nsim), 180/pi*theta_max*ones(Nsim), 'k:')
xlim([0 30]);
ylabel(['$\theta$' ' [deg]'], 'Interpreter','latex');
subplot(2,2,3)
plot(Ts*(1:Nsim), usim(1,:),'r-');
grid on
hold on
% plot(Ts*(1:Nsim), umin*ones(Nsim), 'k:',Ts*(1:Nsim), umax*ones(Nsim), 'k:');
xlim([0 30]);
ylim([-25 25]);
ylabel(['$V_p$' ' [V]'], 'Interpreter','latex');
xlabel('Time (s)')

subplot(2,2,2)
plot(Ts*(1:Nsim), 180/pi*xsim(2,1:Nsim),'b-',Ts*(1:Nsim), 180/pi*xref(2,1:Nsim),'k-.');
hold on 
grid on
plot(Ts*(1:Nsim), 45*ones(Nsim), 'k-.');
xlim([0 30]);
ylabel(['$\psi$' ' [deg]'],'Interpreter','latex');
subplot(2,2,4)
plot(Ts*(1:Nsim), usim(2,:),'r-');
grid on
hold on
% plot(Ts*(1:Nsim), umin*ones(Nsim), 'k:',Ts*(1:Nsim), umax*ones(Nsim), 'k:');
xlim([0 30]);
ylim([-25 25]);
ylabel(['$V_y$' ' [V]'], 'Interpreter','latex');
xlabel('Time (s)')
set(gcf, 'visible', 'on')
cleanfigure;
matlab2tikz('MPCtrack_sim.tex','width','\textwidth');

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
grid on
title('Pitch (\theta)');
ylabel('\theta (deg)');
subplot(2,2,3);
plot(t,Vp);
grid on
ylabel('V_p (V)');
xlabel('Time (s)');
% 
subplot(2,2,2);
plot(t,yaw_d,t,yaw);
grid on
title('Yaw (\psi)');
ylabel('\psi (deg)');
subplot(2,2,4);
plot(t,Vy);
grid on
ylabel('V_y (V)');
xlabel('Time (s)');
cleanfigure;
matlab2tikz('MPCQUARC.tex','width','\textwidth')

%%
% Load measured data from past run
load('DataLQRControlreal.mat');
% store in variables
t = DataLQRControlreal(1,:); % time (s)
Vp = DataLQRControlreal(2,:); % pitch voltage (V)
theta_d = 180/pi*DataLQRControlreal(3,:); % desired pitch angle (deg)
theta = 180/pi*DataLQRControlreal(4,:); % pitch angle (deg)
Vy = DataLQRControlreal(5,:); % yaw voltage (V)
yaw_d = 180/pi*DataLQRControlreal(6,:); % desired yaw angle (deg)
yaw = 180/pi*DataLQRControlreal(7,:); % yaw angle (deg)
%
figure;
subplot(2,2,1);
plot(t,theta_d,t,theta);
grid on
title('Pitch (\theta)');
ylabel('\theta (deg)');
subplot(2,2,3);
plot(t,Vp);
grid on
ylabel('V_p (V)');
xlabel('Time (s)');
% 
subplot(2,2,2);
plot(t,yaw_d,t,yaw);
grid on
title('Yaw (\psi)');
ylabel('\psi (deg)');
subplot(2,2,4);
plot(t,Vy);
grid on
ylabel('V_y (V)');
xlabel('Time (s)');
cleanfigure;
matlab2tikz('MPCreal2e_3.tex','width','\textwidth')

%%
% Load measured data from past run
load('DataLQRControlreal_1.mat');
% store in variables
t = DataLQRControlreal_1(1,:); % time (s)
Vp = DataLQRControlreal_1(2,:); % pitch voltage (V)
theta_d = 180/pi*DataLQRControlreal_1(3,:); % desired pitch angle (deg)
theta = 180/pi*DataLQRControlreal_1(4,:); % pitch angle (deg)
Vy = DataLQRControlreal_1(5,:); % yaw voltage (V)
yaw_d = 180/pi*DataLQRControlreal_1(6,:); % desired yaw angle (deg)
yaw = 180/pi*DataLQRControlreal_1(7,:); % yaw angle (deg)
%
figure;
subplot(2,2,1);
plot(t,theta_d,t,theta);
grid on
title('Pitch (\theta)');
ylabel('\theta (deg)');
subplot(2,2,3);
plot(t,Vp);
grid on
ylabel('V_p (V)');
xlabel('Time (s)');
% 
subplot(2,2,2);
plot(t,yaw_d,t,yaw);
grid on
title('Yaw (\psi)');
ylabel('\psi (deg)');
subplot(2,2,4);
plot(t,Vy);
grid on
ylabel('V_y (V)');
xlabel('Time (s)');
cleanfigure;
matlab2tikz('MPCreal2e_2.tex','width','\textwidth')

%% 
load("mpc_track_sim_20.mat");
xsim_20 = xsim;
usim_20 = usim;
time_CasADi_20 = time_CasAdi;
load("mpc_track_sim_50.mat");
xsim_50 = xsim;
usim_50 = usim;
time_CasADi_50 = time_CasAdi;
load("mpc_track_sim_100.mat");
xsim_100 = xsim;
usim_100 = usim;
time_CasADi_100 = time_CasAdi;
load("mpc_track_sim_200.mat");
xsim_200 = xsim;
usim_200 = usim;
time_CasADi_200 = time_CasAdi;
%% 

figure;
subplot(2,1,2);
p0 = plot(Ts*(1:Nsim), 180/pi*xref(2,1:Nsim),'k-');
hold on
grid on
p1 = plot(Ts*(1:Nsim), 180/pi*xsim_20(2,1:Nsim),'b-.');
p2 = plot(Ts*(1:Nsim), 180/pi*xsim_50(2,1:Nsim),'r-.');
p3 = plot(Ts*(1:Nsim), 180/pi*xsim_100(2,1:Nsim),'g-.');
p4 = plot(Ts*(1:Nsim), 180/pi*xsim_200(2,1:Nsim),'m-.');
ylabel(['$\psi$' ' (deg)'], 'Interpreter','latex');
title(['Yaw ' '$\psi$'], 'Interpreter','latex');
xlabel('Time (s)');
legend([p1 p2 p3 p4], {'$N_{pred}=20$','$N_{pred}=50$','$N_{pred}=100$','$N_{pred}=200$'},'Interpreter','latex','Location','northwest');
subplot(2,1,1);
p0 = plot(Ts*(1:Nsim), 180/pi*xref(1,1:Nsim),'k-');
hold on
grid on
p1 = plot(Ts*(1:Nsim), 180/pi*xsim_20(1,1:Nsim),'b-.');
p2 = plot(Ts*(1:Nsim), 180/pi*xsim_50(1,1:Nsim),'r-.');
p3 = plot(Ts*(1:Nsim), 180/pi*xsim_100(1,1:Nsim),'g-.');
p4 = plot(Ts*(1:Nsim), 180/pi*xsim_200(1,1:Nsim),'m-.');
ylabel(['$\theta$' ' (deg)'], 'Interpreter','latex');
title(['Pitch ' '$\theta$'], 'Interpreter','latex');
xlabel('Time (s)');
legend([p1 p2 p3 p4], {'$N_{pred}=20$','$N_{pred}=50$','$N_{pred}=100$','$N_{pred}=200$'},'Interpreter','latex','Location','northwest')
cleanfigure;
matlab2tikz('MPC_track_sim.tex')

%% 

figure
x = [20 50 100 200];
y = [time_CasADi_20 time_CasADi_50 time_CasADi_100 time_CasADi_200];
plot(x,y,'b:o')
grid on
xlabel('$N_{pred}$','Interpreter','latex')
ylabel('Computed time (s)')
title('Online computation vs prediction horizon')
cleanfigure
matlab2tikz('MPC_track_pred_ctime.tex','width','\textwidth');
% figure;
% subplot(2,2,1);
% grid on
% p1 = plot(Ts*(1:Nsim), usim_20(2,1:Nsim),'b-');
% p2 = plot(Ts*(1:Nsim), usim_50(2,1:Nsim),'r-');
% p3 = plot(Ts*(1:Nsim), usim_100(2,1:Nsim),'g-');
% p4 = plot(Ts*(1:Nsim), usim_200(2,1:Nsim),'k-');
% ylabel(['$V_y$' ' (V)'], 'Interpreter','latex');
% xlabel('Time (s)');
% subplot(2,2,3);
% hold on
% grid on
% p1 = plot(Ts*(1:Nsim), usim_20(1,1:Nsim),'b-');
% p2 = plot(Ts*(1:Nsim), usim_50(1,1:Nsim),'r-');
% p3 = plot(Ts*(1:Nsim), usim_100(1,1:Nsim),'g-');
% p4 = plot(Ts*(1:Nsim), usim_200(1,1:Nsim),'k-');
% ylabel(['$V_p$' ' (V)'], 'Interpreter','latex');
% xlabel('Time (s)');
% legend([p1 p2 p3 p4], {'$N_{pred}=20$','$N_{pred}=50$','$N_{pred}=100$','$N_{pred}=200$'},'Interpreter','latex')