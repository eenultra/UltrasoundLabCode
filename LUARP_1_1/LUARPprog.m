function varargout = LUARPprog(varargin)
% LUARPPROG MATLAB code for LUARPprog.fig
%      LUARPPROG, by itself, creates a new LUARPPROG or raises the existing
%      singleton*.
%
%      H = LUARPPROG returns the handle to a new LUARPPROG or the handle to
%      the existing singleton*.
%
%      LUARPPROG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LUARPPROG.M with the given input arguments.
%
%      LUARPPROG('Property','Value',...) creates a new LUARPPROG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LUARPprog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LUARPprog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LUARPprog

% Last Modified by GUIDE v2.5 24-Feb-2014 15:04:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LUARPprog_OpeningFcn, ...
                   'gui_OutputFcn',  @LUARPprog_OutputFcn, ...
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


% --- Executes just before LUARPprog is made visible.
function LUARPprog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LUARPprog (see VARARGIN)

% Choose default command line output for LUARPprog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

if isdeployed
    nameOfExe='mshta.exe';
    dosCmd = ['taskkill /f /im "' nameOfExe '"'];
    display('Close splashscreen (mshta.exe)')
    dos(dosCmd);
end

h1 = msgbox('Program will now connect to LUARP. Please ensure it is powered and the Bluetooth dongle is connected to PC and also powered.','PC Connection','help');
uiwait(h1);

%Serial_Port = 'COM1';
LF_OpenSerial;
pause(1);
LF_Comms_Test;

initialize_gui(hObject, handles);

% UIWAIT makes LUARPprog wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = LUARPprog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in configButton.
function configButton_Callback(hObject, eventdata, handles)
% hObject    handle to configButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h_selectedF   = get(handles.transfreqPanel,'SelectedObject');
Freq_RadioTag = get(h_selectedF,'tag');

switch Freq_RadioTag
    case 'oneMbutton'
        F     = 1.0E6;
        Fname = 'PRE_one';
        Bw    = 0.80;
    case 'twoMbutton'
        F     = 2.2E6;
        Fname = 'PRE_two';
        Bw    = 0.80;
        corr  = 0;
    case 'fiveMbutton'
        F = 5.0E6;
        Fname = 'PRE_five';
        Bw    = 0.80;
        corr  = 1;
end

Duration = str2double(get(handles.durText,'String'));
Duration = Duration * 1e-6;

if (Duration > 20e-6)
    Duration = 20e-6;
    set(handles.durText,'String','20');
end

[PWM s_t] = UARP_PWM(F, 0, Duration, 4, 'None');

L = length(s_t);

h_selectedP    = get(handles.exptypePanel,'SelectedObject');
Ptype_RadioTag = get(h_selectedP,'tag');

