function varargout = signalviewergui(varargin)
%SIGNALVIEWERGUI M-file for signalviewergui.fig
%      SIGNALVIEWERGUI, by itself, creates a new SIGNALVIEWERGUI or raises the existing
%      singleton*.
%
%      H = SIGNALVIEWERGUI returns the handle to a new SIGNALVIEWERGUI or the handle to
%      the existing singleton*.
%
%      SIGNALVIEWERGUI('Property','Value',...) creates a new SIGNALVIEWERGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to signalviewergui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SIGNALVIEWERGUI('CALLBACK') and SIGNALVIEWERGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SIGNALVIEWERGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help signalviewergui

% Last Modified by GUIDE v2.5 19-Feb-2019 01:40:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @signalviewergui_OpeningFcn, ...
                   'gui_OutputFcn',  @signalviewergui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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
function axes1_CreateFcn(hObject,eventdata,handles)
guidata(hObject,handles);
% --- Executes just before signalviewergui is made visible.
function signalviewergui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for signalviewergui
handles.output = hObject;
handles.file= 0;
handles.scaling= 1;
handles.scale_checker_old=1;
handles.scale_checker_new=1;
axes(handles.axes1);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes signalviewergui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = signalviewergui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes during object creation, after setting all properties.
function signalName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signalName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
guidata(hObject,handles);



% --- Executes on button press in applyMode.
function applyMode_Callback(hObject, eventdata, handles)
% hObject    handle to applyMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in play_toggle.
function play_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to play_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.on_screen=zeros(floor((size(handles.signal,1)/handles.scaling)),1);

if handles.scale_checker_new~=handles.scale_checker_old
    handles.current=1;
    handles.indep_current=1;
end
handles.scale_checker_old=handles.scaling;
handles.button_state = get(hObject,'Value');
if (handles.mode==2)
    handles.button_state = get(hObject,'Value');
    set(handles.listbox,'String','Initializing Dynamic Mode');
while (handles.current<size(handles.signal,1) && handles.button_state == get(hObject,'Max'))
    handles.button_state = get(hObject,'Value');
    
    handles.on_screen(handles.indep_current,1)=handles.signal(handles.current,1);
    plot(handles.on_screen);
    handles.current=handles.current+1;
    handles.indep_current=handles.indep_current+1;
    drawnow limitrate
end
handles.button_state = get(hObject,'Value');
if (handles.button_state == get(hObject,'Min'))
    plot(handles.on_screen);
end
elseif (handles.mode==1)
    set(handles.previous,'Enable','on');
    set(handles.next,'Enable','on');
    set(handles.listbox,'String','Initializing Static Mode');
    %You need to figure out how to plot
    %handles.signal(sliderValue-(sliderValue/2)):sliderValue+(sliderValue/2),1)
    %and to move this plot to the slider callback function
    %also figure out how to insert the scaling to the static mode
    plot(handles.signal);
end

guidata(hObject,handles);




% Hint: get(hObject,'Value') returns toggle state of play_toggle


% --- Executes on selection change in modeMenu.
function modeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to modeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mode_index=get(handles.modeMenu,'Value');
handles.mode_options=get(handles.modeMenu,'String');
handles.mode_string=handles.mode_options{handles.mode_index};
if(strcmp(handles.mode_string,'Static'))
    set(handles.listbox,'String','Static Mode');
    handles.mode=1;
elseif(strcmp(handles.mode_string,'Dynamic'))
    set(handles.listbox,'String','Dynamic Mode');
handles.mode=2;
handles.on_screen_sum=zeros(size(handles.signal,1),1);
end
if (~strcmp(handles.mode,'Pick your mode'))
    if(handles.file~=0)
    set(handles.play_toggle,'Value',0);
    set(handles.play_toggle,'Enable','on');
    end
else
    set(handles.play_toggle,'Enable','off');
    set(handles.play_toggle,'Value',0); 
end
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns modeMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from modeMenu


% --- Executes during object creation, after setting all properties.
function modeMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ylabel_edit_text_Callback(hObject, eventdata, handles)
% hObject    handle to ylabel_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ylabel=get(hObject,'String');
set(handles.ylabel,'String',ylabel);
% Hints: get(hObject,'String') returns contents of ylabel_edit_text as text
%        str2double(get(hObject,'String')) returns contents of ylabel_edit_text as a double


% --- Executes during object creation, after setting all properties.
function ylabel_edit_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylabel_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xlabel_edit_text_Callback(hObject, eventdata, handles)
% hObject    handle to xlabel_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xlabel=get(hObject,'String');
set(handles.xlabel,'String',xlabel);
% Hints: get(hObject,'String') returns contents of xlabel_edit_text as text
%        str2double(get(hObject,'String')) returns contents of xlabel_edit_text as a double


% --- Executes during object creation, after setting all properties.
function xlabel_edit_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlabel_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function signalName_edit_text_Callback(hObject, eventdata, handles)
% hObject    handle to signalName_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
title=get(hObject,'String');
set(handles.signalName,'String',title);
% Hints: get(hObject,'String') returns contents of signalName_edit_text as text
%        str2double(get(hObject,'String')) returns contents of signalName_edit_text as a double


% --- Executes during object creation, after setting all properties.
function signalName_edit_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signalName_edit_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_button.
function browse_button_Callback(hObject, eventdata, handles)
% hObject    handle to browse_button (see GCBO)
handles.current=1;
handles.indep_current=1;
[handles.file,handles.filename]= uigetfile('*.csv;*.xls;*.xlsx');
if ( handles.file ~= 0)
handles.signal= xlsread([handles.filename,handles.file]);
set(handles.listbox,'String',{handles.file,handles.filename,size(handles.signal,1)});
set(handles.modeMenu,'Enable','on');
set(handles.scalingMenu,'Enable','on');
end
 
guidata(hObject,handles);
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox.
function listbox_Callback(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox


% --- Executes during object creation, after setting all properties.
function listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in scalingMenu.
function scalingMenu_Callback(hObject, eventdata, handles)
% hObject    handle to scalingMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
contents_string=contents{get(hObject,'Value')};
switch contents_string
    case 'x1'
        handles.scaling=1;

    case 'x2'
        handles.scaling=2;
        
    case 'x4'
        handles.scaling=4;
        
    case 'x8'
        handles.scaling=8;
        
    case 'x16'
        handles.scaling=16;
end

handles.on_screen=zeros(floor((size(handles.signal,1)/handles.scaling)),1);
handles.scale_checker_new=handles.scaling;
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns scalingMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from scalingMenu


% --- Executes during object creation, after setting all properties.
function scalingMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scalingMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in previous.
function previous_Callback(hObject, eventdata, handles)
% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
