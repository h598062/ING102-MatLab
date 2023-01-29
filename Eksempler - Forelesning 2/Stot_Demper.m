% Start variabler
f = 0.5;
dt = 0:0.1:10;

% St�tdemper bil
a = sin(2*pi*f*dt) .* exp(-dt*2);

% Utslitt st�tdemper bil
au = sin(2*pi*f*dt) .* exp(-dt*0.5);
plot(dt, a, dt, au, '--');
title("St�tdemper(bl�) vs utslitt(r�d");
xlim([0 5]);
