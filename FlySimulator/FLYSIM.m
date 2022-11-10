% Taster:  AD: Venstre/Høyre  QE rulle
% W S Opp/Ned  P/M : Øk/Senk hastighet
% V - Endre Observasjonspunkt
% B - Bytte overflate og terreng textures
function FLYSIM
    %% Intro stuff
    close all

    %% Init Stuff - may be changed
    FRAMES=  60;                % 2 ->
    SURFACES = 50;              % 4 ->
    firstPerson = true;         % Do we start in 1st person view, or not?
    vel = 600;                  % Velocity
    kwt = 4000;                 % Battery Level
    posStart =[-9900,0,2000];   % Start position
    forwardVec = [1 0 0]';      % Initial direction of the plane
    colorP = '#b8bf4f';         % Color of plane
    scaleP = 5.0;               % Scale plane

    dbg = true;                 % boolean for å vise debug info

    textureSea = imread('sea.jpg');
    textureForest = imread('forest.png');
    textureGrass = imread('grass.jpg');
    textureMountain = imread('Mountain.png');

    textureDesert = imread('desert.jpg');
    textureSand = imread('sand.jpg');
    textureRedSand = imread('sand-red.jpg');
    textureCanyon = imread('canyon.jpg');

    textureIce = imread('ice.jpg');
    textureIceMountain = imread('ice-mountain.jpg');
    textureSnow = imread('snow.jpg');
    textureSnowGrass = imread('Snow_grass.jpg');

    textureSauce = imread('sauce.jpg');
    texturePasta = imread('pasta2.png');
    textureMeatballs = imread('meatballs.jpg');
    textureCheese = imread('cheese.jpg');

    n = 1;
    currentSurface = "Vann og gressland";

    %% Other variables
    matRot   = eye(3);
    vert = 0;               % Vertices of the airplane
    p1 = [];                % The plane surfaces
    txtKwh = 0;             % Control kwh
    zCounter = 0;           % debug text 5 kwh per 100 unit
    vVinkel = 0;
    txt1 = 0;               % Control speed
    txt2 = 0;               % Control height
    txtalarm = 0;           % alarm
    byttTxt = 0;            % current surface textureset
    pos = posStart;
    zCount = 0;
    prevZ = pos(3);
    rot = matRot;
    lander = false;
    sufFlat = [];           % Sea
    s1 = [];                % Mountain
    s2 = [];                % Flat surface
    s3 = [];                % small hills
    pe = 0;                 % Engine Sound
    fig = figure;
    hold on; % be strong
    fig.Position = [100 100 1400 900]; % Size of program

    % Disable axis viewing, don't allow axes to clip the plane
    fig.Children.Visible = 'off';
    fig.Children.Clipping = 'off';
    fig.Children.Projection = 'perspective';

    InitControls();
    InitPlane();
    AddSky();
    AddSurface();
    AddIslands();

    %% Set keyboard callbacks and flags for movement.
    set(fig,'WindowKeyPressFcn',@KeyPress,'WindowKeyReleaseFcn', @KeyRelease);
    hold off
    axis([-10000 10000 -10000 10000 -10000 10000])
	tic
    told = 0;

    %% Read the enginee file and start the Engine
    EngineSound();

    %% Enter the main loop
    MainLoop();

    %% Enter the Mail Loop of Flying
    function MainLoop
    while(ishandle(fig))
        tnew = toc;
        rot = rot * matRot;
        %Update plane's center position.
        z = pos(3);
        pos = vel*(rot*forwardVec*(tnew-told))' + pos;
        %If empty battery - let the plane fall
        %If too low speed - let the plane fall
        if (kwt < 0 || (vel < 100 && ~lander)) % No more kwh or Stalling
            pos(3) = z - 100;
        end
        %Update the plane's vertice new position and rotation
        p1.Vertices = (rot*vert')' + repmat(pos,[size(vert,1),1]);
        % Check if plane crashes into grounds
        lander = TestLanding;
        if TestCrash && ~lander
            return
        end
        if lander
            if vel < 10
                vel = 0;
            else
                vel=vel*0.8;
            end
        end
        UpdateCamera();
        told = tnew;
        pause(1/FRAMES);

        UpdateFuel();
        ShowInfo();
        EngineSoundLoop();
    end
    end
    %% Checks if plane plane is colliding with terrain
    function [fTC]= TestCrash()
        z = pos(3)-20;
        if  z < 0  || z < GetZ(s1, pos) || z < GetZ(s2,pos) || z < GetZ(s3,pos)
             Crash();
             fTC= true;
        else
             fTC=false;
        end
    end
    %% Checks if plane is landing 
    function [fTL] =  TestLanding() % funker ikke enno
        tmpVinkel = rotm2eul(matRot);
        tmpVinkel = tmpVinkel(2);
        if ((tmpVinkel <= 15 && tmpVinkel >= 0) && (vel <= 200))
            fTL=true;
        else
            fTL=false;
        end
    end

    %% Add some Islands
    function AddIslands
        %% Define tall island
        [x,y,z] = peaks(SURFACES);
        x = x * 3000+30000;
        y = y * 6000-4000;
        z = z * 1200 - 1300;
        s1=surf(x,y,z, ...
               'LineStyle','none','AmbientStrength',0.7);
        s1.FaceColor = 'texturemap';
        s1.CData = textureMountain;

        %% Define flat island
        [x2,y2,z2] = peaks(SURFACES);
        x2 = x2 * 4356;
        y2 = y2 * 8722;
        z2 = z2 * 435; %% z e høyde?
        s3=surf(x2,y2,z2, ...
               'LineStyle','none','AmbientStrength',0.7 );
        s3.FaceColor = 'texturemap';
        s3.CData = textureGrass;

        %% Define a mostly flat island
        x = -2:2/sqrt(SURFACES):2;
        y = -4:2/sqrt(SURFACES):4;
        [X,Y] = meshgrid(x,y);
        Z = X.*(exp(-X.^2-Y.^2)+exp(-X.^2-(Y-2).^2));
        X = X * 4000;
        Y = Y * 4000;
        Z = Z * 5000;
        s2 = surf(X,Y,Z, 'LineStyle','none', ...
                     'SpecularStrength',0, ...
                     'AmbientStrength',0.7,'SpecularColorReflectance',1);
        s2.FaceColor = 'texturemap';
        s2.CData = textureForest;
    end
    %% Update Camera positions and rotation
    function UpdateCamera()
        if firstPerson %First person view -- follow the plane from slightly behind.
            camupvec = rot*[0 0 1]';
            camup(camupvec);
            x = 1000;
            campos(pos' - x*rot*[1 0 -0.15]');
            camtarget(pos' + 100*rot*[1 0 0]');
        else %Follow the plane from a fixed angle
            campos(pos + [-1500,500,500]);
            camtarget(pos);
        end
    end
    %% Check kwh left
    function UpdateFuel
        if (kwt < 0)
            EngineStop();
        else
            kwt = kwt - 0.003 - vel*vel/10000000;
        end
        tmpZ = pos(3);
        if (tmpZ > prevZ)
            tmp = tmpZ - prevZ;
            zCount = zCount + tmp;
        end
        if (zCount >= 100)
            kwt = kwt - 5 * floor(zCount / 100);
            zCount = mod(zCount, 100);
        end
        prevZ = tmpZ;
    end
    %% Show Flight Info
    function ShowInfo()
        if (isvalid(fig)==false)
            return;
        end

        % debug info
        if (dbg)
            zCounter.String = "zCount : " + int2str(zCount);
            vVinkel.String = "vinkel: " + int2str(rot(2));
        end

        % bytte texture panel
        byttTxt.String = currentSurface;

        % instrument panel
        txtKwh.String = "KWh : " + int2str(kwt);
        if (pos(3) < 200)
            txtalarm.String = "ALARM";
        else
            txtalarm.String = "";
        end
        txt2.String = sprintf('Speed: %s  Height: %s', ...
            int2str(vel), int2str(pos(3)));
        x = int2str(pos(1)); y = int2str(pos(2));
        txt1.String = sprintf('Coord: (X: %s, Y: %s)', x, y);
    end
    %% Add Control panels
    function InitControls
        % panel med bytte texture knapp
        bytt = uipanel('Title',"Bytt Textures",'Position',[.01 .01 .2 .15]);
        byttBtn = uicontrol(bytt, 'Style','pushbutton',...
                 'String','Bytt','Position',[10, 80, 100, 30],...
                 'Callback',@bytt_callback);
        set(byttBtn, 'FontSize', 14);
        byttTxt = uicontrol(bytt,'Style','text','Position',[10, 10, 150, 60]);
        set(byttTxt, 'FontSize', 14);

        % debug for utvikling
        if (dbg)
            dbgPanel = uipanel('Title', "DEBUG",'Position',[.01 .89 .15 .1]);
            zCounter = uicontrol(dbgPanel,'Style','text','Position',[.005 .005 100 30]);
            set(zCounter, 'FontSize', 14);
            vVinkel = uicontrol(dbgPanel,'Style','text','Position',[.005 (2 * .005 + 30) 100 30]);
        end

        % instrument panel
        h = [];
        inst = uipanel('Title','Instruments','Position',[.3 .01 .4 .15]);
        h(end+1)  = inst;

        fuel = uipanel('Title','Battery','Position',[.75 .01 .2 .15]);
        h(end+1)  = fuel;

        txtKwh = uicontrol(fuel,'Style','text','Position',[3,3,140,30]);
        h(end+1)  = txtKwh;
        txtalarm = uicontrol(fuel,'Style','text','Position',[100,60,140,30]);
        h(end+1) = txtalarm;
        txt1 = uicontrol(inst,'Style','text','Position',[3,3,250,30]);
        h(end+1)  = txt1;
        txt2 = uicontrol(inst,'Style','text','Position',[3,30,250,30]);
        h(end+1)  = txt2;

        set(h, 'FontSize', 14);
        set(h, 'BackgroundColor', 'green');
    end
    %% Bytt knapp callback
    function bytt_callback(~,~)
        n = n + 1;
        if n == 1
            sufFlat.CData = textureSea;
            s1.CData = textureIceMountain;
            s2.CData = textureSnow;
            s3.CData = textureSnowGrass;
            currentSurface = "Vann og gressland";
        elseif n == 2
            sufFlat.CData = textureIce;
            s1.CData = textureIceMountain;
            s2.CData = textureSnow;
            s3.CData = textureSnowGrass;
            currentSurface = "Is og snø";
        elseif n == 3
            sufFlat.CData = textureDesert;
            s1.CData = textureCanyon;
            s2.CData = textureRedSand;
            s3.CData = textureSand;
            currentSurface = "Ørken og fjell";
        elseif n == 4
            sufFlat.CData = textureSauce;
            s1.CData = textureMeatballs;
            s2.CData = textureCheese;
            s3.CData = texturePasta;
            currentSurface = "Middag";
            n = 0;
        end
    end
    %% Initialize the plane
    function InitPlane()
        fv = stlread('T-85_X-Wing_Open_v1.1.stl');
        vert = 0;
        delete(findobj('type', 'patch'));
        p1 = patch(fv,'FaceColor',       colorP, ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.35);

        rotate(p1, [0 0 1 ], 90);
        p1.Vertices = p1.Vertices .* scaleP;
        vert = p1.Vertices;
    end
    %% Add the sky as a giant sphere (fly inside...)
    function AddSky
        [skyX,skyY,skyZ] = sphere(SURFACES);
        sky = surf(500000*skyX, 500000*skyY, 500000*skyZ, 'LineStyle','none');
        sky.FaceColor = 'cyan';
        light('Position',[-5000 0 0],'Style','local')
    end
    %% add flat ground (Ocean) going off to (basically) infinity.
    function AddSurface
        k = 100000 / SURFACES;
        [x,y] = meshgrid(-500000:k:500000);
        z = x .* 0;
        sufFlat = surf(x,y,z);
        sufFlat.FaceColor = 'texturemap';
        sufFlat.CData = textureSea;
        sufFlat.AlphaData = 0.1;
        camlight('headlight');
        camva(40); %view angle
    end
    %% Trap press Key
    function KeyPress(varargin)
        key = varargin{2}.Key;
         if (key=='v')
             firstPerson = ~firstPerson;
         elseif (key=='p') % Increase speed
             if (vel >= 10000)
                 vel = 10000;
             else
                 vel = max(5, vel * 1.05);
             end
         elseif (key=='m') % Reduce speed
             vel = vel * 0.95;
         elseif (key=='a') % Yaw left
             matRot = MR(0.05,0,0);
         elseif (key=='d') % Yaw Right
             matRot = MR(-0.05,0,0);
         elseif (key=='w') % Pitch down
             matRot = MR(0, 0.05,0);
         elseif (key=='s') % Pitch up
             matRot = MR(0, -0.05,0);
         elseif (key=='e') % Roll right
             matRot = MR(0, 0, 0.05);
         elseif (key=='q') % Roll left
             matRot = MR(0, 0, -0.05);
         elseif (key=='b') % Change terrain texture
             bytt_callback();
         end
    end
    %% Trap Key Release
    function KeyRelease(varargin)
         matRot = eye(3); % Unit Matrix
    end
    %% Rotation Matrix
    function M = MR(yaw,pitch,roll)
        % Rotate a graphics object along Z-Y-X axes in the earth frane
        m1 = [cos(yaw) -sin(yaw) 0; sin(yaw) cos(yaw) 0; 0 0 1];
        m2 = [cos(pitch) 0 sin(pitch); 0 1 0; -sin(pitch) 0 cos(pitch)];
        m3 = [1 0 0; 0 cos(roll) -sin(roll); 0 sin(roll) cos(roll)];
        M = m3*m2*m1;
    end
    %% Make Engine Sound
    function EngineSound()
        % [es,fs] = audioread('engine.wav');
        [es,fs] = audioread("Nyoom.mp3");
        es2 = es/50;
        pe = audioplayer(es2,fs);
        if isplaying(pe)
            stop(pe);
        end
        play(pe);
    end

    %% Engine sound loop
    function EngineSoundLoop()
        if (~isplaying(pe))
            play(pe);
        end
    end
    %% Engine Stop Stound
    function EngineStop()
        stop(pe);
    end
    %% Crash Sound
    function Crash()
        % [xs,f] = audioread('crash_sound.wav');
        [xs,f] = audioread('windows-shutdown.opus');
        xs2 = xs/150;
        pe = audioplayer(xs2,f);
        play(pe);
        p1.FaceColor = "Black";
    end
    %% Get the Z of the surface given a position
    function z0 = GetZ(s, pos)
        z0 = interp2(s.XData,s.YData,s.ZData,pos(1),pos(2) );
    end
end