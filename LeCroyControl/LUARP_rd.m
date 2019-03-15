A  = 0.1:0.05:1;
F  = 1.5E6:0.1E6:3.5E6;

PPP = zeros(length(A),length(F));
PNP = zeros(length(A),length(F));

for i=1:length(F)
    for k=1:length(A)

        %load(['LUARP_cal_02Aug12_A' num2str(A(k)) '_dat.mat']);
        load(['LUARP_cal_02Aug12_A' num2str(A(k)) '_F' num2str(F(i)/1E6) 'MHz_dat.mat']);

        PPP(k,i) = max(Pm);
        PNP(k,i) = abs(min(Pm));

    end
end