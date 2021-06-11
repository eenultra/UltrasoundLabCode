% --- Executes during object creation, after setting all properties.
function interestingObjectUIPanel_CreateFcn(hObject, eventdata,handles)
% hObject handle to interestingObjectUIPanel (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles empty - handles not created until after all CreateFcns called

global MYDATA;

switch MYDATA.preferences.interestingObjectBoxColour
    case '-r'
        set(handles.redInterestingObjectRadioButton,'Value',1)
    case '-g'
        set(handles.greenInterestingObjectRadioButton,'Value',1)
    case '-b'
        set(handles.blueInterestingObjectRadioButton,'Value',1)
    case '-c'
        set(handles.cyanInterestingObjectRadioButton,'Value',1)
    case '-y'
        set(handles.yellowInterestingObjectRadioButton,'Value',1)
    case '-m'
        set(handles.magentaInterestingObjectRadioButton,'Value',1)
    case '-k'
        set(handles.blackInterestingObjectRadioButton,'Value',1)
    case '-w'
        set(handles.whiteInterestingObjectRadioButton,'Value',1)
end