function SG
    f = figure('Position',[100,300,250,250]);
   
    % Construct the components.
    % Assiget to a variable (h1) for later use
    h1 = uicontrol('Style','pushbutton',...
                 'String','Count','Position',[35,85,200,135],...
                 'Callback',@f_Callback);  
    h1.FontSize = 30;
    
    n = 0;
    % This function is linked to control h1
    function f_Callback(~,~) 
        n = n + 1;
        h1.String = int2str(n);
        % Alt set(h1, 'String', int2str(n));
    end          
end