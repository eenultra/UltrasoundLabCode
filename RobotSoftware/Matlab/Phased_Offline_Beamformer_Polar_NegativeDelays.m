%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Delay and Sum Beamformer for Compound Plane Wave Imaging
% by Luzhen Nie
% University of Leeds, UK. November 2015.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       
%       Performes DAS beamforming for the RF data of a plane wave steered
%       with (theta_d) degree.
%       RF_data is the received RF data.
%       theta_d is the steering angle of the plane wave in degree, can be
%       a positive or a negative value.
%       z_start is the imaging depth starting point in meter.
%       z_stop is the imaging depth ending point in meter.
%       image_width is the required width of the produced image.
%       lateral_step is the lateral step size between each lines of the
%       beamformed image. (pitch/2 is a good choice)
%       N_elements is the total number of elements in the transducer. 
%       pitch is the distance between the centres of two adjacent elements.
%       c is the sound speed im m/s.
%       fs is the sampling frequency.
%
%
%   Method:
%       In DAS beamforming, for each point of (x,z), the RF data from each receiving element is
%       delayed and the selected samples from these elements are summed. 
%       for each point (x,z), the delays applied to the RF data are
%       calculated by the time required for the signal to travel from the
%       transmiter to the field point and back to the receiving element as follows:
%       t = t_transmit + t_receive
%       t_transmit= [ z.cos(theta_d)+x.sin(theta_d)+0.5.N_elements.pitch.sin(|theta_d|) ]/c
%       t_receive(for element j)= sqrt(z^2 + (xj-x)^2)/c
%
%
%   Additions:
%       Receive Apodization - Hann window (twice the transducer) 
%       Element Directivity Check - discard contributions from elements that are >45 degrees to the beamforming point
%                                 - corrected for non-zero starting depth
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Example:
%       RF_data = UARP_TEMP_DATA;
%       X0 = 0;   virtual source bias in pitch scale
%       N_elements = 128;
%       pitch = 0.3048e-3;
%       image_width = N_elements*pitch;
%       lateral_step = pitch/2;
%       z_start = 5e-3;
%       z_stop = 60e-3;
%       c = 1482;
%       fs = 80e6;
%       [Beamformed_DATA, z_axis, x_axis] = CPWI_Beamformer(RF_data, theta_d, z_start, z_stop, image_width, lateral_step, N_elements, pitch, c, fs);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Beamformed_DATA,Rad,Phi] = Phased_Offline_Beamformer_Polar_NegativeDelays(RF_data,imageLine,MinRad,MaxRad,...
    BeamformedLineStep, nElements, pitch, SpeedOfSound, fs,BeamformedAngleRange)


lambda_fs = SpeedOfSound/fs;
BeamformedLines = BeamformedAngleRange/BeamformedLineStep+1;
Rad = MinRad:lambda_fs/2:MaxRad;
Phi = linspace(-BeamformedAngleRange/2,BeamformedAngleRange/2,BeamformedLines)';


for line = imageLine
    
    theta = Phi(line);
    
    Beamformed_DATA = zeros(1, length(Rad));    % Allocate memeory for the Beamformed Data

    % Delay calculations and Beamforming

    d1 = Rad; % Distance from the transmitter to the points


    for xj = 1 : nElements  % Calculate the image data for each receiving element
    RF_address = round( ( d1 + sqrt((Rad*cosd(theta)).^2+(Rad*sind(theta)-(xj-(nElements+1)/2)*pitch).^2) ) ./ lambda_fs);
    RF_col = RF_data(:, xj);
    [RF_address_size1, RF_address_size2] = size(RF_address);
    Beamformed_DATA(1:RF_address_size1, 1:RF_address_size2) = Beamformed_DATA(1:RF_address_size1, 1:RF_address_size2) ...
         + RF_col(RF_address)';  
    end
        
%   Beamformed_DATA_Frame(1:max(size(Rad)),line)= ((Beamformed_DATA));
    
end

