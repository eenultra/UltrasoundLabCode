function varargout = GUI_Simple(varargin)
% GUI_SIMPLE MATLAB code for GUI_Simple.fig
%      GUI_SIMPLE, by itself, creates a new GUI_SIMPLE or raises the existing
%      singleton*.
%
%      H = GUI_SIMPLE returns the handle to a new GUI_SIMPLE or the handle to
%      the existing singleton*.
%
%      GUI_SIMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SIMPLE.M with the given input arguments.
%
%      GUI_SIMPLE('Property','Value',...) creates a new GUI_SIMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Simple_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Simple_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Simple

% Last Modified by GUIDE v2.5 16-Oct-2012 16:35:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Simple_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Simple_OutputFcn, ...
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


% --- Executes just before GUI_Simple is made visible.
function GUI_Simple_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Simple (see VARARGIN)

% Choose default command line output for GUI_Simple
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.PRF_box,'String','100');
set(handles.Time_box,'String','2');
set(handles.Dur_box,'String','10');
set(handles.PowLevel_box,'String','100');

% UIWAIT makes GUI_Simple wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Simple_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function Time_box_Callback(hObject, eventdata, handles)
% hObject    handle to Time_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Time_box as text
%        str2double(get(hObject,'String')) returns contents of Time_box as a double


% --- Executes during object creation, after setting all properties.
function Time_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Time_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function PRF_box_Callback(hObject, eventdata, handles)
% hObject    handle to PRF_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PRF_box as text
%        str2double(get(hObject,'String')) returns contents of PRF_box as a double


% --- Executes during object creation, after setting all properties.
function PRF_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PRF_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Dur_box_Callback(hObject, eventdata, handles)
% hObject    handle to Dur_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of Dur_box as text
%        str2double(get(hObject,'String')) returns contents of Dur_box as a double


% --- Executes during object creation, after setting all properties.
function Dur_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dur_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Power_Callback(hObject, eventdata, handles)
% hObject    handle to Power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Power_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in CommsTest_button.
function CommsTest_button_Callback(hObject, eventdata, handles)
% hObject    handle to CommsTest_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LF_Comms_Test;


% --- Executes on button press in ComSelect_button.
function ComSelect_button_Callback(hObject, eventdata, handles)
% hObject    handle to ComSelect_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.Com_Sel,'String');
Serial_Port = contents{get(handles.Com_Sel,'Value')};
LF_OpenSerial;


% --- Executes on selection change in Com_Sel.
function Com_Sel_Callback(hObject, eventdata, handles)
% hObject    handle to Com_Sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Com_Sel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Com_Sel


% --- Executes during object creation, after setting all properties.
function Com_Sel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Com_Sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ConfigSys_button.
function ConfigSys_button_Callback(hObject, eventdata, handles)

h_selectedF   = get(handles.TransSelect,'SelectedObject');
Freq_RadioTag = get(h_selectedF,'tag');

switch Freq_RadioTag
    case 'OneMHz_radio'
        F     = 1.0E6;
        Fname = 'PRE_one';
        Bw    = 0.80;
    case 'TwoMHz_radio'
        F     = 2.2E6;
        Fname = 'PRE_two';
        Bw    = 0.80;
        corr  = 0;
    case 'FiveMHz_radio'
        F = 5.0E6;
        Fname = 'PRE_five';
        Bw    = 0.80;
        corr  = 1;
end

Duration = str2double(get(handles.Dur_box,'String'));
Duration = Duration * 1e-6;

if (Duration > 20e-6)
    Duration = 20e-6;
    set(handles.Dur_box,'String','20');
end

[PWM s_t] = UARP_PWM(F, 0, Duration, 4, 'None');

L = length(s_t);

h_selectedP    = get(handles.ExpType,'SelectedObject');
Ptype_RadioTag = get(h_selectedP,'tag');

switch Ptype_RadioTag
    case 'Tn_radio'
        B         = 0;
        Amplitude = str2double(get(handles.PowLevel_box,'String'));
        Window    = (Amplitude/100)*ones(L,1);
        level     = 5;
    case 'Ch_radio'
        B        = F*Bw;
        filename = [cd '\' Fname '.mat'];
        eval('load(filename)')
        yi = interp(Pre_win,100);
        Pre_len = length(yi); 
        pre_enhancement_window = decimate(yi,round(Pre_len/L));
        pre_enhancement_window = pre_enhancement_window(1:L)/max(pre_enhancement_window(1:L));
        Amplitude = str2double(get(handles.PowLevel_box,'String'));
        Window = (Amplitude/100)*pre_enhancement_window'; 
        level = 4 + corr;
end

[PWM s_t] = UARP_PWM(F, B, Duration, level, 'User', Window);

LF_AWG_Clear;
LF_AWG_Load ( PWM );

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

PRF = str2double(get(handles.PRF_box,'String'));

LF_Set_PRF(PRF);
LF_nShdn;

% hObject    handle to ConfigSys_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in Estart_button.
function Estart_button_Callback(hObject, eventdata, handles)
% hObject    handle to Estart_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time = str2double(get(handles.Time_box,'String'));
LF_Pulse_PRF;
pause(time);  % pause for time
LF_Comms_Test; % stop pulsing

% --- Executes on button press in Estop_button.
function Estop_button_Callback(hObject, eventdata, handles)
% hObject    handle to Estop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LF_Comms_Test;

% --- Executes on button press in TransON_button.
function TransON_button_Callback(hObject, eventdata, handles)
% hObject    handle to TransON_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LF_Pulse_PRF;

% --- Executes on button press in TransOFF_button.
function TransOFF_button_Callback(hObject, eventdata, handles)
% hObject    handle to TransOFF_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LF_Comms_Test;

% --- Executes on key press with focus on Power and none of its controls.
function Power_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Power (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

function PowLevel_box_Callback(hObject, eventdata, handles)
% hObject    handle to PowLevel_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PowLevel_box as text
%        str2double(get(hObject,'String')) returns contents of PowLevel_box as a double

% --- Executes during object creation, after setting all properties.
function PowLevel_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PowLevel_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when selected object is changed in TransSelect.
function TransSelect_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in TransSelect 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

% switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
%     case 'OneMHz_radio'
%         Fc = 1.0E6;
%     case 'TwoMHz_radio'
%         Fc = 2.2E6;
%     case 'FiveMHz_radio'
%         Fc = 5.0E6;
% end


% --- Executes when selected object is changed in ExpType.
function ExpType_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in ExpType 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

% switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
%     case 'Tn_radio'
%         Bw = 0;
%     case 'Ch_radio'
%         Bw = 0.8;
% end
