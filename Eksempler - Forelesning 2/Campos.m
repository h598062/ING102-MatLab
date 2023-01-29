function Campos
	uicontrol('Style','pushbutton',...
			'String','Around','Position',[20,145,70,25],...
			'Callback',@rot_CallbackX);
    uicontrol('Style','pushbutton',...
			'String','Vertical','Position',[20,105,70,25],...
			'Callback',@rot_CallbackZ);
    uicontrol('Style','pushbutton',...
			'String','Fly','Position',[20,65,70,25],...
			'Callback',@rot_CallbackFly);

    s = surf( peaks() );
    s.FaceColor = 'texturemap';
    s.CData = imread('forrest.jpg');

    axis vis3d off;      % Turn off axis system

    p0 = [ 25 38 8];     % Top op peak
    p(1) = 0; p(2) = -250; p(3) = 2; % Position
    camtarget(p0);
    campos(p);

    function rot_CallbackX(obj, ev) %
		p(1)  =  mod(p(1)+10,200); % Walk x
		campos(p);
    end
    function rot_CallbackZ(obj, ev) % View up/down
		p(3)  =  mod(p(3)+10,100); % Move up
		campos(p);
    end

    function rot_CallbackFly(obj, ev) % Fly to the top
		for d=0.01:0.01:0.99
			px = (p0 - p)*d + p;
			campos(px);
			drawnow;
			pause(0.05);
		end
    end
end

