% Generates PWM signals to be used with the Arbitrary Waveform Generation.
% (Remember 22nd Feb PWM Sandbox Sharkfin)
% [PWM s_t] = UARP_PWM(f, B, T, levels, window, varargin)
%
% f = frequency in Hz
% B is bandwidth in Hz
% T is duration in seconds
% levels specifies 5, 3 or 4 (3 LV)
% window is a string containing the window function e.g. 'Hann'
% varargin: variable argumentsd such as tukey parameter or user window

function [PWM s_t] = UARP_PWM(f, B, T, levels, window, varargin)    

if (T > 20e-6)
    disp '! ! !'
    disp 'T should be less than 20 us'
    disp '! ! !'
    PWM = [];
    s_t = [];
    return
end

fs = 100e6;
t = 0:1/fs:T-(1/fs);

disp(['f = ' num2str((f)/1e6) ' MHz'])
disp(['f_start = ' num2str((f-B/2)/1e6) ' MHz'])
disp(['f_stop = ' num2str((f+B/2)/1e6) ' MHz'])
disp(['T = ' num2str((T)*1e6) ' us'])

TB_ = T * B;

disp(['TB Product = ' num2str(TB_)]);

w = (f-(B/2))+((B/(2*T))*t);

s_t = sin((2*pi*w.*t));

L = length(s_t);

if (isempty(varargin))
    varargin = 0;
end

if ( strcmp('tukey',window) || strcmp('Tukey',window) )
    disp 'Tukey Window'
    win = tukeywin( L, varargin{1})';
    
elseif ( strcmp('hann',window) || strcmp('Hann',window) )
    disp 'Hann Window'
    win = hann(L)';
    
elseif ( strcmp('hamming',window) || strcmp('Hamming',window) )
    disp 'Hamming Window'
    win = hamming(L)';
    
elseif ( strcmp('gausswin',window) || strcmp('Gausswin',window) )
    disp 'Gaussian Window'
    win = Gausswin(L)';
    
elseif ( strcmp('user',window) || strcmp('User',window) )
    disp 'User Window'
    win = varargin{1};
    win = win';
    if (length(win) ~= L)
        disp '! ! !'
        disp 'User defined window is of incorrect length'
        disp(['Correct length L = ' num2str(L)])
        disp '! ! !'
        PWM = [];
        return
    elseif ( (min(win) < 0) || (max(win) > 1) )
        disp '! ! !'
        disp ' User defined window must be between 0 and 1'
        disp '! ! !'
        PWM = [];
        return
    end
    
else
    disp 'No Window'
    win = tukeywin(L,0)';
    
end
    
s_t = s_t .* win;

% % % % 

win_pos = win;
win_neg = -win;

w_chirp_tri = (((f)-(B/2))+((B/(2*T))*t));

carrier_sharkfin  = abs(cos((2*pi*w.*t+2*pi)));

carrier_sharkfin_pos2 = 0.5*carrier_sharkfin+0.5;
carrier_sharkfin_pos = 0.5*carrier_sharkfin;
carrier_sharkfin_neg = -0.5*carrier_sharkfin;
carrier_sharkfin_neg2 = -0.5*carrier_sharkfin-0.5;

carrier_bi_sharkfin_pos = carrier_sharkfin;
carrier_bi_sharkfin_neg = -carrier_sharkfin;

pwm_sharkfin = zeros(1,length(t));
pwm_3_sharkfin = zeros(1,length(t));

PWM = win;

for i = 1:(length(carrier_sharkfin_pos))
    
    if s_t(i) > 0
        if win_pos(i) >= carrier_sharkfin_pos2(i)
            pwm_sharkfin(i) = 1;
        elseif win_pos(i) >= carrier_sharkfin_pos(i)
            pwm_sharkfin(i) = 0.5;
        else
            pwm_sharkfin(i) = 0;
        end
    elseif s_t(i) < 0
        if win_neg(i) <= carrier_sharkfin_neg2(i)
            pwm_sharkfin(i) = -1;
        elseif win_neg(i) <= carrier_sharkfin_neg(i)
            pwm_sharkfin(i) = -0.5;
        else
            pwm_sharkfin(i) = 0;
        end
    end
    
    
    if s_t(i) > 0
        if win_pos(i) >= carrier_bi_sharkfin_pos(i)
            pwm_3_sharkfin(i) = 1;
        else
            pwm_3_sharkfin(i) = 0;
        end
    else
        if win_neg(i) <= carrier_bi_sharkfin_neg(i)
            pwm_3_sharkfin(i) = -1;
        else
            pwm_3_sharkfin(i) = 0;
        end
    end
    
end

if (levels == 5)
    PWM = pwm_sharkfin;
    disp '5 Level PWM'
    
elseif (levels == 3)
    PWM = (pwm_3_sharkfin/2);
    disp '3 Level (Low Voltage) PWM'
    
elseif (levels == 4)
    PWM = (pwm_3_sharkfin);
    disp '3 Level (High Voltage) PWM'
    
else
    PWM = pwm_sharkfin;
    disp '5 Level PWM'
end


end