function SG
	f = figure('Position',[100,300,250,250]);

	% Construct the components.
	h1 = uicontrol('Style','pushbutton',...
				'String','Count','Position',[35,185,100,35],...
				'Callback',@f_Callback);

	t = timer;
	t.ExecutionMode = 'FixedRate';
	t.Period = 1;
	t.TasksToExecute = 25;
	t.TimerFcn = @t_Callback;

	% This function is linked to control h1
	function f_Callback(~,~)
		start(t);
	end

	function t_Callback(source,eventdata)
		h1.String = t.TasksExecuted;
	end
end