
agon;

n       = 200;
dat_L   = 50002;
fname   = 'Jef_CHP_Atten_R5_11Jun13';

input('Add bubbles...');pause(20);
invoke(lc,'WriteString',['SEQ ON,' num2str(n) ',' num2str(dat_L-2)],true);
LCsetTRIG(lc,'ARM');
pause(3);
   
[x,y] = LCreadwf(lc,'C2');pause(0.1);
fs    = 1/(x(2) - x(1));
 
t = reshape(x,dat_L,n);
v = reshape(y,dat_L,n);

save(fname,'t','v','fs');

agoff