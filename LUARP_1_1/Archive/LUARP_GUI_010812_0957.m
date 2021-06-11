function varargout = LUARP_GUI(varargin)
% LUARP_GUI M-file for LUARP_GUI.fig
%      LUARP_GUI, by itself, creates a new LUARP_GUI or raises the existing
%      singleton*.
%
%      H = LUARP_GUI returns the handle to a new LUARP_GUI or the handle to
%      the existing singleton*.
%
%      LUARP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LUARP_GUI.M with the given input arguments.
%
%      LUARP_GUI('Property','Value',...) creates a new LUARP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LUARP_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LUARP_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LUARP_GUI

% Last Modified by GUIDE v2.5 08-Jul-2012 14:38:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LUARP_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @LUARP_GUI_OutputFcn, ...
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


% --- Executes just before LUARP_GUI is made visible.
function LUARP_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LUARP_GUI (see VARARGIN)

% Choose default command line output for LUARP_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.Start_Freq_Box,'String','2.25');
set(handles.Stop_Freq_Box,'String','2.25');
set(handles.Duration_Box,'String','10');
set(handles.PRF_Box,'String','100');

% UIWAIT makes LUARP_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LUARP_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Transmit_Pulse_PRF.
function Transmit_Pulse_PRF_Callback(hObject, eventdata, handles)
% hObject    handle to Transmit_Pulse_PRF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LF_Pulse_PRF;

% --- Executes on button press in Transmit_Pulse_Single.
function Transmit_Pulse_Single_Callback(hObject, eventdata, handles)
% hObject    handle to Transmit_Pulse_Single (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LF_Pulse;


function Stop_Freq_Box_Callback(hObject, eventdata, handles)
% hObject    handle to Stop_Freq_Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Stop_Freq_Box as text
%        str2double(get(hObject,'String')) returns contents of Stop_Freq_Box as a double


% --- Executes during object creation, after setting all properties.
function Stop_Freq_Box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stop_Freq_Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Start_Freq_Box_Callback(hObject, eventdata, handles)
% hObject    handle to Start_Freq_Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Start_Freq_Box as text
%        str2double(get(hObject,'String')) returns contents of Start_Freq_Box as a double


% --- Executes during object creation, after setting all properties.
function Start_Freq_Box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Start_Freq_Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Duration_Box_Callback(hObject, eventdata, handles)
% hObject    handle to Duration_Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Duration_Box as text
%        str2double(get(hObject,'String')) returns contents of Duration_Box as a double


% --- Executes during object creation, after setting all properties.
function Duration_Box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Duration_Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PRF_Box_Callback(hObject, eventdata, handles)
% hObject    handle to PRF_Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PRF_Box as text
%        str2double(get(hObject,'String')) returns contents of PRF_Box as a double


% --- Executes during object creation, after setting all properties.
function PRF_Box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PRF_Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Transmit_Settings_Config.
function Transmit_Settings_Config_Callback(hObject, eventdata, handles)
% hObject    handle to Transmit_Settings_Config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Start_Freq = str2double(get(handles.Start_Freq_Box,'String'));
Start_Freq = Start_Freq * 1e6;

Stop_Freq = str2double(get(handles.Stop_Freq_Box,'String'));
Stop_Freq = Stop_Freq * 1e6;

Duration = str2double(get(handles.Duration_Box,'String'));
Duration = Duration * 1e-6;

contents = get(handles.Levels_Sel,'String');
Levels = str2double(contents{get(handles.Levels_Sel,'Value')});

PRF = str2double(get(handles.PRF_Box,'String'));

LF_Send_TX_Defaults(Levels, Start_Freq, Stop_Freq, Duration);

LF_Set_PRF(PRF);

LF_nShdn;



% --- Executes on selection change in Levels_Sel.
function Levels_Sel_Callback(hObject, eventdata, handles)
% hObject    handle to Levels_Sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Levels_Sel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Levels_Sel

% --- Executes during object creation, after setting all properties.
function Levels_Sel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Levels_Sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Comms_Test.
function Comms_Test_Callback(hObject, eventdata, handles)
% hObject    handle to Comms_Test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LF_Comms_Test;

% --- Executes on selection change in Open_Serial_Com.
function Open_Serial_Com_Callback(hObject, eventdata, handles)
% hObject    handle to Open_Serial_Com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Open_Serial_Com contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Open_Serial_Com


% --- Executes during object creation, after setting all properties.
function Open_Serial_Com_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Open_Serial_Com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Open_Serial_Setup.
function Open_Serial_Setup_Callback(hObject, eventdata, handles)
% hObject    handle to Open_Serial_Setup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.Serial_Com,'String');
Serial_Port = contents{get(handles.Serial_Com,'Value')};
LF_OpenSerial;


% --- Executes on selection change in Serial_Com.
function Serial_Com_Callback(hObject, eventdata, handles)
% hObject    handle to Serial_Com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Serial_Com contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Serial_Com


% --- Executes during object creation, after setting all properties.
function Serial_Com_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Serial_Com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


