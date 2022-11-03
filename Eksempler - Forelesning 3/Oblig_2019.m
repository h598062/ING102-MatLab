function Oblig_2019
    % SIMPLE_GUI2 Select a data set from the pop-up menu and display
    clear all;
    f = figure('Position',[200,200,450,400]);

    h = []; 
    
 

    % Construct the components.
    h(end+1) = uicontrol('Style','popupmenu',...
               'String',{'Peaks','Membrane','Sinc', 'Cylinder'},...
               'Position',[335,20,100,25],...
               'Callback',@popup_menu_Callback);      

    ax=axes('Units','pixels','Position',[50,30,255,255]); 
    h(end+1) = ax;
  %  align(h,'Center','None');
  
    h(end+1)    = uicontrol('Style','pushbutton',...
                 'String','Rot','Position',[350,245,70,25],...
                 'Callback',@rot_Callback);
  
    h(end+1)    = uicontrol('Style','pushbutton',...
                 'String','Top','Position',[350,215,70,25],...
                 'Callback',@top_Callback);
             
    h(end+1)    = uicontrol('Style','pushbutton',...
             'String','Side YZ','Position',[350,185,70,25],...
             'Callback',@sideYZ_Callback);
         
    h(end+1)    = uicontrol('Style','pushbutton',...
         'String','Side XZ','Position',[350,155,70,25],...
         'Callback',@sideXZ_Callback);
     
     
    h(end+1)    = uicontrol('Style','pushbutton',...
             'String','Start','Position',[350,100,70,25],...
             'Callback',@rotStart_Callback);

    h(end+1)    = uicontrol('Style','pushbutton',...
                 'String','Stop','Position',[350,70,70,25],...
                 'Callback',@rotStop_Callback);       

    % Assure resize automatically.
    f.Units = 'normalized';
    set(h, 'Units', 'normalized');
    set(h, 'FontSize', 12);

    % Generate the data to plot.
    peaks_data = peaks(35);
    membrane_data = membrane;
    [x,y] = meshgrid(-8:.5:8);
    r = sqrt(x.^2+y.^2) + eps;
    sinc_data = sin(r)./r;

    % Create a plot in the axes.
    current_data = peaks_data;
    
     s=surf(current_data);      
     current_data = cylinder(100);
     
     tmr = timer('ExecutionMode', 'FixedRate', ...
    'Period', 0.2, ...
    'TimerFcn', {@timerCallback});

     tmr.TasksToExecute = 100;
     ax.ActivePositionProperty = 'outerposition';

   %  Pop-up menu callback. Read the pop-up menu Value property to
   function popup_menu_Callback(source,eventdata) 
      % Determine the selected data set.
      str = get(source, 'String');
      val = get(source,'Value');
      % Set current data to the selected data set.
      switch str{val};
      case 'Peaks' % User selects Peaks.
         current_data = peaks_data;
      case 'Membrane' 
         current_data = membrane_data;
      case 'Sinc' 
         current_data = sinc_data;    
      case 'Cylinder' 
    
         [x,y,z] = cylinder(10);
         s=surf(x,y,z);
         return;
      end    
      s=surf(current_data);
   end

    function rot_Callback(source,eventdata) 
        view([1 1 1]);
    end

    function top_Callback(source,eventdata) 
        view([90,90]);
    end

    function sideYZ_Callback(source,eventdata) 
        view([1 0 0]);
    end

    function sideXZ_Callback(source,eventdata) 
        view([0 1 0]);
    end

    % Timer stuff
    function rotStart_Callback(source,eventdata) 
        start(tmr);
    end

    function rotStop_Callback(source,eventdata) 
        stop(tmr);
    end

    function timerCallback(hObj, eventdata)
      % direction = [0 0 1];
     [az, el] = view;
     view(az+1, el);
    end
end