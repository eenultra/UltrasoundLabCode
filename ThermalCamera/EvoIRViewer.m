classdef EvoIRViewer
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = EvoIRViewer()
            
            global viewer_is_running;
            
            uicontrol('Style','PushButton',     ...
                'String','Close',         ...
                'Position', [0 0 100 25],...
                'Callback','viewer_is_running=false');
            viewer_is_running = true;
            
            % create pop-up menu to switch palette
            palette_ui = uicontrol('Style', 'popup',...
                'String', {'AlarmBlue','AlarmBlueHi', ...
                'GrayBW',    'GrayWB', ...
                'AlarmGreen','Iron', ...
                'IronHi',    'Medical', ...
                'Rainbow',   'RainbowHi', ...
                'AlarmRed'},...
                'Position', [ 120 0 100 25],...
                'Callback', @obj.set_palette_colormap);
            % set default for palette
            set(palette_ui,'Value',6);
            
            scale_ui = uicontrol('Style', 'popup',...
                'String', {'MinMax',  ...
                'Sigma1',  ...
                'Sigma2'}, ...
                'Position', [ 250 0 100 25],...
                'Callback', @obj.set_palette_scale);
            % set default for platte's scale
            set(scale_ui,'Value',1);
            
            flag_ui = uicontrol('Style','PushButton',     ...
                'String','Trigger Flag',         ...
                'Position', [370 0 100 25],...
                'Callback', @obj.trigger_shutter_flag);
        end
        
        function set_palette_colormap(obj, source,event)
            global IRInterface;
            IRInterface.set_palette_colormap(source.Value);
        end
        
        function set_palette_scale(obj, source,event)
            global IRInterface;
            IRInterface.set_palette_scale(source.Value+1);
        end
        
        function trigger_shutter_flag(obj, source, event)
            global IRInterface;
            IRInterface.trigger_shutter_flag();
        end
    end
end

