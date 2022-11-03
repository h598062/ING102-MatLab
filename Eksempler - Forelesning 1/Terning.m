% Antall kast
n = 1000;
f = 1:12;
% Kaste 1 og 2 terning n ganger. 
%Resultat i t1 og t2
t1 = randi([1 6], 1, n);
t2 = randi([1 6], 1, n);
ts =  t1 + t2; 
% Telle kast
for e = ts
    f(e)= f(e) + 1;
end
% Regn sannsynlighet
p = f/n;

figure;
stem(2:12, p(2:12), 'Color', 'Red', 'LineWidth',10);
xlabel('Terningverdi');
ylabel('Sannsynlighet');
