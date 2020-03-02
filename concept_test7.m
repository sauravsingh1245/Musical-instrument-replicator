close all;
clear all;
clc;

n=menu('Select a note','BC_1','HC_1','PC_1','SC_1');
switch n                                            % load the sound
    case 1
        note_unwindowed=audioread('BC_1.m4a');
    case 2
        note_unwindowed=audioread('HC_1.m4a');
    case 3
        note_unwindowed=audioread('PC_1.m4a');
    otherwise
        note_unwindowed=audioread('SC_1.m4a');
end;

temp=find(note_unwindowed > max(note_unwindowed)/10);% identify the signal beginning
note=note_unwindowed(temp(1):end);                  % clip the signal

fs=44100;                                           % set sampling rate
l=length(note);                                     % length of the signal

note_fft=fft(note,fs);                              % calculate 44100 point DFT
note_absfft=abs(note_fft);                          % magnitude of the DFT

normalized_fft=note_absfft/max(note_absfft);        % Normalize the magnitude of the frequency components

[pks,loc]=compute_features(normalized_fft,261.626, 15);
pks=pks/sum(pks);                                           % so that sum of all signals is 1

contour=abs(hilbert(note,fs));
windowsize=500;
decay_rate=filter(ones(1,windowsize)/windowsize,1,contour);

ab=1;
while ab
    ab=input('Press Key: 1/2/3/4/5/6/7/8/9\nPress 0 to quit\n');
    switch ab
        case 1
            new_center_freq=261.626;
        case 2
            new_center_freq=277.183;
        case 3
            new_center_freq=293.665;
        case 4
            new_center_freq=311.127;
        case 5
            new_center_freq=329.628;
        case 6
            new_center_freq=349.228;
        case 7
            new_center_freq=369.994;
        case 8
            new_center_freq=391.995;
        case 9
            new_center_freq=415.305;
        otherwise
            break;
    end;
    new_loc=(loc/261.626)*new_center_freq;
    s_new=generate_note(new_loc,pks,fs,decay_rate);
    sound(s_new,fs);
end;