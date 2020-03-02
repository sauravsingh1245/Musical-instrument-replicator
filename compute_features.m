function [ pks,locs ] = compute_features( normalized_fft, base_freq, N )
% normalized_fft = normalized magnitude of fft of note signal
% base_freq      = base frequency of the input node
% N              = number of Harmonics to be considered

pks=zeros(1,N);
locs=zeros(1,N);

bf=round(base_freq)*(1:1:N);
for i=1:N
    pks(i)=max(normalized_fft(bf(i)-10:bf(i)+10));
end;
locs=base_freq*(1:1:N);

end