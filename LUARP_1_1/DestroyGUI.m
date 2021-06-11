function varargout = DestroyGUI(varargin)
% DESTROYGUI MATLAB code for DestroyGUI.fig
%      DESTROYGUI, by itself, creates a new DESTROYGUI or raises the existing
%      singleton*.
%
%      H = DESTROYGUI returns the handle to a new DESTROYGUI or the handle to
%      the existing singleton*.
%
%      DESTROYGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DESTROYGUI.M with the given input arguments.
%
%      DESTROYGUI('Property','Value',...) creates a new DESTROYGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DestroyGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DestroyGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DestroyGUI

% Last Modified by GUIDE v2.5 21-Feb-2014 12:47:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DestroyGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DestroyGUI_OutputFcn, ...
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


% --- Executes just before DestroyGUI is made visible.
function DestroyGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DestroyGUI (see VARARGIN)

% Choose default command line output for DestroyGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles);

% If there is a splash screen for deployed version, kill it since this code
% is now running and is MCR is no longer loading.
if isdeployed
    nameOfExe='mshta.exe';
    dosCmd = ['taskkill /f /im "' nameOfExe '"'];
    display('Close splashscreen (mshta.exe)')
    dos(dosCmd);
end

h1 = errordlg('Program will now connect to LUARP. Please ensure it is powered and the Bluetooth dongle is connected to PC and also powered.','Warning');
uiwait(h1);

%Serial_Port = 'COM1';
%LF_OpenSerial;
%pause(1);
%LF_Comms_Test;

% UIWAIT makes DestroyGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DestroyGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in destInit.
function destInit_Callback(hObject, eventdata, handles)
% hObject    handle to destInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[PWM s_t] = UARP_PWM(2.2E6, 0, 10E-6, 4, 'None');
L         = length(s_t);
Amplitude = handles.powVal;
Window    = (Amplitude/100)*ones(L,1);
level     = 5;
[PWM s_t] = UARP_PWM(2.2E6, 0, 10E-6, level, 'User', Window);

LF_AWG_Clear;
LF_AWG_Load(PWM);

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
LF_Set_PRF(1E3);
LF_nShdn;

msgbox(['LUARP Settings: Frequency 2.2MHz, Power Level ' num2str(Amplitude) '%, Exposure Time ' num2str(handles.time) 's, PRF 1kHz and Burst Length 10us.'],'LUARP Configured','help')


guidata(hObject,handles);

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

sliderValue    = get(handles.slider1,'Value');
handles.powVal = sliderValue;
set(handles.powText, 'String', ['Power Level ' num2str(handles.powVal) ' %']);

if isnan(sliderValue) || (sliderValue <= 0);
    set(handles.slider1,'Value', 10);
    set(handles.powText, 'String', 'Power Level 10 %');
    errordlg('Power must greater than 0 %','Error');
    handles.powVal = 10;
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function sliderText_Callback(hObject, eventdata, handles)
% hObject    handle to sliderText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sliderText as text
%        str2double(get(hObject,'String')) returns contents of sliderText as a double


% --- Executes during object creation, after setting all properties.
function sliderText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function initialize_gui(fig_handle, handles)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

handles.time    = 5;
handles.powVal  = 10;
set(handles.powText, 'String', ['Power Level ' num2str(handles.powVal) ' %']);
set(handles.destDur, 'String',num2str(handles.time));
guidata(handles.figure1, handles);

function destDur_Callback(hObject, eventdata, handles)
% hObject    handle to destDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of destDur as text
%        str2double(get(hObject,'String')) returns contents of destDur as a double
time = str2double(get(hObject, 'String'));
handles.time = time;

if isnan(time) || (time <= 0);
    set(handles.destDur, 'String', '5');
    errordlg('Time must greater than 0 s','Error');
    handles.time = 5;
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function destDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to destDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fireButton.
function fireButton_Callback(hObject, eventdata, handles)
% hObject    handle to fireButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LF_Pulse_PRF;
pause(handles.time);  % pause for time
LF_Comms_Test; % stop pulsing
guidata(hObject,handles);
