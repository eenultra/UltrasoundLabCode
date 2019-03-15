%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2012-2017 All Rights Reserved, 
% http://www.evocortex.com      
% Evocortex GmbH                                                         
% Emilienstr. 1                                                             
% 90489 Nuremberg                                                        
% Germany    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Christian Pfitzner, Evocortex Gmbh
% Date:   2017-06-05
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: 
% The EvoIRMatlabInterface is an interface to access the 
% libirimager library via Matlab. This implementation is
% a minimal example to get the functionality of the 
% library, which is programmed in c. 
% Please see the documentation of the libirimager for 
% further information about the here applied functions. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



classdef EvoIRMatlabInterface
    properties (SetAccess = private)
        libName
        libPath
        headerPath
        configPath
	isWindows
    end
    
    methods
        %% Default constrcutor with initialization
        function obj = EvoIRMatlabInterface()
            % set variables as global accessor
            global g_evo_IR_palette_width;
            global g_evo_IR_palette_height;
            global g_evo_IR_thm_width;
            global g_evo_IR_thm_height;
            
            % initialize
            g_evo_IR_palette_width  = 0;
            g_evo_IR_palette_height = 0;
            g_evo_IR_thm_width      = 0;
            g_evo_IR_thm_height     = 0;
            
            % check for operating system
            os = computer; 
            if  os == 'GLNXA64'                                             % linux
                obj.libName      = 'libirdirectsdk';
                obj.libPath      = '/usr/lib/libirdirectsdk.so';
                obj.headerPath   = '/usr/include/libirimager/direct_binding.h';
                obj.configPath   = '/usr/share/doc/libirimager/examples/config/generic.xml';
                obj.isWindows    = false;
            elseif os == 'PCWIN64'                                         % windows
                obj.libName      = 'libirimager';
                obj.libPath      = 'libirimager';
                obj.headerPath   = 'direct_binding.h';
                obj.configPath   = 'generic.xml';
                %obj.configPath   ='C:\Users\eenjrm\AppData\Roaming\Imager\Cali';
                obj.isWindows    = true;
            else
                disp('unsupported operating system');
            end
            
            % check if library is already loaded
            
            if libisloaded(obj.libName)
                calllib(obj.libName, 'evo_irimager_terminate');
                unloadlibrary(obj.libName);
            end
            
            if not(libisloaded(obj.libName))
                [~,warnings] = loadlibrary(obj.libPath, obj.headerPath);
                disp(warnings)
            end
        end
        
        %% Function to connect to the camera via ip and port
        function isConnected =  connect(obj)
            % set variables as global accessor
            global g_evo_IR_palette_width;
            global g_evo_IR_palette_height;
            global g_evo_IR_thm_width;
            global g_evo_IR_thm_height;
            global g_palettePtr;
            global g_thmPtr;
            
            % terminate first for reconnect
            obj.terminate();
            
            % message to user about connecting
            disp('***************************');
            disp('Connecting to device');
            disp('***************************');
            
            if 0 == calllib(obj.libName, 'evo_irimager_usb_init', obj.configPath, '', '')
                % connected
                disp('***************************');
                disp('Connected to device');
                disp('***************************');
                
                %% initialize data to obtain palette image
                width  = libpointer('int32Ptr', 0);   % pointer for width
                height = libpointer('int32Ptr', 0);   % pointer for height
                
                calllib(obj.libName, ...
                        'evo_irimager_get_palette_image_size', ...
                        width, height);
                
                % check for error
                if width.value <= 0
                    isConnected = false;
                    disp('error at connecting...')
                    clear width;
                    clear height;
                    return
                end
                
                % save size of thm data
                g_evo_IR_palette_width  = width.Value;
                g_evo_IR_palette_height = height.Value;
                palette_size            = g_evo_IR_palette_height* ... 
                                          g_evo_IR_palette_width;
                                  
                % initialize pointer for palette
                g_palettePtr        = libpointer('uint8Ptr', ...
                                      zeros(palette_size*3, 1));

                %% initialized data to obtain thm image
                
                calllib(obj.libName, ...
                    'evo_irimager_get_thermal_image_size', ...
                    width, height);
                
                % save size of palette data
                g_evo_IR_thm_width  = width.Value;
                g_evo_IR_thm_height = height.Value;
                
                thm_size     = g_evo_IR_thm_height* ...
                               g_evo_IR_thm_width;
                
                % initialized pointer for thm data
                g_thmPtr     = libpointer('uint16Ptr', zeros(thm_size, 1));
                
                
                isConnected = true;
            else
                % display error message
                disp('error at connecting...')
                
                isConnected = false;
            end
            
            % clear memory
            clear width;
            clear height;
            clear fatal;
        end
        
        %% Function to the the thm thermal data 
        function THM =  get_thermal(obj) % evo_irimager_get_thermal_image_byref
        % set variables as global accessor
            global g_evo_IR_thm_width;
            global g_evo_IR_thm_height;
            global g_thmPtr;
            
            % get thermal image
            returnvalue = calllib(obj.libName, ...
                'evo_irimager_get_thermal_image', ...
                g_evo_IR_thm_width,            ...
                g_evo_IR_thm_height,           ...
                g_thmPtr );
            
            if returnvalue ~= 0
                disp('cannot get thermal image...')
                return
            end
            
            THM = g_thmPtr.value;
           
            % generate a matrix from the vector
            THM = reshape(THM, [g_evo_IR_thm_width, ...
                               g_evo_IR_thm_height]);
                           
            THM = THM';
        end
        
        %% Function to get the color palette image
        function RGB =  get_palette(obj) % evo_irimager_get_palette_image_byref
       % set variables as global accessor
            global g_evo_IR_palette_width;
            global g_evo_IR_palette_height;
            global g_palettePtr;
            
            
            % get palette image (RGB)
            returnvalue = calllib(obj.libName, ...
                'evo_irimager_get_palette_image', ...
                g_evo_IR_palette_width,                 ...
                g_evo_IR_palette_height,                ...
                g_palettePtr);
            
            if returnvalue ~= 0
                disp('cannot get palette image...')
                return
            end
            
            % divide the received vector in three channels
            R =  g_palettePtr.Value(1 : 3 : end);
            G =  g_palettePtr.Value(2 : 3 : end);
            B =  g_palettePtr.Value(3 : 3 : end);
            
            % generate a matrix from the vectors
            R = reshape(R, [g_evo_IR_palette_width,  g_evo_IR_palette_height]);
            G = reshape(G, [g_evo_IR_palette_width,  g_evo_IR_palette_height]);
            B = reshape(B, [g_evo_IR_palette_width,  g_evo_IR_palette_height]);
            
            % fuse three channel rgb image
            if obj.isWindows
              RGB = cat(3, B', G', R');
            else
              RGB = cat(3, R', G', B');
            end
        end
        
        %% function to set palette's color
        function set_palette_colormap(obj, palette_id)
            calllib(obj.libName, ...
                    'evo_irimager_set_palette', ...
                    palette_id); 
        end
        
        %% function to set palette's range
        function set_palette_scale(obj, scale_id)
            calllib(obj.libName, ...
                    'evo_irimager_set_palette_scale', ...
                    scale_id); 
        end
        
        %% function to trigger shutter flag of camera
        function trigger_shutter_flag(obj)
            calllib(obj.libName, 'evo_irimager_trigger_shutter_flag'); 
        end
       
        %% Function to terminate the connection
        function set_temperature_range(obj, min, max)
            calllib(obj.libName, 'evo_irimager_set_temperature_range', min, max)
        end
        
        %% Default destructor
        function delete(obj)
            % clear memory and disconnect
            clear obj.pPalette;
            clear obj.pRaw;
            terminate(obj);
        end
       
        
        %% Function to terminate the connection
        function terminate(obj)
            calllib(obj.libName, 'evo_irimager_terminate');
            pause(1);
        end
    end
end
