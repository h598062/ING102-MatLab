t = 0:0.1:2*pi;
f1 = sin(t);
f2 = cos(t);

fig1 = figure;


plot(t, f1);

hold on;

plot(t, f2);
plot(t, f1 .* f2);
title("sin");
% fig2 = figure;
% plot(t, f2);
% title("cos");
% 
% figure(fig1);
% hold on;
% title("cos+sin");
% plot(t, f1+f2);




