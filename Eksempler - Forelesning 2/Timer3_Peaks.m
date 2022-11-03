function Timer3_Peaks
    [x, y, z ] = peaks;
    figure;   
    uicontrol('Style','pushbutton',...
                 'String','Start','Position',[35,35,100,35],...
                 'Callback',@start_Callback);            
    uicontrol('Style','pushbutton',...
                 'String','Stopp','Position',[335,35,100,35],...
                 'Callback',@stopp_Callback);  
    s = surf(x,y,z);

    tmr = timer('ExecutionMode', 'FixedRate', ...
        'Period', 0.2, ...
        'TimerFcn', {@timerCallback});
    
    [x,fs] = audioread('guitar.wav');
    pl = audioplayer(x, fs);  
    
    function timerCallback(~, ~)
       direction = [0 0 1];
       rotate(s, direction, 4)
    end
    function start_Callback(~, ~)
      start(tmr);
      play(pl);
    end
    function stopp_Callback(~, ~)
      stop(tmr);
      stop(pl);
    end
    xlim([-5 5]);   
    ylim([-5 5]);
end
