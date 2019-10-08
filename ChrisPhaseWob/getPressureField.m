function P = getPressureField(simargs)
    [P ~] = calc_hp(simargs.Th, simargs.points);

    P = -min(P);
end