function ex3_campos 
	fig=figure;
	fig.WindowKeyPressFcn=@KeyPress;       
	surf( peaks );
	axis vis3d off;     % Turn off axis system
	pT = [20 20 5];     % Target position
	p0 = [-500 0 0];    % Start Position
	camtarget(pT);
	campos(p0);     
	function Fly() 
		p = p0;
		while (isvalid(fig))        
			p(1) = p(1) + 10;
			campos(p);
			pause(0.1);
		end
	end
	function KeyPress(varargin)
		key = varargin{2}.Key;
		if (key == 'f')
			Fly();
		end
	end
end

