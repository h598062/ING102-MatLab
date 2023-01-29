function RotateEarth
	% Make button
	figure
	uicontrol('Style','pushbutton',...
		'String','Rotate','Position',[35,45,100,35],...
		'Callback',@f_Callback);
	% Define Earth
	[x, y, z ] = sphere(32);
	s = surf(x,y,z);

	% Rotate when button is pressed
	function f_Callback(~, ~)
		direction = [0 0 1];
		rotate(s, direction, 15)
	end
	xlim([-2 2]);
	ylim([-2 2]);
	zlim([-2 2]);
end
