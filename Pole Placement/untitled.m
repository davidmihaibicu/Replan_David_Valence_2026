clc, clear all, close all

%% 

function y = G(x, m)
    y = tanh(m * x);
    % y = 1./(1 + exp(-m*x));
end

function y = smooth_saturation(u, u_min, u_max, m)
    y = ((u_min + u_max) + ...
         u_min .* G(u_min - u, m) + ...
         u_max .* G(u - u_max, m) + ...
         u .* (G(u - u_min, m) - G(u - u_max, m)))./2;
end
%% 

t = linspace(-50, 50, 1e8);
u = t;
u_min = -24;
u_max = 24;

fig = figure;
subplot(2,2,1);
plot(t, smooth_saturation(u, u_min, u_max, 5))
title('$m  = 5$', Interpreter='latex');
grid on
subplot(2,2,2);
plot(t, smooth_saturation(u, u_min, u_max, 10))
title('$m  = 10$', Interpreter='latex');
grid on
xlim([23.8 24.2])
subplot(2,2,3);
plot(t, smooth_saturation(u, u_min, u_max, 20))
title('$m  = 20$', Interpreter='latex');
grid on
xlim([23.8 24.2])
subplot(2,2,4);
plot(t, smooth_saturation(u, u_min, u_max, 50))
title('$m  = 50$', Interpreter='latex');
grid on
xlim([23.8 24.2])
set(gcf, "Visible", "on");
cleanfigure;
matlab2tikz('Smooth Saturation.tex','width','\textwidth');

disp(max((smooth_saturation(u, u_min, u_max, 5)-24 )/ 24 *100))