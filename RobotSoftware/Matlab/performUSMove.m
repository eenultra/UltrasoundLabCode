function [ endEarly, nextStartOpOrIdx, nextEndOpOrIdx ] = ...
    performUSMove( obj, startOpIdx, endOpIdx, loopIdx, varargin )  %#ok<INUSL>
% Jump to next operation.
tpause=2;
disp('moving arm')

switch loopIdx
    
    case 1
        % move to position 1
        stCartMoveTank([-25 400  40 110 9]);pause(tpause); %pos 1 (right) 
        Bmode_DAS_rt
    case 2
        % move to position 2
       stCartMoveTank([-25 300 60 90 9]);pause(tpause); %pos 2 (middle)  
    case 3
        % move to position 3
        stCartMoveTank([-25 200  40 70 9]);pause(tpause); %pos 3 (left)
    case 4
        % move to position 4
        stCartMoveTank([0 200  50 70 0]);pause(tpause); %pos 4 (left)    
    case 5
        % move to position 5
        stCartMoveTank([0 300  60 90 0]);pause(tpause); %pos 5 (middle)
        Bmode_DAS_rt
    case 6
        % move to position 6
        stCartMoveTank([0 400  50 110 0]);pause(tpause); %pos 6 (right)    
    case 7
        % move to position 7
        stCartMoveTank([25 400  40 110 -10]);pause(tpause); %pos 7 (right)    
    case 8
        % move to position 8
        stCartMoveTank([25 300  60 90 -10]);pause(tpause); %pos 8 (middle)    
    case 9
        % move to position 9
        stCartMoveTank([25 200  40 70 -10]);pause(tpause); %pos 9 (left)    
    otherwise
        % choose a safe backup position
        stCartMoveTank([0 300  80 90 0]);pause(tpause); %pos 10 (clear, to stop hitting phantom on way back) 
        Bmode_DAS_rt
end

% Default output values.
endEarly = false;
nextStartOpOrIdx = 1;
nextEndOpOrIdx = 1;

end






