function parFieldPhase (phases,apo,simargs)

    simargs.phases = phases;

    timeShifts = simargs.phases/(2*pi*simargs.fmin);
    timeShifts = timeShifts + abs(min(timeShifts));
    xdc_focus_times(simargs.Th,0,timeShifts);
    timeShifts
    
    xdc_apodization(simargs.Th,0,apo)
end
