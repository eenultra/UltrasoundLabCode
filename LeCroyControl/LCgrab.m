%LCsetTRIG(lc,'ARM');pause(10);agon;pause(3);LCgrab;agoff;

agoff

dat_L = 50002;%50002;%25002;%12502 
n     = 200;

t = zeros(dat_L,n);
v = zeros(dat_L,n);

file = 'hcmkr_R3_15Jun12';%'Jef_R3_29Feb12';%JefUV%NoMB

Fname = ['CHP_atten_5MHz_' file];%CHP_scat_5MHz_

desc.date   = date;
desc.txd    = '5MHz unfocused single element';
desc.drive  = '100 mV on Ag, using NL chirp ~Prms = 50 kPa';
desc.info   = '1 mm hydrophone direct into scope';
desc.pulse  = '10us pulse, ARB';


   [x,y]= LCreadwf(lc,'C1');pause(0.1);
    t = reshape(x,dat_L,n);
    v = reshape(y,dat_L,n);
    save([Fname '.mat'],'t','v','desc');