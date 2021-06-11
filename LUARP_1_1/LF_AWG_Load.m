% LF_AWG_Load.m
%
%   Version:    LUARP_1_1 (UARP 1.1)
%   Type:       LUARP Fundamental (LF_)
%   Action:     Load an Arbitrary Waveform into LUARP memory.
%
%   Usage: LF_AWG_Load
%       LF_AWG_Load loads a Waveform designed in Matlab into the LUARP.
%       
%       The format of 'Waveform' is a 1D array of values.
%       These values must be sampled at 100 MHz.
%       The maximum length of waveform is 2000 (+ 48 RTZ concatanated).
%       This equates to 20 us approximately.
%       There are only 5 correct values for Waveform...
%           ... -1, -0.5, 0, 0.5 and 1.
%       These values will be converted to MOSFET signals by this function.
%
%       An 'incorrect format' message will be displayed if one of the values
%       is not as described above.
%
%       Board is always 1.
%
%       Channel is always 1.

function LF_AWG_Load ( Waveform )
    
    Waveform = [Waveform zeros(1,48)];
    
    h = waitbar(0,'Configuring LUARP, Please wait...');
    color = get(0,'factoryUicontrolBackgroundColor');
    set(h,'Color',color);
    
    AWG_Waveform = zeros(1,length(Waveform));
    if (length(Waveform) > 2048 )
        disp('Waveform is too long or sampled incorrectly')
        disp('Maximum length is 2000 samples')
        disp('Sampling must be at 100 MHz')
        return
    else
        disp('Transferring Waveform Data...')
        for i=1:(length(Waveform))
            switch Waveform(i)
                case (-1)
                    AWG_Waveform(i) = 1;    % VNN2
                case (-0.5)
                    AWG_Waveform(i) = 2;    % VNN1
                case (0)
                    AWG_Waveform(i) = 4;    % VNC1
                case (0.5)
                    AWG_Waveform(i) = 8;    % VPP1
                case (1)
                    AWG_Waveform(i) = 16;   % VPP2
                otherwise
                    AWG_Waveform(i) = 4;    % VNC1
                    disp('Incorrect Waveform File Format')
                    disp('Uploaded Waveform may contain errors')
            end

            Address_Data =  [dec2hex((i-1),4) dec2hex(AWG_Waveform(i),4)];
            LF_Send_Command(31, 1, hex2dec(Address_Data));
            waitbar(i/length(Waveform))
        end
        disp('Waveform Transfer Complete')
        close(h) 
    end

end