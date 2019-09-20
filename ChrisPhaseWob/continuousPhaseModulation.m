function [waveforms,t] = continuousPhaseModulation(nElem, maxPhase,fc,t)
    %Generate continually phase modulated waveforms for each element
    
    %The phase modulations used to create the waveforms
%   phaseMod =  linspace(-1,1,length(t));
    %phaseMod =sawtooth((1/t(end))*2*pi*t,0.5);
    phaseMod = sin(2*pi*(1/t(end))*t);
    %Inner elements  have no phase shift and outer most swing the most
    phaseModSwing = linspace(-maxPhase,maxPhase,nElem);
    %Go there and back!
%     phaseModSwing = maxPhase*sawtooth((1/t(end))*2*pi*t,0.5);
    
    waveforms = zeros(nElem,length(t));
    
    for ii=1:nElem
        waveforms(ii,:) = sin((2*pi*fc*t)+(phaseModSwing(ii)*phaseMod));
    end
end