
surf(peaks)
axis vis3d off
for x = -500:15:500
	campos([x,5,10])
	% camroll(1);
	drawnow
	pause(0.02);
end