% Start variabler
f = 0.5;
dt = 0:0.1:10;
 
% Støtdemper bil
a = sin(2*pi*f*dt) .* exp(-dt*2);
 
% Utslitt støtdemper bil
au = sin(2*pi*f*dt) .* exp(-dt*0.5);
plot(dt, a, dt, au, '--');
title("Støtdemper(blå) vs utslitt(rød");
xlim([0 5]);
