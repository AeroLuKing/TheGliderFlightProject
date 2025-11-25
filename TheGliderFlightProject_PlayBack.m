%% The Glider Flight Project
%%% AeroLuKing
%%% 18 Sep 2019
%
% Last Updated: 24 Nov 2025
%
% Utilizing the MATLAB mobile app on a smart phone, one can use the cell
% phone hardware to collect and record Acceleration, Magnetic Field,
% Orientation, Angular Velocity, and Position information. I am proposing
% using a smart phone with the MATLAB Mobile app to create a Data Aquision
% System (DAS) for the collection of flight data.


%% WorkSpace Setup
    close all
    clear
    clc


%% Knowns
    % Load Data File
        dataFile = 'Day1_Morning_DG1000_Flight4.mat';
            load(dataFile);
    % Load Video
        videoFile = 'Day1_Morning_DG1000_Flight4.MP4';
    % Gravitational constant (m/s^2)
        g = 9.8066;
    % Radians to degrees convertion (deg/rad)
        rad_deg = 180/pi;
    % Meter to foot (m/ft)
        m_ft = 3.2808;
    % m/s to knots (m*knots/s)
        mps_knot = 0.5144;
    % Data collect rate (Hz)
        Hz = 1;
        % Calcualted time step (s)
            step = 1/Hz;
    % Data and Video Correlation Offset (s)
        ts = 0;

        
%% Recorded Data      
    % Time vector (s)
        time = (0:step:(length(Position.Timestamp) - 1)) + ts;
    % Altitude (ft)
        alt = Position.altitude * m_ft;
    % Ground speed (knots)
        speed = Position.speed * 0.5144;
    % To Ensure data lengths match time vector length
        dataLength = min([length(time), length(alt), length(speed), length(Position.latitude), length(Position.longitude)]);


%% Figure and Plot Initialization using Tiled Layout
    % Figure window
        figure('Name', 'Flight Data Dashboard', 'Position', [0 0 1500 750]);
        % 2x2 tiled layout manager
            tiledChart = tiledlayout(2, 2); 
                title(tiledChart, 'GPS - Post Flight Test Data Review');

    % --- Tile 1: Velocity vs Time ---
        ax1 = nexttile(tiledChart, 1);
            h_speed = animatedline(ax1, 'Color', 'r', 'LineStyle', '-'); 
                title(ax1, 'Ground Speed vs Time');
                xlabel(ax1, 'Time Elapsed (s)');
                ylabel(ax1, 'Ground Speed (knots)');
                xlim(ax1, [time(1) time(dataLength)]);
                ylim(ax1, [min(speed) max(speed)]);
                grid(ax1, 'on');
                grid(ax1, 'minor');

    % --- Tile 2: Video Feed ---
        ax2 = nexttile(tiledChart, 2);
            axis(ax2, 'off');
            v = VideoReader(videoFile);
            firstFrame = readFrame(v);
            h2 = imshow(firstFrame, 'Parent', ax2);
            title(ax2, 'Video Feed');
            v.CurrentTime = 0;

    % --- Tile 3: Altitude vs Time ---
        ax3 = nexttile(tiledChart, 3);
            h_alt = animatedline(ax3, 'Color', 'r', 'LineStyle', '-');
                title(ax3, 'Altitude vs Time');
                xlabel(ax3, 'Time Elapsed (s)');
                ylabel(ax3, 'Altitude (ft)');
                xlim(ax3, [time(1) time(dataLength)]);
                ylim(ax3, [min(alt) max(alt)]);
                grid(ax3, 'on');
                grid(ax3, 'minor');

    % --- Tile 4: Latitude vs Longitude ---
        ax4 = nexttile(tiledChart, 4);
            delete(ax4); 
                ax4 = geoaxes('Parent', tiledChart);
                    ax4.Layout.Tile = 4;
                        h4 = geoplot(ax4, NaN, NaN, 'r-');
                            geobasemap(ax4, "topographic");
                                title(ax4, '2D Flight Path');


%% Plot data in Play Back Mode
    for tiktok = 1:dataLength
        % Update Tile 1
            addpoints(h_speed, time(tiktok), speed(tiktok));
        % Update Tile 2
            currentFrame = readFrame(v);
            set(h2, 'CData', currentFrame);
        % Update Tile 3
            addpoints(h_alt, time(tiktok), alt(tiktok));
        % Update Tile 4
            set(h4, 'LatitudeData', Position.latitude(1:tiktok), 'LongitudeData', Position.longitude(1:tiktok));
        % Force graphics update
            drawnow;
    end
