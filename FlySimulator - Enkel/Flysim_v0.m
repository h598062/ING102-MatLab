%% A very simple flight. Only allow to change speed.
function VerySimpleFlight
frames = 10; %% Frames per sec
surfFjell = 40; %% Surfaces on mountain
fig = figure;
axis vis3d off;
hold on;
fig.Children.Visible = 'off';
fig.Children.Clipping = 'off';
fig.Children.Projection = 'perspective';
set(fig,'WindowKeyPressFcn',@KeyPress); 
txt = uicontrol(fig,'Style','text','Position',[3,30,250,60]);
txt.FontSize = 14;
%% Create island
[x,y,z]=peaks(surfFjell);
s=surf(x*20,y*20,z*6-15);
s.FaceColor = 'texturemap';
s.LineStyle = 'none';
s.CData = imread('Forrest.jpg');
%% Create a Sea
[x,y] = meshgrid(-5000:1000:5000);
z = x .* 0; 
h=surf(x,y,z,'FaceColor','texturemap','CData',imread('sea.jpg'));
%% Fly  
velocity = 100;
pos = [-1500 150 30];
forwardVec = [1 0 0]; % Dictection of flying...
while (isvalid(fig))
    camtarget( [0 0 20]); % pos+forwardVec = pilot view
    campos(pos);
    pos = (pos + forwardVec * velocity/frames); % Move forward 
    txt.String = sprintf('Speed: %s (F=faster/S=Slower) ', int2str(velocity)  );
    if (abs(pos(1)) > 1500)
        forwardVec(1) = - forwardVec(1); % Turn around
    end
    pause(1/frames);  
end
    function KeyPress(varargin)
         key = varargin{2}.Key;
         if (key=='f')
             velocity = min(velocity * 1.2, 1000);
         elseif (key=='s')
             velocity = max(50, velocity / 1.2);
         end
    end
end
