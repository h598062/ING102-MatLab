function Jorden

	[x,y,z] = sphere(40);
	figure;
	s=surf(x,y,z);
	tmr = timer('ExecutionMode', 'FixedRate', ...
		'Period', 0.1, ...
		'TimerFcn', {@timerCallback});

	start(tmr);

	function timerCallback(~, ~)
		direction = [0 0 1];
		rotate(s, direction, 1)
	end
end
