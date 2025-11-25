%% The Glider Flight Project
%%% AeroLuKing
%%% 18 Sep 2019
%
% Last Updated: 26 Sep 2019
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
    % Gravitational constant (m/s^2)
        g = 9.8066;
    % Radians to degrees convertion (deg/rad)
        rad_deg = 180/pi;
    % Meter to foot (m/ft)
        m_ft = 3.2808;
    % m/s to knots (m*knots/s)
        mps_knot = 0.5144;
    % Data collect rate (Hz)
        Hz = 10;
        % Calcualted time step (s)
            step = 1/Hz;
    % Data and Video Correlation (s)
        ts = 0;
        
        
%% Recorded Data    
    % Acceleration Data
        % Acceleration time vector (s)
            tacc = (0:1:length(Acceleration_n.Timestamp) - 1) * step + ts;
        % Normal acceleration in the x-axis (g)
            Nx = Acceleration_n.X/g;
        % Normal acceleration in the y-axis (g)
            Ny = Acceleration_n.Y/g;
        % Normal acceleration in the z-axis (g)
            Nz = Acceleration_n.Z/g;
        % Plot data
            figure(1)
                subplot(3,1,1)
                    plot(tacc, Nx);
                        ylabel('Nx (g)');
                        title('Acceleration Time Histories')
                        grid on
                        grid minor
                subplot(3,1,2)
                    plot(tacc, Ny);
                        ylabel('Ny (g)');
                        grid on
                        grid minor
                subplot(3,1,3)
                    plot(tacc, Nz);
                        ylabel('Nz (g)');    
                        xlabel('Time (s)');
                        grid on
                        grid minor
        
    % Angular Velocity Data
        % Angular velocity time vector (s)
            tang = (0:1:length(AngularVelocity_n.Timestamp) - 1) * step + ts;
        % Roll rate (deg/s)
            roll_r = AngularVelocity_n.X * rad_deg;
        % Pitch rate (deg/s)
            pitch_r = -1 * AngularVelocity_n.Y * rad_deg;
        % Yaw rate (deg/s)
            yaw_r = -1 * AngularVelocity_n.Z * rad_deg;
        % Plot data
            figure(2)
                subplot(3,1,1)
                    plot(tang, pitch_r);
                        ylabel('Pitch Rate (deg/s)');
                        title('Orientation Rates Time Histories');
                        grid on
                        grid minor
                subplot(3,1,2)
                    plot(tang, roll_r);
                        ylabel('Roll Rate (deg/s)');
                        grid on
                        grid minor
                subplot(3,1,3)
                    plot(tang, yaw_r);
                        ylabel('Yaw Rate (deg/s)');
                        xlabel('Time (s)')
                        grid on
                        grid minor
                    
    % Orientation Data (deg)
        % Orientation time vector (s)
            to = (0:1:length(Orientation_n.Timestamp) - 1) * step + ts;
        % Plot data
            figure(3)
                subplot(3,1,1)
                    plot(to, -1 * Orientation_n.Z);
                        ylabel('Pitch (deg)');
                        title('Orientation Time Histories');
                        grid on
                        grid minor
                subplot(3,1,2)
                    plot(to, -1 * Orientation_n.Y);
                        ylabel('Roll (deg)');
                        grid on
                        grid minor
                subplot(3,1,3)
                    plot(to, -1 * Orientation_n.X);
                        ylabel('Azimuth (deg)');
                        xlabel('Time (s)');
                        grid on
                        grid minor
        
    % Position Data
        % Orientation time vector (s)
            tp = (0:1:length(Position_n.Timestamp) - 1) + ts;
        % Altitude (ft)
            alt_ft = Position_n.altitude * m_ft;
        % Ground speed (knots)
            knot = Position_n.speed * 0.5144;
        % Plot data
            figure(4)
                subplot(2,1,1)
                    plot(tp, alt_ft);
                        ylabel('GPS Altitude (ft)');
                        title('GPS Altitude & Velocity');
                        grid on
                        grid minor
                subplot(2,1,2)
                    plot(tp, knot);
                        ylabel('Ground Speed (knots)');
                        xlabel('time (s)');
                        grid on
                        grid minor
        % Plot data
            figure(5)
                plot3(Position_n.latitude, Position_n.longitude, alt_ft);
                        xlabel('Latitude (deg)');
                        ylabel('Longitude (deg)');
                        zlabel('GPS Altitude (ft)');
                        title('Flight Profile');
                        grid on
                        grid minor
                        
            figure(6)
                plot(Position_n.latitude, Position_n.longitude);
                        xlabel('Latitude (deg)');
                        ylabel('Longitude (deg)');
                        title('Flight Profile Map');
                        grid on
                        grid minor
                
                        
    %% Save Data
        name = {'Acceleration Time Histories.pdf','Orientation Rates Time Histories.pdf','Orientation Time Histories.pdf','GPS Altitude & Velocity Data.pdf','Flight Profile.pdf', 'Flight Profile Map.pdf'};
            saveas(figure(1),name{1});
            saveas(figure(2),name{2});
            saveas(figure(3),name{3});
            saveas(figure(4),name{4});
            saveas(figure(5),name{5});
            saveas(figure(6),name{6});
        
        name2 = {'Acceleration Time Histories.fig','Orientation Rates Time Histories.fig','Orientation Time Histories.fig','GPS Altitude & Velocity.fig','Flight Profile.fig', 'Flight Profile Map.fig'};
            saveas(figure(1),name2{1});
            saveas(figure(2),name2{2});
            saveas(figure(3),name2{3});
            saveas(figure(4),name2{4});
            saveas(figure(5),name2{5});
            saveas(figure(6),name2{6});
            