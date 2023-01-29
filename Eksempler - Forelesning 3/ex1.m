function ex1

	fig = figure('Position',[300,300,450,285]);        
	% Generate the data to plot.
	[x,y,z] = peaks;
	% Plot the data
	s=surf(x,y,z);   
	
	set(fig,'WindowKeyPressFcn',@KeyPress); 

	d = 6;
	xlim([-d d]);
	ylim([-d d]);    
	zlim([-10 10]);
	function KeyPress( varargin )
	key = varargin{2}.Key;
	if (key == 'q')
		rotate(s, [0 0 1], 5);
	elseif (key == 'e')
		rotate(s, [0 0 1], -5);
	end
	end 
end















%     fig = figure('Position',[300,300,450,285]);        
%     % Generate the data to plot.
%     [x,y,z] = peaks;
%     % Plot the data
%     s=surf(x,y,z);
%     d = 5;
%     xlim([-d d]);
%     ylim([-d d]);  
%     
%     set(fig,'WindowKeyPressFcn',@KeyPress); 
%     function KeyPress( varargin )
%      %key = varargin{2}.Key;
%      rotate(s, [0 0 1], 5);
%     end  
