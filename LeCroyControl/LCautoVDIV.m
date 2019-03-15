function vdiv=LCautoVDIV(lc,chanstr,trigcommand)

% vdiv=LCautoVDIV(chanstr,trigcommand);
% chanstr={'C1', ...,'TA',..}
% trigcommand is an optional argument that will be evaluated to trigger the
% scope if needed
%
% Returns the volts/divsion chosen
%
% Robin Cleveland, May 2006
% Edited by 
% James McLaughlan July 2011

maxdiv=3.85;
mindiv=1.9;
vdivmin=2e-3;
vdivmax=5;

vdiv=LCgetVDIV(lc,chanstr);
%{
%For Serial Connection
fprintf(lc,[chanstr ':OFST?']);
voffset=str2num(fscanf(lc));

fprintf(lc,[chanstr ':ATTN?']);
probeatten=str2num(fscanf(lc));
%}
%For IP/TCP connection
invoke(lc,'WriteString',[chanstr ':OFST?'],true);
voffset=str2double(invoke(lc,'ReadString',100));

invoke(lc,'WriteString',[chanstr ':ATTN?'],true);
probeatten=str2double(invoke(lc,'ReadString',100));

if nargin>2,
    eval(trigcommand);
end

[wfx,wfy]= LCreadwf(lc,chanstr);
vmin=abs(min(wfy)+voffset)/probeatten;
vmax=abs(max(wfy)+voffset)/probeatten;

while ((max(vmin,vmax)<mindiv*vdiv)&&(vdiv>vdivmin)),
    vdiv=max(vdiv/2,vdivmin);
    LCsetVDIV(lc,chanstr,vdiv);
    if nargin>2,
      eval(trigcommand);
    else
      LCwaitAVG(lc,'C');
    end
    [wfx,wfy]= LCreadwf(lc,chanstr);
    vmin=abs(min(wfy)+voffset)/probeatten;
    vmax=abs(max(wfy)+voffset)/probeatten;
    %mindiv*vdiv
end

while ((max(vmin,vmax)>maxdiv*vdiv)&&(vdiv<vdivmax)),
    vdiv=min(vdiv*2,vdivmax);
    LCsetVDIV(lc,chanstr,vdiv);
    if nargin>2,
      eval(trigcommand);
    else
      LCwaitAVG(lc,'C');
    end
    [wfx,wfy]= LCreadwf(lc,chanstr);
    vmin=abs(min(wfy)+voffset)/probeatten;
    vmax=abs(max(wfy)+voffset)/probeatten;  
end


