% Antall kast
n = 100;
f = 1:6;

% ts inneholder n terningkast
ts = randi([1 6], 1, n);  
% Telle kast
for e = ts
    f(e)= f(e) + 1;
end
% Beregner sannsynligheten..
p = f / n;

figure;
stem(1:6, p, 'Color', 'Red', 'LineWidth', 5);
xlabel('Terningverdi');
ylabel('Sannsynlighet');
