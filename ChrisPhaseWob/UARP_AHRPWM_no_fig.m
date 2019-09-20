% Generates PWM signals to be used with the Arbitrary Waveform Generation.
% (Remember DC Thesis Work in UDrive)
% [HRPWM s_t] = UARP_HRPWM(f, B, T, window, varargin)
%
% f = frequency in Hz
% B is bandwidth in Hz
% T is duration in seconds
% levels specifies is always5
% window is a string containing the window function e.g. 'Hann'
% varargin: variable argumentsd such as tukey parameter or user window

function [HRPWM s_t] = UARP_AHRPWM(input_waveform_t, input_waveform, fs, MaxVoltage)    

%if (isempty(varargin))
%    varargin = 0;
%end

%% Input waveform

% if (isempty(varargin))
%     load('input_waveform.mat')
%     fs = 160e6;
% end

% Transform inputs into row vectors
input_waveform_t=input_waveform_t(:)';
input_waveform=input_waveform(:)';

% Peak amplitude of the input waveform
amplitude  = max(abs(input_waveform))

% Normalise input waveform
original_input_waveform=input_waveform;
input_waveform = input_waveform ./ amplitude;

% Check for non-zero start and end values
if( input_waveform_t(1) | input_waveform_t(end) )
    warning('Input waveform contains end points. Setting end points to zero.');
    input_waveform(1)=0;
    input_waveform(end)=0;
end

%amplitude_max = 4*MaxVoltage/pi; % * 0.72;
amplitude_max = MaxVoltage; %*
amplitude = amplitude ./ amplitude_max

% 
% % Positive and negative peaks - rough peak indexing
% [~,pos_locs] = findpeaks( input_waveform );
% [~,neg_locs] = findpeaks( -input_waveform );
% [~,zero_locs] = findpeaks( -abs(input_waveform) );
% 
% % Start and end of waveform
% start_locs = max([1 find( input_waveform(1:pos_locs(1))==0 ) ]) ;
% end_locs = min( [length(input_waveform)  max(pos_locs) + min( find( input_waveform(max(pos_locs):end)==0 ) )-1 ]);
% 
% %zero_locs = [1 zero_locs end_locs];
% 
% 
% 
% figure
% plot(input_waveform_t*1e6,original_input_waveform,'b')
% xlabel('Time (\mus)')
% ylabel('Voltage (V)')
% %export_png('input_waveform')
% 
% figure
% plot(input_waveform_t*1e6,amplitude_max*abs(hilbert(input_waveform)),'k')
% hold on
% plot(input_waveform_t*1e6,-amplitude_max*abs(hilbert(input_waveform)),'k')
% xlabel('Time (\mus)')
% ylabel('Voltage (V)')
% %export_png('hilbert_windows')
% 
% figure
% plot(input_waveform_t*1e6,input_waveform./abs(hilbert(input_waveform)),'r')
% ylabel('Voltage (V)')
% xlabel('Time (\mus)')
% %export_png('input_waveform_unity')
% 
% 
% figure
% plot(input_waveform_t,input_waveform)
% set(gca,'YGrid','on')
% 
% hold on
% 
% plot(input_waveform_t(pos_locs),input_waveform(pos_locs),'b*')
% plot(input_waveform_t(neg_locs),input_waveform(neg_locs),'b*')
% plot(input_waveform_t(zero_locs),input_waveform(zero_locs),'bo')
% 
% %input_waveform = input_waveform./abs(hilbert(input_waveform));
% 
% % Positive and negative peaks - by gradient
% input_waveform_gradient = diff(input_waveform);
% input_waveform_gradient_t = input_waveform_t(1:end-1)+0.5*(input_waveform_t(2)-input_waveform_t(1));
% 
% plot(input_waveform_gradient_t,input_waveform_gradient,'r:')
% 
% for idx=1:length(pos_locs)
%     min_index = max([1 pos_locs(idx)-2])
%     max_index = min([length(input_waveform_gradient) pos_locs(idx)+2])
%     pos_peak_times(idx) = interp1( input_waveform_gradient(min_index:max_index), input_waveform_gradient_t(min_index:max_index), 0, 'pchip' )
% end
% plot(pos_peak_times,0,'rs')
% 
% for idx=1:length(neg_locs)
%     min_index = max([1 neg_locs(idx)-2])
%     max_index = min([length(input_waveform_gradient) neg_locs(idx)+2])
%     neg_peak_times(idx) = interp1( input_waveform_gradient(min_index:max_index), input_waveform_gradient_t(min_index:max_index), 0, 'pchip' )
% end
% plot(neg_peak_times,0,'rs')
% 
% zero_times = []
% 
% % Zero crossing - by interpolation
% for idx=1:length(zero_locs)
%     zero_locs(idx)
%     zero_times(idx) = interp1( input_waveform((zero_locs(idx)-4):(zero_locs(idx)+4)), input_waveform_t((zero_locs(idx)-4):(zero_locs(idx)+4)), 0, 'pchip' )
% end
% plot(zero_times,0,'ro')
% 
% % Window at positive and negative peaks by interpolation
% window_point_times = sort([pos_peak_times, neg_peak_times])
% window_point_amplitude = interp1(input_waveform_t,input_waveform,window_point_times,'pchip')
% 
% window_point_times = [input_waveform_t(start_locs)-1e-6 input_waveform_t(start_locs) window_point_times input_waveform_t(end_locs) input_waveform_t(end)+1e-6];
% window_point_amplitude = [ 0 0 window_point_amplitude 0 0 ];
% 
% plot(window_point_times,abs(window_point_amplitude),'r*')
% plot(window_point_times,-abs(window_point_amplitude),'r*')
% 
% % Positive window
% window_point_times_p = sort([pos_peak_times])
% window_point_amplitude_p = interp1(input_waveform_t,input_waveform,window_point_times_p,'pchip')
% 
% % Negative window
% window_point_times_n = sort([neg_peak_times])
% window_point_amplitude_n = interp1(input_waveform_t,input_waveform,window_point_times_n,'pchip')
% 
% plot(window_point_times_p,window_point_amplitude_p,'k*:')
% plot(window_point_times_n,window_point_amplitude_n,'k*:')
% xlim([-20e-6 20e-6])
% 
% 
% 

