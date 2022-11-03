function simple_audio

    f = figure('Position',[360,400,450,285]);
    h = [];
    t = 0;
    dt = 0.1;

    % Construct the components.
    h(1) = uicontrol('Style','pushbutton',...
                 'String','Play','Position',[35,185,100,35],...
                 'Callback',@play_Callback);
             
    h(2) = uicontrol('Style','pushbutton',...
                 'String','Stop','Position',[35,105,100,35],...
                 'Callback',@stop_Callback);          

    h(3) = axes('Units','pixels','Position',[250,100,155,155]);
         
    set(h, 'Units', 'normalized');
    set(h, 'FontSize', 12);  
 
    [xG,fs] = audioread('guitar.mp3');
    s = 12;
    
    x = xG(1:fs*s);
    
    recG = audioplayer(x, fs*1.2);  

    set(recG,'TimerFcn',{@timerCallback}, 'TimerPeriod', dt);
    
    function play_Callback(source,eventdata) 
        t = 0;
        play(recG, fs);
    end

    function stop_Callback(source,eventdata) 
        stop(recG);
    end

    function timerCallback(source,eventdata) 
     
        i = int32(t*fs+1);
        xs = x(i : i + int32(fs/10));
        t = t + dt;
      
        % frequency plot 1-800 hz
        f = abs( fft(xs) );
        plot(h(3),1:800 , f(1:800));
        
        text = sprintf("Time : %d", int64(t));
        title(text);
    end
end

