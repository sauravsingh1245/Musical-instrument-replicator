function [ note ] = noterecord( time )

% records sound for 'time' seconds

recorder=audiorecorder(44100,24,1);
record(recorder,time);
pause(time+0.1);
note=getaudiodata(recorder);

end

