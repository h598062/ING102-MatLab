t = 0:0.1:2*pi;
f1 = sin(t);
f2 = cos(t);
f3 = f1 .* f2;

figure;
hold on;

plot(t, f1);
plot(t, f2);
plot(t, f3,'LineWidth', 4);
legend({'y = sin(x)','y = cos(x)', 'z= sin*cos'},'Location','southwest')
title("sin og cos");
