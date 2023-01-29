%% A very simple flight
fig = figure;
axis vis3d off;
hold on;
fig.Children.Visible = 'off';
fig.Children.Clipping = 'off';
fig.Children.Projection = 'perspective';
%% Create islands
[x,y,z]=peaks;
s=surf(x*20,y*20,z*6);
s.FaceColor = 'texturemap';
s.CData = imread('forrest.jpg');
%% Create a Sea
[x,y] = meshgrid(-5000:500:5000);
z = x .* 0; 
h=surf(x,y,z,'FaceColor','texturemap','CData',imread('sea.jpg'));
%% Fly  
vel = 5;
pos = [-1500 10 8];
forwardVec = [1 0 0];
while (isvalid(fig))
	camtarget(pos+[30 0 0]); % Camtaret is 10 units straight forward
	campos(pos);
	pos = (pos + forwardVec * vel); % Move forward
	
	if (pos > 0)
		pos = [-1500 10 8];  % Reset
	end
	
	pause(0.05);
end


