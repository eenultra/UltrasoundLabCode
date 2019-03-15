function vdiv=LCmaxVDIV(lc,chanstr)

vdiv=LCgetVDIV(lc,chanstr);
vdivMX = vdiv*7.5;

invoke(lc,'WriteString','SEQ OFF',true);

%{
%For Serial Connection
fprintf(lc,[chanstr ':OFST?']);
voffset=str2num(fscanf(lc));

fprintf(lc,[chanstr ':ATTN?']);
probeatten=str2num(fscanf(lc));
%}
%For IP/TCP connection
invoke(lc,'WriteString',[chanstr ':OFST?'],true);
voffset=str2double(invoke(lc,'ReadString',80));

invoke(lc,'WriteString',[chanstr ':ATTN?'],true);
probeatten=str2double(invoke(lc,'ReadString',80));

LCsetTRIG(lc,'NORM');pause(0.1);
[wfx,wfy]= LCreadwf(lc,chanstr);
vpk = range(wfy);


if vpk < vdivMX
    
    if vdiv <= 2.00E-3
        return 
    end
    
    vdiv = vpk/7.5;
    LCsetVDIV(lc,chanstr,vdiv);
    return
end

if vpk > vdivMX
    
    while vpk >= vdivMX
    vdivMX = vdiv*7.5;
    LCsetTRIG(lc,'NORM');pause(0.1);
    LCsetVDIV(lc,chanstr,vdiv*2);pause(0.1)
    lcclsw(lc);pause(0.5);
    [wfx,wfy]= LCreadwf(lc,chanstr);
    vpk = range(wfy);
    vdiv=LCgetVDIV(lc,chanstr);pause(0.1)
    end
    
    if vdiv <= 2.00E-3
      vdiv = 2.00E-3;
      LCsetVDIV(lc,chanstr,vdiv);
      return
    end
    
    vdiv = vpk/7.5;
    LCsetVDIV(lc,chanstr,vdiv);
    
end