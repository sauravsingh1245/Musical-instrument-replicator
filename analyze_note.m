function [ pks,locs,decay_rate,note,note_absfft ] = analyze_note( note_unwindowed )
% analyze and compute fft

fs=44100;                                           % set sampling rate

temp=find(note_unwindowed > max(note_unwindowed)/10);% identify the signal beginning
note=note_unwindowed(temp(1):temp(1)+44099);                  % clip the signal

note_fft=fft(note,fs);                              % calculate 44100 point DFT
note_absfft=abs(note_fft);                          % magnitude of the DFT

normalized_fft=note_absfft/max(note_absfft);        % Normalize the magnitude of the frequency components

[pks,locs]=compute_features(normalized_fft,261.626, 15);
pks=pks/sum(pks);                                           % so that sum of all signals is 1

contour=abs(hilbert(note,fs));
windowsize=500;
decay_rate=filter(ones(1,windowsize)/windowsize,1,contour);

end

