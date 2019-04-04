%%
% generates a comb filter prior to processing, should only need to be used
% once. 

%higher drive power it can undergo non-linear oscillation,
%including collapse, and the acoustic emissions generated may comprise broadband
%emissions and superharmonics (nif0), ultraharmonics ((2ni+1)f0/2) and subharmonics
%(f0/ni) of the drive frequency (where ni is a positive integer).

% needs to match param's used in hifuPlot - but run prior as that program
% needs the filters generated here. 

% University of Leeds
% James McLaughlan
% April 2019


N   = 2^16; 
fs  = 250E6;
Nh  = 20;
res = round(fs/N);

% comb filter
f0   = 3.3E6;
df   = 0.20E6;
dIdx = round(df/res);
dUdx = round(df/res);

combF = zeros(N,1);

for i=1:Nh

fIdx = round((f0*i)/res)+1;
fUdx = round(((f0*(2*i+1))/2)/res)+1;

combF(fIdx-dIdx:fIdx+dIdx,1) = 1;
combF(fUdx-dUdx:fUdx+dUdx,1) = 1;

end

ulComb = combF;
bbComb = 1-combF;

save('CombFiltNew.mat','ulComb','bbComb');