% %% TEST CODE - recalculate pos and negative peaks after removal of windowing?
% 
% win = interp1( window_point_times, abs(window_point_amplitude) , input_waveform_t, 'pchip' )
% 
% input_waveform_norm = input_waveform(:) ./  win(:);
% 
% figure
% plot(input_waveform_t,input_waveform_norm)
% 
% figure
% % Positive and negative peaks - by gradient
% input_waveform_gradient_norm = diff(input_waveform_norm);
% input_waveform_gradient_t = input_waveform_t(1:end-1)+0.5*(input_waveform_t(2)-input_waveform_t(1));
% 
% [pks,pos_locs] = findpeaks( input_waveform_norm )
% [pks,neg_locs] = findpeaks( -input_waveform_norm )
% 
% for idx=1:length(pos_locs)
%     idx
%     min_index = max([1 pos_locs(idx)-2])
%     max_index = min([length(input_waveform_gradient_norm) pos_locs(idx)+2])
%     pos_peak_times(idx) = interp1( input_waveform_gradient_norm(min_index:max_index), input_waveform_gradient_t(min_index:max_index), 0, 'pchip' )
% end
% plot(pos_peak_times,0,'rs')
% 
% for idx=1:length(neg_locs)
%     min_index = max([1 neg_locs(idx)-2])
%     max_index = min([length(input_waveform_gradient_norm) neg_locs(idx)+2])
%     neg_peak_times(idx) = interp1( input_waveform_gradient_norm(min_index:max_index), input_waveform_gradient_t(min_index:max_index), 0, 'pchip' )
% end
% plot(neg_peak_times,0,'rs')
% 
% 
% % Window at positive and negative peaks by interpolation
% 
% window_point_times = sort([pos_peak_times, neg_peak_times])
% window_point_amplitude = interp1(input_waveform_t,input_waveform,window_point_times,'pchip')
% 
% window_point_times = [0 window_point_times input_waveform_t(end)];
% window_point_amplitude = [ 0 window_point_amplitude 0 ];





