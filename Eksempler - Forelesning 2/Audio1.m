function simple_audio

	f = figure('Position',[100,100, 300,200]);
	t = 0;

	% Construct the components.
	uicontrol('Style','pushbutton',...
				'String','Play','Position',[35,115,100,35],...
				'Callback',@play_Callback);

	[xG,fs] = audioread('guitar.mp3');
	x = xG(1:fs*10);  % Spill i 10 sek

	recG = audioplayer(x, fs);

	set(recG,'TimerFcn',{@timerCallback}, 'TimerPeriod', 1);

	function play_Callback(source,eventdata)
		play(recG);
	end

	function timerCallback(source,eventdata)
		t = t + 1
		set(f, 'Name', sprintf("Time : %d", int64(t)) );
	end
end
%%    sound plot plot(h(3),1:length(x) , x);