switch Ptype_RadioTag
    case 'toneButton'
        B         = 0;
        Amplitude = str2double(get(handles.powText,'String'));
        Window    = (Amplitude/100)*ones(L,1);
        level     = 5;
    case 'chirpButton'
        B        = F*Bw;
        filename = [cd '\' Fname '.mat'];
        eval('load(filename)')
        yi = interp(Pre_win,100);
        Pre_len = length(yi); 
        pre_enhancement_window = decimate(yi,round(Pre_len/L));
        pre_enhancement_window = pre_enhancement_window(1:L)/max(pre_enhancement_window(1:L));
        Amplitude = str2double(get(handles.powText,'String'));
        Window = (Amplitude/100)*pre_enhancement_window'; 
        level = 4 + corr;
end

[PWM s_t] = UARP_PWM(F, B, Duration, level, 'User', Window);

LF_AWG_Clear;
LF_AWG_Load (PWM);

% Enable sw_en
sw_en_bitmask = bin2dec('00000001');
LF_Send_Command(15, 1, sw_en_bitmask)
LF_Send_Command(0, 1, 0);    % Configure Cordic
% 
LF_nShdn;

Command = 16;
Channel = 1;
Data    = (bin2dec('11111111'));

LF_Send_Command(Command, Channel, Data); % select transmitter function

PRF = str2double(get(handles.prfText,'String'));

LF_Set_PRF(PRF);
LF_nShdn;

exptime = str2double(get(handles.timeText,'String'));
msgbox(['LUARP Settings: Frequency ' num2str(F/1E6) 'MHz, Power Level ' num2str(Amplitude) '%, Exposure Time ' num2str(exptime) 's, PRF ' num2str(PRF) 'Hz and Duration ' num2str(Duration*1E6) 'us.'],'LUARP Configured','help')

guidata(hObject,handles);

% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time = str2double(get(handles.timeText,'String'));
LF_Pulse_PRF;
pause(time);  % pause for time
LF_Comms_Test; % stop pulsing

% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LF_Comms_Test;

% --- Executes on button press in tonButton.
function tonButton_Callback(hObject, eventdata, handles)
% hObject    handle to tonButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LF_Pulse_PRF;

% --- Executes on button press in toffButton.
function toffButton_Callback(hObject, eventdata, handles)
% hObject    handle to toffButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LF_Comms_Test;


function timeText_Callback(hObject, eventdata, handles)
% hObject    handle to timeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeText as text
%        str2double(get(hObject,'String')) returns contents of timeText as a double
T1 = str2double(get(hObject,'String'));
if isnan(T1) || (T1 <= 0)
    errordlg('Exposure time should be longer than 0s','Error');
    set(hObject,'String','5');
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function timeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function prfText_Callback(hObject, eventdata, handles)
% hObject    handle to prfText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
P1 = str2double(get(hObject,'String'));
if isnan(P1) || (P1 <= 0)
    errordlg('PRF needs to be greater than 0 Hz','Error');
    set(hObject,'String','100');
end
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of prfText as text
%        str2double(get(hObject,'String')) returns contents of prfText as a double


% --- Executes during object creation, after setting all properties.
function prfText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prfText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function durText_Callback(hObject, eventdata, handles)
% hObject    handle to durText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of durText as text
%        str2double(get(hObject,'String')) returns contents of durText as a double
D1 = str2double(get(hObject,'String'));
if isnan(D1) || (D1 <= 0)
    errordlg('Duration should be greater than 0us','Error');
    set(hObject,'String','10');
end

if (D1 > 20)
    errordlg('Duration should be less than 20us','Error');
    set(hObject,'String','10');
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function durText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to durText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function powText_Callback(hObject, eventdata, handles)
% hObject    handle to powText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of powText as text
%        str2double(get(hObject,'String')) returns contents of powText as a double
P1 = str2double(get(hObject,'String'));
if isnan(P1) || (P1 <= 0)
    errordlg('Power Level should be greater than 0 %','Error');
    set(hObject,'String','100');
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function powText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to powText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in comTestButton.
function comTestButton_Callback(hObject, eventdata, handles)
% hObject    handle to comTestButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LF_Comms_Test;

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in toneButton.
function toneButton_Callback(hObject, eventdata, handles)
% hObject    handle to toneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toneButton


% --- Executes on button press in chirpButton.
function chirpButton_Callback(hObject, eventdata, handles)
% hObject    handle to chirpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of chirpButton

function initialize_gui(fig_handle, handles)

set(handles.prfText,'String','1000');
set(handles.timeText,'String','5');
set(handles.durText,'String','10');
set(handles.powText,'String','100');

set(handles.oneMbutton,'Value',0);
set(handles.twoMbutton,'Value',1);
set(handles.fiveMbutton,'Value',0);

guidata(handles.figure1, handles);

% --- Executes during object creation, after setting all properties.
function exptypePanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exptypePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function transfreqPanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transfreqPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected object is changed in transfreqPanel.
function transfreqPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in transfreqPanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
selected1      = get(handles.exptypePanel,'SelectedObject');
selectedTag1   = get(selected1,'tag');
C1            = strcmp('chirpButton',selectedTag1);
selected2     = get(handles.transfreqPanel,'SelectedObject');
selectedTag2  = get(selected2,'tag');
C2            = strcmp('oneMbutton',selectedTag2);

if C1 == 1 && C2 == 1
    errordlg('Chirp for 1MHz transducer not implemented, please select another.','Error');
    set(handles.chirpButton,'Value',0);
    set(handles.toneButton,'Value',1);
end

guidata(hObject,handles);

% --- Executes when selected object is changed in exptypePanel.
function exptypePanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in exptypePanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
selected3      = get(handles.exptypePanel,'SelectedObject');
selectedTag3   = get(selected3,'tag');
C1            = strcmp('chirpButton',selectedTag3);
selected4      = get(handles.transfreqPanel,'SelectedObject');
selectedTag4   = get(selected4,'tag');
C2            = strcmp('oneMbutton',selectedTag4);

if C1 == 1 && C2 == 1
    errordlg('Chirp for 1MHz transducer not implemented, please select another.','Error');
    set(handles.chirpButton,'Value',0);
    set(handles.toneButton,'Value',1);
end

guidata(hObject,handles);



