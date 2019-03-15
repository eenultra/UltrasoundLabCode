function r = IsMoving(StatusBits)
% Read StatusBits returned by GetStatusBits_Bits method and determine if
% the motor shaft is moving; Return 1 if moving, return 0 if stationary
r = bitget(abs(StatusBits),5)||bitget(abs(StatusBits),6);