%%



t = 0:(1/fs):max(input_waveform_t)

resampled_input_waveform = interp1( input_waveform_t, original_input_waveform, t, 'cubic', 'extrap' );

% win = interp1( window_point_times, abs(window_point_amplitude) , t, 'pchip' )
% 
% %win = pi*win/4
% 
% if( pos_peak_times(1) < neg_peak_times(1) )
%     phase_polarity = 1;
% else
%     phase_polarity = -1;
% end
% 
% input_waveform_t(start_locs)
% 
% % Calculate phase at start, pos peaks, neg peaks and end,
% phase_point_times = sort([input_waveform_t(start_locs) pos_peak_times neg_peak_times zero_times window_point_times(end)]);
% phase_points_rads = phase_polarity * (0:(length(phase_point_times)-1)) * pi / 2;
% 
% % Interpolate phase at time sample points
% [B,Ia, Ib] = unique(phase_point_times)
% 
% phase_point_times = phase_point_times(Ia);
% phase_points_rads = phase_points_rads(Ia);
% 
% phase_rads = interp1([-100e-6 phase_point_times 100e-6], [0 phase_points_rads 0], t, 'pchip' )
% 
% 







win= abs(hilbert(resampled_input_waveform));

phase_rads = angle(hilbert(resampled_input_waveform));
t = (0:length(phase_rads)-1) * (1/fs);

s_t = win .* cos(phase_rads)

size(t)
size(phase_rads)

% figure
% %plot(phase_point_times, phase_points_rads,'o')
% %hold on
% plot(t*1e6,phase_rads)
% xlim([0 10])
% xlabel('Time (\mus)')
% ylabel('Phase (radians)')
% %export_png('phase_rads')
% 
% figure
% plot(input_waveform_t,original_input_waveform,'Color',[0.8 0.8 0.8])
% hold on
% plot(t,win)
% plot(t,-win)
% plot(t, s_t)
% legend('Input','Positive Window','Negative Window','Reconstructed waveform')


phase_rads = phase_rads+(pi/2);

%%

