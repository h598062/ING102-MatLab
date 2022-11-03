function mytemps
    f = figure;   
    c = uicontrol(f,'Style','popupmenu','FontSize', 18);
    c.Position = [20 75 150 20];
    c.String = {'Sinus', 'Cosinus', 'Log'};
    c.Callback = @selection;
    
    ax = axes(f);
    ax.Units = 'pixels';
    ax.Position = [75 125 350 200];
 
    t = 0:0.1:2*pi;
    p = plot(ax, t, sin(t), 'LineWidth', 5); 
    
    function selection(~,~)
        y = 0;
        switch (c.Value)
            case 1 
                y = sin(t);
            case 2 
                y = cos(t);
            case 3 
                y = log(t);
        end     
        p=plot(ax, t, y, 'LineWidth', 5); 
    end

end