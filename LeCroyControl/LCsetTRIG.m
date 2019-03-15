function LCsetTRIG(lc,trig)

%Sets the trigger mode for the scope
%{AUTO, NORM, SINGLE, STOP}

TF = strcmp(trig, 'ARM');

if TF == 1
    
    invoke(lc,'WriteString',trig,true);
    
else

invoke(lc,'WriteString',['TRMD ' trig],true);

end





