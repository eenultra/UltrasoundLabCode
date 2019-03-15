function agsetTRIG(mode)
%agseTRIG(mode)
%Sets mode of the trigger
% IMM
% EXT
% BUS

%Robin Cleveland
%Boston University
%May 2006

global AG

if nargin==0,
    mode='BUS';
end

fprintf(AG,['TRIG:SOUR ' mode]);
