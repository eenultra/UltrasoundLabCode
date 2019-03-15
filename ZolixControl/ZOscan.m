% Program moves to XYZ position on stages

function ZOscan(Xpos,Ypos,Zpos)

 [xi yi zi] = Zgetpos(0);
 
 pos = Zmove('X',Xpos-xi,'R',0); % changed 16th Oct 2014 due to problems with system, should be X
 pos = Zmove('Y',Ypos-yi,'R',0);
 pos = Zmove('Z',Zpos-zi,'R',0);
 
 [xf yf zf] = Zgetpos(0);