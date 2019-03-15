%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2012-2017 All Rights Reserved, 
% http://www.evocortex.com      
% Evocortex GmbH                                                         
% Emilienstr. 1                                                             
% 90489 Nuremberg                                                        
% Germany    
% info@evocortex.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Christian Pfitzner, Evocortex GmbH
% Date:   2017-06-05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: 
% This file is the minimal example to access the 
% EvoIRMatlabInterface. The output of the palette image
% is enhanced with some control possibilities, e.g. 
% switching the palette's color, range and to trigger 
% the shutter flag. % This example is tested with 
% Windows and Linux. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; 

% initialize the interface as a global variable
global IRInterface;
IRInterface = EvoIRMatlabInterface; 

% initialize the viewer
IRViewer = EvoIRViewer; 
global viewer_is_running; 

% check for connection error
if ~IRInterface.connect()                   
    return
end

% set temp range (uncomment next line for usage)
%IRInterface.set_temperature_range(-20, 100);

% main loop
while(viewer_is_running) 

    % grab image data
    RGB = IRInterface.get_palette();        % grab palette image
    THM = IRInterface.get_thermal();        % grab thermal image
    
    % process data here...
    
    % draw RGB image
    imagesc(RGB);                           
    drawnow();   
    
end

IRInterface.terminate();                    % disconnect from camera

close all; 
