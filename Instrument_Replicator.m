function varargout = Instrument_Replicator(varargin)
% INSTRUMENT_REPLICATOR MATLAB code for Instrument_Replicator.fig
%      INSTRUMENT_REPLICATOR, by itself, creates a new INSTRUMENT_REPLICATOR or raises the existing
%      singleton*.
%
%      H = INSTRUMENT_REPLICATOR returns the handle to a new INSTRUMENT_REPLICATOR or the handle to
%      the existing singleton*.
%
%      INSTRUMENT_REPLICATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INSTRUMENT_REPLICATOR.M with the given input arguments.
%
%      INSTRUMENT_REPLICATOR('Property','Value',...) creates a new INSTRUMENT_REPLICATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Instrument_Replicator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Instrument_Replicator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Instrument_Replicator

% Last Modified by GUIDE v2.5 12-Jun-2017 23:48:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Instrument_Replicator_OpeningFcn, ...
                   'gui_OutputFcn',  @Instrument_Replicator_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Instrument_Replicator is made visible.
function Instrument_Replicator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Instrument_Replicator (see VARARGIN)

% Choose default command line output for Instrument_Replicator
handles.output = hObject;


handles.note_unwindowed=audioread('BC_1.m4a');
l=length(handles.note_unwindowed)/44100;
fs=44100;
t=(0:1/fs:l-1/fs);
plot(t,handles.note_unwindowed);
ylabel('Amplitude -->');
xlabel('Time (sec) -->');
title('Example Recorded Waveform for Flute (C note) [261.626 Hz]');
[handles.pks,handles.locs,handles.drate,handles.ipwave,handles.ipfft]=analyze_note(handles.note_unwindowed);
handles.center_freq=261.626;
new_loc=(handles.locs/261.626)*handles.center_freq;
handles.opwave=generate_note(new_loc,handles.pks,44100,handles.drate);
handles.opfft=abs(fft(handles.opwave,44100));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Instrument_Replicator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Instrument_Replicator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time=2;
fs=44100;
t=(0:1/fs:time-1/fs);
handles.note_unwindowed=noterecord(time);
plot(t,handles.note_unwindowed);
ylabel('Amplitude -->');
xlabel('Time (sec) -->');
title('Recorded Waveform');
guidata(hObject, handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=get(hObject, 'String');
val=get(hObject, 'Value');
fs=44100;
t=(0:1/fs:1-1/fs);
switch str{val}
    case 'Input Waveform'
        plot(t,handles.ipwave);
        ylabel('Amplitude -->');
        xlabel('Time (sec) -->');
        title('Input Waveform [261.626 Hz]');
    case 'Input FFT'
        plot(handles.ipfft(1:end/12));
        ylabel('Amplitude -->');
        xlabel('Frequency (Hz) -->');
        title('FFT of Input Waveform [261.626 Hz]');
    case 'Output Waveform'
        plot(t,handles.opwave);
        ylabel('Amplitude -->');
        xlabel('Time (sec) -->');
        title(['Output Waveform [' num2str(handles.center_freq) ' Hz]']);
    case 'Output FFT'
        plot(handles.opfft(1:end/12));
        ylabel('Amplitude -->');
        xlabel('Frequency (Hz) -->');
        title(['FFT of Output Waveform [' num2str(handles.center_freq) ' Hz]']);
end;
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.pks,handles.locs,handles.drate,handles.ipwave,handles.ipfft]=analyze_note(handles.note_unwindowed);
guidata(hObject, handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
new_loc=(handles.locs/261.626)*handles.center_freq;
handles.opwave=generate_note(new_loc,handles.pks,44100,handles.drate);
handles.opfft=abs(fft(handles.opwave,44100));
sound(handles.opwave,44100);
guidata(hObject, handles);    

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=get(hObject, 'String');
val=get(hObject, 'Value');
switch str{val}
    case 'C'
        handles.center_freq=261.626;
    case 'C#'
        handles.center_freq=277.183;
    case 'D'
        handles.center_freq=293.665;
    case 'D#'
        handles.center_freq=311.127;
    case 'E'
        handles.center_freq=329.628;
    case 'F'
        handles.center_freq=349.228;
    case 'F#'
        handles.center_freq=369.994;
    case 'G'
        handles.center_freq=391.995;
    case 'G#'
        handles.center_freq=415.305;
    case 'A'
        handles.center_freq=440.000;
    case 'A#'
        handles.center_freq=466.164;
    case 'B'
        handles.center_freq=493.883;
    case 'C5'
        handles.center_freq=523.251;
    otherwise
        handles.center_freq=261.626;
end;
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