% f = 2.25e6;
% B = 1e6;
% T = 10e-6;
% amplitude = 1;
% window = 'hann';
% 
% 
% % if (T > 20e-6)
% %     disp '! ! !'
% %     disp 'T should be less than 20 us'
% %     disp '! ! !'
% %     PWM = [];
% %     s_t = [];
% %     return
% % end
% 
% t = 0:1/fs:T-(1/fs);
% 
% disp(['f = ' num2str((f)/1e6) ' MHz'])
% disp(['f_start = ' num2str((f-B/2)/1e6) ' MHz'])
% disp(['f_stop = ' num2str((f+B/2)/1e6) ' MHz'])
% disp(['T = ' num2str((T)*1e6) ' us'])
% 
% TB_ = T * B;
% 
% disp(['TB Product = ' num2str(TB_)]);
% 
% % Instantaneous Frequency
% f_i = (f-(B/2))+((B/(2*T))*t);
% 
% % Phase in radians
% phase_rads = 2*pi*f_i.*t
% phase_rads = mod(phase_rads,2*pi)
% plot(phase_rads)
% 
% % Calculate key phase points
% 
% scale = 1/3.5e6;
% 
% cycle_points  = [0 0.15 0.5 0.85 1] % Excluide 1 for repeat purposes
% 
% t_points = scale * ...
%     [ 0+cycle_points(1:end-1)...
%      1+cycle_points(1:end-1)...
%      2+cycle_points(1:end-1)...
%      3+cycle_points(1:end-1)...
%      4+cycle_points(1:end-1)...
%      5+cycle_points(1:end-1)...
%      6+cycle_points(1:end-1)...
%      7+cycle_points(1:end-1)...
%      8+cycle_points(1:end-1)...
%      9+cycle_points(1:end)...
%     ];
% 
% phase_points = [0 0.25 0.5 0.75 1] 
% 
% phase_points_rads = 2 * pi * ...
%     [ 0+phase_points(1:end-1)...
%      1+phase_points(1:end-1)...
%      2+phase_points(1:end-1)...
%      3+phase_points(1:end-1)...
%      4+phase_points(1:end-1)...
%      5+phase_points(1:end-1)...
%      6+phase_points(1:end-1)...
%      7+phase_points(1:end-1)...
%      8+phase_points(1:end-1)...
%      9+phase_points(1:end)...
%     ];
% 
% figure
% plot(t_points,phase_points_rads,'o-')
% 
% 
% T = t_points(end)
% t = 0:1/fs:T-(1/fs);
% 
% % Calculate time sampled (1/fs) phase 
% phase_rads = interp1(t_points,phase_points_rads,t)
% 
% 
% %
% 
% % Modulated waveform
% s_t = sin( phase_rads );
% 
% figure
% plot(t,s_t)
% 
% % Calculate window
% L = length(s_t);
% 
% if ( strcmp('none',window) || strcmp('None',window) )
%     disp 'Tukey Window'
%     win = tukeywin( L, 0)';
% elseif ( strcmp('tukey',window) || strcmp('Tukey',window) )
%     disp 'Tukey Window'
%     win = tukeywin( L, varargin{1})';
%     
% elseif ( strcmp('hann',window) || strcmp('Hann',window) )
%     disp 'Hann Window'
%     win = hann(L)';
%     
% elseif ( strcmp('hamming',window) || strcmp('Hamming',window) )
%     disp 'Hamming Window'
%     win = hamming(L)';
%     
% elseif ( strcmp('gausswin',window) || strcmp('Gausswin',window) || strcmp('gaussian',window) || strcmp('Gaussian',window) )
%     disp 'Gaussian Window'
%     win = gausswin(L)';
%     
% elseif ( strcmp('user',window) || strcmp('User',window) )
%     disp 'User Window'
%     win = varargin{1};
%     win = win';
%     if (length(win) ~= L)
%         disp '! ! !'
%         disp 'User defined window is of incorrect length'
%         disp(['Correct length L = ' num2str(L)])
%         disp '! ! !'
%         PWM = [];
%         return
%     elseif ( (min(win) < 0) || (max(win) > 1) )
%         disp '! ! !'
%         disp ' User defined window must be between 0 and 1'
%         disp '! ! !'
%         PWM = [];
%         return
%     end
%     
% else
%     disp 'No Window'
%     win = tukeywin(L,0)';
%     
% end
% 
% % Final analog waveform    
% s_t = s_t .* win * amplitude;
% 
% figure
% plot(t,s_t)

% Calculate carrier waveforms

L = length(s_t);

%amplitude = amplitude/1.04;

%unity_mod = original_input_waveform./abs(hilbert(original_input_waveform));
%trig_phase_rads = real(log(unity_mod+j*hilbert(unity_mod))*0.5j);
%figure;
%plot(unwrap(2*trig_phase_rads),'r');
%phase_rads = trig_phase_rads;

% Positive and negative windows
win_pos = win / 1.103;
win_neg = -win / 1.103;

win_pos = win /1.1216;
win_neg = -win /1.1216 ;


%win_pos = win / 1.15;
 %win_neg = -win / 1.15;


% figure
% plot(t,win_pos,'--')
% hold on
% plot(t,win_neg,':')
% legend('Positive Window','Negative Window')

% % Carrier Definitions
%phase_rads = 2*pi*f_i.*t
cos1 = abs(0.578*cos(phase_rads         ));
cos2 = abs(      cos(phase_rads - (pi/6)));
cos3 = abs(      cos(phase_rads + (pi/6)));

TC1 = MaxVoltage*0.5;
TC2 = MaxVoltage*0.866;

carrier1 = zeros(1,L);
carrier2 = zeros(1,L);
carrier3 = zeros(1,L);

disp '5 Level PWM'

