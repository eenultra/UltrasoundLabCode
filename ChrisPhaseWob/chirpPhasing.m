%Initialise field 2 if required
simargs = chirpFieldInit(2,3*pi);

%You can specify additional delays and apodisation, we don't need this
parFieldPhase(zeros(1,simargs.N_elements),...
    ones(1,simargs.N_elements),simargs);

P = getPressureField(simargs);

P = reshape(P,length(simargs.zpoints),length(simargs.xpoints));

ref = max(P(:));

P = 20*log10(P./ref);

figure(100);
imagesc(P);
caxis([-6 0]);
axis('image');

% figure(101);
% imagesc(simargs.excitations);
% 
% figure(102);
% plotIUSprofile(P, simargs); 

%% Put no wobble and wobble on the same thing
bigWob = load('bigWobble.mat');
bigWob.ref = ref_old;
bigWob.actual = (10.^(bigWob.P/20)).*bigWob.ref;

noWob.P = P;
noWob.ref = ref;
noWob.actual = (10.^(noWob.P/20)).*noWob.ref;

ref_new = max([noWob.actual(:); bigWob.actual(:)]);

bigWob.Q = 20*log10(bigWob.actual./ref_new);
noWob.Q = 20*log10(noWob.actual./ref_new);

figure(103);
subplot(1,2,1);
plotIUSprofile(noWob.Q,simargs);
subplot(1,2,2);
plotIUSprofile(bigWob.Q,simargs);