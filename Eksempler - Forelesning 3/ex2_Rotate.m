function ex2_Rotate
	fig=figure;
	uicontrol('Style','pushbutton',...
			'String','Rotate','Position',[50,50,100,30],...
			'Callback',@rot_Callback);  
	set(fig,'WindowKeyPressFcn',@KeyPress);
	% Generate the data to plot.
	[x,y] = meshgrid(-4:0.2:4);
	z = 5 ./ (abs(x)+abs(y)+1); % Forces Z same size as X
	% Create a plot in the axes.
	s=surf(x,y,z);  
	xlim([-5 5]);
	ylim([-5 5]);
	zlim([-5 5]);
	function rot_Callback(~,~)
		rotate(s, [0 0 1], 5);
	end
	function KeyPress( varargin )
		key = varargin{2}.Key;
		if (key == 'u')
			s.ZData = s.ZData +1;
		elseif (key == 'd')
			s.ZData = s.ZData -1;
		end
	end
end