for i = 1:length(cos2)
    
    % % Define Carrier 1 % %
        
    if (cos3(i) < cos2(i))
        carrier1(i) = cos3(i);
        
    elseif (cos2(i) < cos3(i))
        carrier1(i) = cos2(i);
        
    else
        carrier1(i) = cos2(i);
    end
    
    % % Define Carrier 2 % %
    
    if ( cos1(i) > TC1 )
        
        if (cos3(i) > cos2(i))
            carrier2(i) = cos3(i);
        elseif (cos2(i) > cos3(i))
            carrier2(i) = cos2(i);
            carrier2(i) = cos2(i);
        end
        
    else
        carrier2(i) = 1;
        
    end
    
   
         
         
    % % Define Carrier 3 % %
    
    if ( cos1(i) < TC1 )
        
        if (cos3(i) > cos2(i))
            carrier3(i) = cos3(i);
        elseif (cos2(i) > cos3(i))
            carrier3(i) = cos2(i);
        else
            carrier3(i) = cos2(i);
        end
        
    else
        carrier3(i) = 1;
        
    end
    
end

pos_pwm_l = zeros(1,L);
pos_pwm_h = zeros(1,L);
neg_pwm_l = zeros(1,L);
neg_pwm_h = zeros(1,L);

pcar1 = MaxVoltage * carrier1;
pcar2 = MaxVoltage * carrier2;
pcar3 = MaxVoltage * carrier3;
ncar1 = MaxVoltage * -carrier1;
ncar2 = MaxVoltage * -carrier2;
ncar3 = MaxVoltage * -carrier3;

% figure
% plot(t*1e6, pcar1,'r'); hold on
% plot(t*1e6, pcar2,'r:')
% plot(t*1e6, pcar3,'k')
% plot(t*1e6, ncar1,'r')
% plot(t*1e6, ncar2,'r:')
% plot(t*1e6, ncar3,'k')
% 
% plot(t*1e6,win_pos)
% plot(t*1e6,win_neg)
% plot(t*1e6,s_t)
% 
% xlabel('Time (\mus)')
% ylabel('Modulated Carrier (radians)')
% xlim([0 10])
% ylim([-110 110])
%export_png('modulated_carrier_zoom')



for i = 1:L
    
    % % VPP1 Modulation % %
    if s_t(i) >= 0;
        
        if (win_pos(i) < TC2) % use lowest carrier...
            if (win_pos(i) <= pcar1(i))
                pos_pwm_l(i) = 0;
            else
                pos_pwm_l(i) = 0.5;
            end
            
        else % use highest carrier...
            if (win_pos(i) <= pcar2(i))
                pos_pwm_l(i) = 0.5;
            else
                pos_pwm_l(i) = 0;
            end
            
        end
        
        
        % % VPP2 Modulation % %
        
        if (win_pos(i) <= pcar3(i))
            pos_pwm_h(i) = 0;
        else
            pos_pwm_h(i) = 0.5;
        end
        
    else  %% use negative
        
        % % VNN1 Modulation % %
        
        if (win_neg(i) > -TC2) % use lowest carrier...
            if (win_neg(i) >= ncar1(i))
                neg_pwm_l(i) = 0;
            else
                neg_pwm_l(i) = -0.5;
            end
            
        else % use highest carrier...
            if (win_neg(i) >= ncar2(i))
                neg_pwm_l(i) = -0.5;
            else
                neg_pwm_l(i) = 0;
            end
            
        end
        
        
        % % VNN2 Modulation % %
        
        if (win_neg(i) >= ncar3(i))
            neg_pwm_h(i) = 0;
        else
            neg_pwm_h(i) = -0.5;
        end
        
    end
end

HRPWM = MaxVoltage * ( pos_pwm_l + pos_pwm_h + neg_pwm_l + neg_pwm_h );
%s_t = s_t*amplitude*MaxVoltage;


% figure
% plot(t*1e6,HRPWM)
% xlabel('Time (\mus)')
% ylabel('Excitation Voltage (V)')
% xlim([0 10])

%export_png('HRPWM')

% Evaluate frequency spectra

% 
% figure
freq = 1/mean( diff(input_waveform_t) )
f = ((1:length(input_waveform_t))-1) / length(input_waveform_t) * freq;
% 
% plot(f,abs(fft(original_input_waveform)),'b:')

f = ((1:length(HRPWM))-1) / length(HRPWM) * fs;
% hold on
% plot(f,abs(fft(s_t)),'k')
% plot(f,abs(fft(HRPWM)),'r')
% 
% legend('Input Waveform','Reconstructed Waveform','HRPWM')


%end