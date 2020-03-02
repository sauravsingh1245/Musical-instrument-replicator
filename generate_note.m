function [ sig ] = generate_note( freq, pks, fs, decay_rate )
% generates sound signal note using the frequency components and their
% amplitudes; optional decay rate for acoustic instruments

peak_length=length(pks);
t=(0:1/fs:1-1/fs)';                                 % generate a time scale for 1 sec @44100 sample rate
sig=zeros(fs,1);                                    % initialize the reconstructed signal

for i=1:peak_length
    sig=sig+pks(i)*sin(2*pi*freq(i)*t);              % add the scaled identified frequency components to the signal
end;

if nargin > 3
    sig=sig.*decay_rate;                                   % decay the signal exponentially
end;

end

