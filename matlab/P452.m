function varargout = P452(varargin)
%P452 M-file for P452.fig
%      This is a GUI for the function tl_p452.m that computes the basic 
%      transmission loss not exceeded for p% of time as defined in 
%      ITU-R P.452-18.
%
%      P452, by itself, creates a new P452 or raises the existing
%      singleton*.
%
%      H = P452 returns the handle to a new P452 or the handle to
%      the existing singleton*.
%
%      P452('Property','Value',...) creates a new P452 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to P452_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      P452('CALLBACK') and P452('CALLBACK',hObject,...) call the
%      local function named CALLBACK in P452.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% Rev   Date        Author                     Description
%-------------------------------------------------------------------------------
% v1    04MAR16     Ivica Stevanovic, OFCOM    Initial Stable Version
% v2    01JUN16     Ivica Stevanovic, OFCOM    Cleaned the code
% v3    13FEB20     Ivica Stevanovic, OFCOM    Introduced 3D distance in Free-space calculation
% v4    13JUL21     Ivica Stevanovic, OFCOM    Renamed subfolder "src" into "private" which is by default in the MATLAB search path
%                                              (as suggested by K. Konstantinou, Ofcom UK)  
%                                              Changed the starting point in transmission loss vs distance to make sure there are at least three points
%                                              between clutter at the Tx and Rx sides 
% v5    08OCT21     Ivica Stevanovic, OFCOM    Ensured that series is a row vector in find_intervals.m 
% v6    24MAR22     Ivica Stevanovic, OFCOM    Introduced path center latitude as input argument instead of Tx/Rx latitudes
% v7    15NOV23     Ivica Stevanovic, OFCOM    Aligned with ITU-R P.452-18
% 

% MATLAB Version 9.12.0.1975300 (R2022a) Update 3 used in development of this code
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
% IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
% OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
% OTHER DEALINGS IN THE SOFTWARE.
%
% THE AUTHORS AND OFCOM (CH) DO NOT PROVIDE ANY SUPPORT FOR THIS SOFTWARE
%
% The functions that GUI calls are placed in the ./private folder
% Test functions to verify/validate the current implementation are also placed
% in ./private folder
%
% Edit the above text to modify the response to help P452

% Last Modified by GUIDE v2.5 18-Jul-2023 09:55:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @P452_OpeningFcn, ...
    'gui_OutputFcn',  @P452_OutputFcn, ...
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


% --- Executes just before P452 is made visible.
function P452_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for P452
handles.output = hObject;

% define the input data structure
handles.p452 = [];
handles.p452.path.d = [];
handles.p452.path.h = [];
handles.p452.path.r = [];
handles.p452.path.g = [];
handles.p452.path.zone = [];

handles.p452.filename={};
handles.p452.pathname={};

handles.p452.dtot = [];
handles.p452.f = [];
handles.p452.p = [];

handles.p452.htg = [];
handles.p452.Gt = [];
handles.p452.phit_e = [];
handles.p452.phit_n = [];

handles.p452.hrg = [];
handles.p452.Gr = [];
handles.p452.phir_e = [];
handles.p452.phir_n = [];

handles.p452.DN = [];
handles.p452.N0 = [];
handles.p452.press = [];
handles.p452.temp = [];



handles.p452.dct = 500;
handles.p452.dcr = 500;


handles.p452.titleFontSize = 8;
handles.p452.ParameterChange = false;

d = cell(18,2);
d{1,1} = 'Profile';
d{1+1,1} = 'ae';
d{1+2,1} = 'd';
d{1+3,1} = 'hts';
d{1+4,1} = 'hrs';
d{1+5,1} = 'theta_t';
d{1+6,1} = 'theta_r';
d{1+7,1} = 'theta';
d{1+8,1} = 'hst';
d{1+9,1} = 'hsr';
d{1+10,1} = 'hm';
d{1+11,1} = 'hte';
d{1+12,1} = 'hre';
d{1+13,1} = 'hstd';
d{1+14,1} = 'hsrd';
d{1+15,1} = 'dlt';
d{1+16,1} = 'dlr';
d{1+17,1} = 'path type';
d{1+18,1} = 'dtm';
d{1+19,1} = 'dlm';
d{1+20,1} = 'beta0';
d{1+21,1} = 'w';

set(handles.profileParameters,'Data',d);
set(handles.profileParameters,'FontSize',handles.p452.titleFontSize);

d1{1,1} = 'Lbfsg';
d1{2,1} = 'Lb0p';
d1{3,1} = 'Lb0b';
d1{4,1} = 'Lbulla';
d1{5,1} = 'Lbulls';
d1{6,1} = 'Ldsph';
d1{7,1} = 'Ld';
d1{8,1} = 'Lbs';
d1{9,1} = 'Lba';



set(handles.tableLoss,'Data',d1);
set(handles.tableLoss,'FontSize',handles.p452.titleFontSize);

set(handles.axes1,'Visible','off')
set(handles.radiobutton12,'Value',1);
set(handles.radiobutton2,'Value',0);
set(handles.dtot,'Enable','off');
set(handles.LoadProfile,'Enable','on');

%get(handles.text0)
%h = text(0.0, 0.0, 'hoi')

% Set the font size to all the objects

h = findobj(hObject, '-property', 'FontSize');
set(h,'FontSize',handles.p452.titleFontSize);

%set(gcf, 'Renderer', 'opengl'); %mirrors (left/right, top/bottom) the figure in the first plot choice (not in the others?)
%set(gcf, 'Renderer', 'painter'); % patches sometimes plotted over the title
% s = pwd;
% if ~exist('p676_ga.m','file')
%     addpath([s '/src/'])
% end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes P452 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = P452_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in ChoosePolarization.
function ChoosePolarization_Callback(hObject, eventdata, handles)
% hObject    handle to ChoosePolarization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ChoosePolarization contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ChoosePolarization

contents=cellstr(get(hObject,'String'));
userChoiceInt = get(hObject,'Value');
userChoice=contents{userChoiceInt};

handles.p452.ParameterChange = true;
try
    handles.p452.polarization = userChoiceInt-1;
    
    guidata(hObject, handles);
catch
    warning('Dataset menu corrupted.')
end


% --- Executes during object creation, after setting all properties.
function ChoosePolarization_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChoosePolarization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PerformAnalysis.
function PerformAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to PerformAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%% progress bar definition

% % % d = com.mathworks.mlwidgets.dialog.ProgressBarDialog.createProgressBar('PLC Progress...', []);
% % % d.setValue(0.0);                        % default = 0
% % % d.setProgressStatusLabel('Analysing...');  % default = 'Please Wait'
% % % d.setSpinnerVisible(true);               % default = true
% % % d.setCircularProgressBar(false);         % default = false  (true means an indeterminate (looping) progress bar)
% % % d.setCancelButtonVisible(false);          % default = true

% try

if checkInput(hObject, eventdata, handles)
    
    try
        % Apply the condition in Step 4: Radio profile
        % gi is the terrain height in metres above sea level for all the points at a distance from transmitter or receiver less than 50 m.

        kk = find(handles.p452.path.d < 50/1000);
        if (~isempty(kk))
            handles.p452.path.g(kk) = handles.p452.path.h(kk);
        end
        endVal = handles.p452.path.d(end) - 50/1000;
        kk = find(handles.p452.path.d > endVal);
        if (~isempty(kk))
            handles.p452.path.g(kk) = handles.p452.path.h(kk);
        end

        dc = handles.p452.path.d;
        hc = handles.p452.path.h;
        htgc = handles.p452.htg;
        hrgc = handles.p452.hrg;
        
        % Compute  dtm     -   the longest continuous land (inland + coastal) section of the great-circle path (km)
        zone_r = 12;
        
        dtm = longest_cont_dist(handles.p452.path.d, handles.p452.path.zone, zone_r);
        
        % Compute  dlm     -   the longest continuous inland section of the great-circle path (km)
        zone_r = 2;
        
        dlm = longest_cont_dist(handles.p452.path.d, handles.p452.path.zone, zone_r);

        %Tx position is fixed at (handles.p452.phit_e, handles.p452.phit_n)
        %Rx position is determined by the distance handles.p452.path.d(end)
        %and the direction given by 
        % (handles.p452.phit_e, handles.p452.phit_n) --> (handles.p452.phir_e, handles.p452.phir_n)

        % compute great circle path between phir_e,phir_n and phit_e,phit_n
        Re = 6371;
        dpnt = 0;
        [~, ~, ~, dgc] = great_circle_path(handles.p452.phir_e, handles.p452.phit_e, handles.p452.phir_n, handles.p452.phit_n, Re, dpnt);
        
        dpnt = dc(end);
        % compute the latitude and longitude at the end of the path of
        % length d(end) along the great circle path (phit_e,phit_n)-->(phir_e,phir_n)

        [phir_e, phir_n, ~, dgc] = great_circle_path(handles.p452.phir_e, handles.p452.phit_e, handles.p452.phir_n, handles.p452.phit_n, Re, dpnt);
   

        % Calculate the longitude and latitude of the mid-point of the path, phim_e,
        % and phim_n for dpnt = 0.5dt
        Re = 6371;
        dpnt = 0.5*(handles.p452.path.d(end)-handles.p452.path.d(1));
        [phim_e, phim_n, bt2r, dgc] = great_circle_path(phir_e, handles.p452.phit_e, phir_n, handles.p452.phit_n, Re, dpnt);

        % Find radio-refractivity lapse rate dN
        % using the digital maps at phim_e (lon), phim_n (lat) - as a bilinear interpolation

        handles.p452.DN = get_interp2('DN50',phim_e,phim_n);
        handles.p452.N0 = get_interp2('N050',phim_e,phim_n);

        % Compute b0
        b0 = beta0(phim_n, dtm, dlm);

        [ae, ab] = earth_rad_eff(handles.p452.DN);
        
        [hst, hsr, hstd, hsrd, hte, hre, hm, dlt, dlr, theta_t, theta_r, theta, pathtype] = smooth_earth_heights(dc, hc, htgc, hrgc, ae, handles.p452.f);
        
        dtot = dc(end)-dc(1);
        
        %Tx and Rx antenna heights above mean sea level amsl (m)
        hts = hc(1) + htgc;
        hrs = hc(end) + hrgc;
        
        % Compute the path fraction over see
        
        omega = path_fraction(handles.p452.path.d, handles.p452.path.zone, 3);
                
        d = get(handles.profileParameters,'Data');
        
       

        if (~isempty(handles.p452.filename))
            d{1,2} = handles.p452.filename;
        else
            d{1,2} = 'None';
        end
        d{1+1,2} = ae;
        d{1+2,2} = dtot;
        d{1+3,2} = hts;
        d{1+4,2} = hrs;
        d{1+5,2} = theta_t;
        d{1+6,2} = theta_r;
        d{1+7,2} = theta;
        d{1+8,2} = hst;
        d{1+9,2} = hsr;
        d{1+10,2} = hm;
        d{1+11,2} = hte;
        d{1+12,2} = hre;
        d{1+13,2} = hstd;
        d{1+14,2} = hsrd;
        d{1+15,2} = dlt;
        d{1+16,2} = dlr;
        if pathtype == 1
            pathtypestr = 'LoS';
        else
            pathtypestr = 'Tr-horizon';
        end
        d{1+17,2} = pathtypestr;
        d{1+18,2} = dtm;
        d{1+19,2} = dlm;
        d{1+20,2} = b0;
        d{1+21,2} = omega;
        
        set(handles.profileParameters,'Data',d);
        handles.p452.profileParameters = d;

       
        
        % modified with 3-D path for free-space computation

        d3D = sqrt(dtot*dtot + ((hts-hrs)/1000.0).^2);
        
        %[Lbfsg, Lb0p, Lb0b] = pl_los(dtot, ...
        [Lbfsg, Lb0p, Lb0b] = pl_los(d3D, ...
            handles.p452.f, ...
            handles.p452.p, ...
            b0, ...
            omega, ...
            handles.p452.temp, ...
            handles.p452.press,...
            dlt, ...
            dlr);

       
%         % The path length expressed as the angle subtended by d km at the center of
%         % a sphere of effective Earth radius ITU-R P.2001-4 (3.5.4)
% 
%         theta_e = dtot/ae; % radians
% 
%         % Calculate the horizon elevation angles limited such that they are positive
% 
%         theta_tpos = max(theta_t, 0);                   % Eq (3.7.11a) ITU-R P.2001-5
%         theta_rpos = max(theta_r, 0);                   % Eq (3.7.11b) ITU-R P.2001-5
% 
%         [dt_cv, phi_cve, phi_cvn] = tropospheric_path(dtot, hts, hrs, theta_e, theta_tpos, theta_rpos, phir_e, handles.p452.phit_e, phir_n, handles.p452.phit_n, Re);
%         
%         % height of the Earth's surface above sea level where the common volume is located
% 
%         Hs = surface_altitude_cv(hc, dc, dt_cv)/1000.0; % in km
%         
%         [Lbs, theta_s] = tl_troposcatter(handles.p452.f, dtot, hts, hrs, ae, theta_e, theta_t, theta_r, phi_cvn, phi_cve, handles.p452.Gt, handles.p452.Gr, handles.p452.p, Hs);
%         
%         % To avoid under-estimating troposcatter for short paths, limit Lbs (E.17 in ITU-R P.2001-5)
%         % This is included in P.2001-5 but not in P.1812 or P.452
%         % w/o this limit, Lbs can even be negative for short paths
%         % that is why this limit is necessary
%         Lbs = max(Lbs, Lbfsg);

        % Calculate the basic transmission loss due to troposcatter not exceeded
        % for any time percantage p 
        
        Lbs = tl_tropo(dtot, theta, handles.p452.f, handles.p452.p, handles.p452.temp, handles.p452.press, handles.p452.N0, handles.p452.Gt, handles.p452.Gr );
        
        
        Lba = tl_anomalous(dtot, ...
            dlt, ...
            dlr, ...
            handles.p452.dct, ...
            handles.p452.dcr, ...
            dlm, ...
            hts, ...
            hrs, ...
            hte, ...
            hre, ...
            hm, ...
            theta_t, ...
            theta_r, ...
            handles.p452.f, ...
            handles.p452.p, ...
            handles.p452.temp, ...
            handles.p452.press, ...
            omega, ...
            ae, ...
            b0);
        
        Lbulla = dl_bull(handles.p452.path.d, handles.p452.path.g, hts, hrs, ae, handles.p452.f);
        
        % Use the method in 4.2.1 for a second time, with all profile heights hi
        % set to zero and modified antenna heights given by
        
        hts1 = hts - hstd;   % eq (38a)
        hrs1 = hrs - hsrd;   % eq (38b)
        h1 = zeros(size(hc));
        
        % where hstd and hsrd are given in 5.1.6.3 of Attachment 2. Set the
        % resulting Bullington diffraction loss for this smooth path to Lbulls
        
        Lbulls = dl_bull(dc, h1, hts1, hrs1, ae, handles.p452.f);
        
        % Use the method in 4.2.2 to radiomaps the spherical-Earth diffraction loss
        % for the actual path length (dtot) with
        
        hte = hts1;             % eq (39a)
        hre = hrs1;             % eq (39b)
        
        Ldsph = dl_se(dtot, hte, hre, ae, handles.p452.f, omega);
        
        % Diffraction loss for the general path is now given by
        
        Ld(1) = Lbulla + max(Ldsph(1) - Lbulls, 0);  % eq (40)
        Ld(2) = Lbulla + max(Ldsph(2) - Lbulls, 0);  % eq (40)%%
        
        Lb = tl_p452(   handles.p452.f, ...
            handles.p452.p, ...
            handles.p452.path.d, ...
            handles.p452.path.h, ...
            handles.p452.path.g, ...
            handles.p452.path.zone, ...
            handles.p452.htg, ...
            handles.p452.hrg, ...
            handles.p452.phit_e,...
            handles.p452.phit_n,...
            phir_e,...
            phir_n,...
            handles.p452.Gt, ...
            handles.p452.Gr, ...
            handles.p452.polarization, ...
            handles.p452.dct, ...
            handles.p452.dcr, ...
            handles.p452.press, ...
            handles.p452.temp);
        
        d1 = get(handles.tableLoss,'Data');
        
        pol = handles.p452.polarization;
        format = '%.2f';
        d1{1,2} = sprintf(format,Lbfsg);
        d1{2,2} = sprintf(format,Lb0p);
        d1{3,2} = sprintf(format,Lb0b);
        d1{4,2} = sprintf(format,Lbulla);
        d1{5,2} = sprintf(format,Lbulls);
        d1{6,2} = sprintf(format,Ldsph(pol));
        d1{7,2} = sprintf(format,Ld(pol));
        d1{8,2} = sprintf(format,Lbs);
        d1{9,2} = sprintf(format,Lba);

        
        set(handles.tableLoss,'Data',d1);
        handles.p452.tableLoss = d1;
        handles.p452.basicTL = Lb;
        set(handles.basicTL,'String', num2str(Lb));
        guidata(hObject, handles);
        handles.p452.ParameterChange = 0;
        guidata(hObject, handles);
    catch
        warndlg({'Program exited unexpectedly. Check the input parameters.'},'Error');
    end
    
end
return


% --- Executes on selection change in plotResults.
function plotResults_Callback(hObject, eventdata, handles)
% hObject    handle to plotResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotResults contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotResults

contents=cellstr(get(hObject,'String'));
userChoiceInt = get(hObject,'Value');
userChoice=contents{userChoiceInt};
ax = handles.axes1;




if userChoiceInt == 1
    %set(handles.popupUserDensities,'Visible','off');
    ax = handles.axes1;
    RemoveAxes(ax);
    
    
    guidata(hObject, handles);
    
    
elseif userChoiceInt == 2
    %set(handles.popupUserDensities,'Visible','off');
    plotSemaphores(hObject, eventdata, handles)
    
    return
    
    
elseif userChoiceInt ==3 %as a function of power density
    
    RemoveAxes(handles.axes1);
    
    %uistack(handles.axes1, 'top')
    
    ax = handles.axes1;
    
    axis(ax);
    cla(ax,'reset');
    hold(ax, 'off');
    zoom(ax,'reset');
    xlabel(ax,'');
    ylabel(ax,'');
    legend(ax,'hide');
    title(ax,'');
    set(ax,'Visible','on')
    guidata(hObject, handles);
    
    set(ax,'XLimMode','auto');
    set(ax,'YLimMode','auto');
    
    % Compute the basic transmission loss for different distances from the
    % Tx
    
    if ~checkInput(hObject, eventdata, handles)
        return
    end

    % Tx position is at phit_e,phit_n
    % Rx position will be along great circle path in the direction
    % phir_e,phir_n
    
    % compute great circle path between phir_e,phir_n and phit_e,phit_n
    Re = 6371;
    dpnt = 0;
    [~, ~, ~, dgc] = great_circle_path(handles.p452.phir_e, handles.p452.phit_e, handles.p452.phir_n, handles.p452.phit_n, Re, dpnt);


    count = 0;
    for ii = 6:length(handles.p452.path.d)
        d = handles.p452.path.d(1:ii);
        h = handles.p452.path.h(1:ii);
        g = handles.p452.path.g(1:ii);
        zone = handles.p452.path.zone(1:ii);
        
        dpnt = d(end);
        % compute the latitude and longitude at the end of the path of
        % length d(end) along the great circle path (phit_e,phit_n)-->(phir_e,phir_n)

        [phim_e, phim_n, ~, dgc] = great_circle_path(handles.p452.phir_e, handles.p452.phit_e, handles.p452.phir_n, handles.p452.phit_n, Re, dpnt);
   


            Lb = tl_p452(   handles.p452.f, ...
                handles.p452.p, ...
                d, ...
                h, ...
                g, ...
                zone, ...
                handles.p452.htg, ...
                handles.p452.hrg, ...
                handles.p452.phit_e,...
                handles.p452.phit_n,...
                phim_e,...
                phim_n,...
                handles.p452.Gt, ...
                handles.p452.Gr, ...
                handles.p452.polarization, ...
                handles.p452.dct, ...
                handles.p452.dcr, ...
                handles.p452.press, ...
                handles.p452.temp);
            count = count + 1;
            xx(count) = d(end)-d(1);
            yy(count) = Lb;
        %end
    end
    
    axis(ax);
    h=plot(ax,xx,yy,'b','LineWidth',2);
    XLim = [min(xx), max(xx)];
    set(ax,'XLim',XLim);
    xlabel(ax,'distance (km)');
    ylabel(ax,'Basic transmission Loss (dB)');
    title(ax,'');
    grid(ax, 'on');
    %     setAllowAxesZoom(h,handles.axes1,true);
    %
    guidata(hObject, handles);

    return
    

    % Update handles structure
    guidata(hObject, handles);
    
end


% --- Executes during object creation, after setting all properties.
function plotResults_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% function ksi_t_Callback(hObject, eventdata, handles)
% % hObject    handle to ksi_t (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of ksi_t as text
% %        str2double(get(hObject,'String')) returns contents of ksi_t as a double
% in = str2double(get(hObject, 'String'));
% if (isnan(in))
%     warndlg({'Tx tx_longitude must be a number.'});
%     set(hObject,'Foregroundcolor',[1 0 0]);
%     % elseif (in <=0)
%     %     warndlg({'Height must be a positive number.'});
%     %     set(hObject,'Foregroundcolor',[1 0 0]);
% else
%     set(hObject,'Foregroundcolor',[0 0 0]);
% end
% handles.p452.ksi_t = in;
% handles.p452.ParameterChange = true;
% %Update handles structure
% guidata(hObject, handles);



% % --- Executes during object creation, after setting all properties.
% function ksi_t_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to ksi_t (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% 
% 
% 
% function ksi_r_Callback(hObject, eventdata, handles)
% % hObject    handle to ksi_r (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of ksi_r as text
% %        str2double(get(hObject,'String')) returns contents of ksi_r as a double
% in = str2double(get(hObject, 'String'));
% if (isnan(in))
%     warndlg({'Rx tx_longitude must be a number.'});
%     set(hObject,'Foregroundcolor',[1 0 0]);
%     % elseif (in <=0)
%     %     warndlg({'Height must be a positive number.'});
%     %     set(hObject,'Foregroundcolor',[1 0 0]);
% else
%     set(hObject,'Foregroundcolor',[0 0 0]);
% end
% handles.p452.ksi_r = in;
% handles.p452.ParameterChange = true;
% %Update handles structure
% guidata(hObject, handles);



% 
% % --- Executes during object creation, after setting all properties.
% function ksi_r_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to ksi_r (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end



function f_Callback(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f as text
%        str2double(get(hObject,'String')) returns contents of f as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Frequency must be a positive number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in <=0)
    warndlg({'Frequency must be a positive number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.f = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function f_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function htg_Callback(hObject, eventdata, handles)
% hObject    handle to htg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of htg as text
%        str2double(get(hObject,'String')) returns contents of htg as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Tx antenna height value must be a non-negative number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in <0)
    warndlg({'Tx antenna value must be a non-negative number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.htg = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function htg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to htg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function p_Callback(hObject, eventdata, handles)
% hObject    handle to p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p as text
%        str2double(get(hObject,'String')) returns contents of p as a double

in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Time percentage must be a number between 0 and 50.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in <0 | in >50)
    warndlg({'Time percentage must be a number between 0 and 50.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.p = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function alldefined=checkInput(hObject, eventdata, handles)

alldefined=false;
handles.p452

%[handles.p452.path.d handles.p452.path.h handles.p452.path.zone]


if (get(handles.radiobutton2,'Value'))
    if (sum(get(handles.dtot,'Foregroundcolor')) ~= 0)
        warndlg({'Check input parameters: Path distance.'},'Error','modal');
        alldefined=false;
        return
    end
end


if (isempty(handles.p452.filename) & strcmp(get(handles.LoadProfile,'Enable'),'on'))
    warndlg({'Choose a valid Path Profile file.'},'Error','modal');
    alldefined=false;
    return
end

if (isempty(handles.p452.dtot) && get(handles.radiobutton2,'Value'))
    warndlg({'Great-circle path distance has to be defined.'},'Error','modal');
    alldefined=false;
    return
end

if (get(handles.ChoosePolarization,'Value') < 2)
    warndlg({'Choose the EM wave polarization.'},'Error','modal');
    alldefined=false;
    return
end



if (sum(get(handles.f,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameters: Frequency.'},'Error','modal');
    alldefined=false;
    return
end

if (sum(get(handles.p,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameters: Time percentage.'},'Error','modal');
    alldefined=false;
    return
end

if (sum(get(handles.phit_e,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameters: Tx Longitude.'},'Error','modal');
    alldefined=false;
    return
end

if (sum(get(handles.phit_n,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameters: Tx Latitude.'},'Error','modal');
    alldefined=false;
    return
end


if (sum(get(handles.phir_e,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameters: Rx Longitude.'},'Error','modal');
    alldefined=false;
    return
end

if (sum(get(handles.phir_n,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameters: Rx Latitude.'},'Error','modal');
    alldefined=false;
    return
end


if (sum(get(handles.htg,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameters: Tx antenna height.'},'Error','modal');
    alldefined=false;
    return
end


if (sum(get(handles.hrg,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameters: Rx antenna height.'},'Error','modal');
    alldefined=false;
    return
end

if (sum(get(handles.Gt,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameters: Tx antenna gain.'},'Error','modal');
    alldefined=false;
    return
end

if (sum(get(handles.Gr,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameters: Rx antenna gain.'},'Error','modal');
    alldefined=false;
    return
end



if (sum(get(handles.press,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameter: Pressure.'},'Error','modal');
    alldefined=false;
    return
end


if (sum(get(handles.temp,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameter: Temperature.'},'Error','modal');
    alldefined=false;
    return
end


if (sum(get(handles.dct,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameter: dct.'},'Error','modal');
    alldefined=false;
    return
end


if (sum(get(handles.dcr,'Foregroundcolor')) ~= 0)
    warndlg({'Check input parameter: dcr.'},'Error','modal');
    alldefined=false;
    return
end

phir_n = str2double(get(handles.phir_n, 'String'));
phir_e = str2double(get(handles.phir_e, 'String'));
phit_n = str2double(get(handles.phit_n, 'String'));
phit_e = str2double(get(handles.phit_e, 'String'));

if (phit_e==phir_e && phit_n == phir_n)
    warndlg({'Tx and Rx stations cannot be at the same point.'},'Error','modal');
    alldefined=false;
    return
end


if (isempty(handles.p452.f) || ...
        isempty(handles.p452.p) || ...
        isempty(handles.p452.polarization) || ...
        isempty(handles.p452.phit_e) || ...
        isempty(handles.p452.phit_n) || ...
        isempty(handles.p452.phir_e) || ...
        isempty(handles.p452.phir_n) || ...
        isempty(handles.p452.htg) || ...
        isempty(handles.p452.hrg) || ...
        isempty(handles.p452.Gt) || ...
        isempty(handles.p452.Gr) || ...
        isempty(handles.p452.press) || ...
        isempty(handles.p452.temp) || ...
        isempty(handles.p452.dct) || ...
        isempty(handles.p452.dcr))
    warndlg({'Not all the input parameters are defined.'},'Error','modal');
    alldefined=false;
    return
    
   
end


alldefined = true;
return



% --------------------------------------------------------------------
function ImportData_Callback(hObject, eventdata, handles)
% hObject    handle to ImportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
    {'*.mat', 'MAT-files (*.mat)';}, ...
    'Pick a file');
handles.p452.filename=filename;
handles.p452.pathname=pathname;

if (filename==0)
    return
end

dummy = load([pathname '/' filename])
handles.p452 = dummy.out;
handles.p452

% once data is reloaded, populate the fields

if (isempty(handles.p452.dtot))
    set(handles.radiobutton12,'Value',1);
    set(handles.radiobutton2,'Value',0);
    set(handles.LoadProfile,'Enable','on');
    set(handles.dtot,'String','');
    set(handles.dtot,'Enable','off');
else
    set(handles.radiobutton12,'Value',0);
    set(handles.radiobutton2,'Value',1);
    set(handles.LoadProfile,'Enable','off');
    set(handles.dtot,'String',num2str(handles.p452.dtot));
    set(handles.dtot,'Enable','on');
end

set(handles.ChoosePolarization, 'Value', handles.p452.polarization+1);

set(handles.f, 'String', num2str(handles.p452.f));
set(handles.p, 'String', num2str(handles.p452.p));
set(handles.phit_e, 'String', num2str(handles.p452.phit_e));
set(handles.phit_n, 'String', num2str(handles.p452.phit_n));
set(handles.phir_e, 'String', num2str(handles.p452.phir_e));
set(handles.phir_n, 'String', num2str(handles.p452.phir_n));
set(handles.htg, 'String', num2str(handles.p452.htg));
set(handles.hrg, 'String', num2str(handles.p452.hrg));
set(handles.Gt, 'String', num2str(handles.p452.Gt));
set(handles.Gr, 'String', num2str(handles.p452.Gr));
set(handles.press, 'String', num2str(handles.p452.press));
set(handles.temp, 'String', num2str(handles.p452.temp));


set(handles.dct, 'String', num2str(handles.p452.dct));
set(handles.dcr, 'String', num2str(handles.p452.dcr));

set(handles.basicTL, 'String', num2str(handles.p452.basicTL));

set(handles.tableLoss, 'Data', handles.p452.tableLoss);
set(handles.profileParameters, 'Data', handles.p452.profileParameters);

RemoveAxes(handles.axes1);
ax = handles.axes1;

axis(ax);
cla(ax);
xlabel(ax,'');
ylabel(ax,'');
legend(ax,'hide');
title(ax,'');
set(ax,'Visible','off');
set(handles.plotResults,'Value',1);


guidata(hObject, handles);

% --------------------------------------------------------------------
function ExportData_Callback(hObject, eventdata, handles)
% hObject    handle to ExportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[filename, pathname] = uiputfile('*.txt',...
%                       'Pick an output file');

if (handles.p452.ParameterChange)
    uiwait(warndlg({'The results are not up-to-date.', 'Please re-run the simulations.'},'Warning', 'modal'));
end

out = handles.p452;
if (get(handles.radiobutton12,'Value') == 0)
    out.filename=[];
    out.pathname=[];
end


[filename, pathname] = uiputfile('*.mat',...
    'Pick an output file');
%handles.p452.PM.Model;
if filename~= 0
    save([pathname '/' filename], 'out');
end




function plotSemaphores(hObject, eventdata, handles)

ax = handles.axes1;
cla(ax,'reset');
hold(ax, 'off');
zoom(ax,'reset');
xlabel('');
ylabel('');
title('');
legend(ax,'hide')
set(ax,'Visible','on')
RemoveAxes(handles.axes1);


if isempty(handles.p452.filename)
    warndlg({'Path profile not loaded correctly.'},'Error','modal');
    return
end

if isempty(handles.p452.path.d) || isempty(handles.p452.path.h)
    warndlg({'Path profile not loaded correctly.'},'Error','modal');
    return
end


if(handles.p452.ParameterChange)
    %warndlg({'Input parameters have changed. The results are not up-to-date.'
    %         'Plese re-run the simulations.'});
    qstring = {'Input parameters have changed. The results are not up-to-date.'
        'Plese re-run the simulations.'};
    choice = questdlg(qstring,'Re-run the simulations',...
        'OK','OK');
    
end


face_alpha = 0.7;
xx = handles.p452.path.d;
yy = handles.p452.path.h;
zz = handles.p452.path.g;

axes(ax);

kk = find(handles.p452.path.zone == 1);
xx1 = xx(kk);
yy1 = yy(kk);
zz1 = zz(kk);


kk = find(handles.p452.path.zone == 2);
xx2 = xx(kk);
yy2 = yy(kk);
zz2 = zz(kk);

kk = find(handles.p452.path.zone == 3);
xx3 = xx(kk);
yy3 = yy(kk);
zz3 = zz(kk);

h1=plot(ax,xx, yy);
set(h1,'Color', 'k','LineWidth',2) % , 'Marker', markers{kk},'MarkerFaceColor', colors{kk})

xlabel(ax,'Distance (km)');
ylabel(ax,'Height (m)')
grid(ax, 'on');
hold(ax, 'on');
set(ax, 'XLim', [xx(1) xx(end)]);

bits = (yy == zz);
df = diff(bits);
k1 = find(df == -1);
if(~isempty(k1))
    for idx = 1:length(k1)
        p = k1(idx);
        xx = insert(xx, p+1, xx(p));
        zz = insert(zz, p+1, zz(p+1));
    end
end

k2 = find(df == 1);

if(~isempty(k2))
    for idx = 1:length(k2)
        p = k2(idx);
        xx = insert(xx, p+1, xx(p+1));
        zz = insert(zz, p+2, yy(p));
    end
end

h2 = plot(ax,xx,zz);
legend(ax,'Terrain profile', 'Clutter profile')
hold(ax, 'off');
guidata(hObject, handles);


% warning off
% pgon = polyshape([xx, xx(end:-1:1)], [yy, zz(end:-1:1)], 'Simplify', true);
% warning on
% 
% h3 = plot(ax,pgon);

% h1=plot(ax,xx1, yy1, 'LineWidth', 1);
% set(h1,'Color', 'k','LineWidth',2) % , 'Marker', markers{kk},'MarkerFaceColor', colors{kk})
% 
% 
% h2=plot(ax,xx2, yy2, 'LineWidth', 1);
% set(h2,'Color', 'b','LineWidth',2) % , 'Marker', markers{kk},'MarkerFaceColor', colors{kk})
% hold(ax, 'on');
% 
% h3=plot(ax,xx3, yy3, 'LineWidth', 1);
% set(h2,'Color', 'g','LineWidth',2) % , 'Marker', markers{kk},'MarkerFaceColor', colors{kk})
% hold(ax, 'on');




function out = readinputfield(hObject, varargin)
% function that reads the text fields user entered and returns back the
% values. The user can choose to enter an array instead of a single value.
% The values in array are separated by spaces.
% 07MAY15   Ivica Stevanovic (OFCOM)

if nargin > 3    warning(strcat('readinputfield: Too many input arguments; The function requires at most 3',...
        'input arguments. Additional values ignored. Input values may be wrongly assigned.'));
end

if nargin < 1
    error('readinputfield: function requires at least 1 input parameter.');
end

minV = -inf;
maxV = +inf;

if nargin >=2
    minV=varargin{1};
    if nargin >=3
        maxV=varargin{2};
    end
end

readLine = get(hObject, 'String');

% remove any trailing white spaces
readLine = regexprep(readLine,' +$', '');

% split the string into individual values separated by whitespaces
dummy=regexp(readLine,' +','split');


n = length(dummy);
out = [];

for ii = 1:n
    outii = str2double(dummy(ii));
    if (isnan(outii))
        warndlg({'Only numeric values allowed.'},'Error','modal');
        set(hObject,'Foregroundcolor',[1 0 0]);
        out = [];
        break
    elseif (outii < minV)
        warndlg({['The argument must not be smaller than ' num2str(minV)]},'Error','modal');
        set(hObject,'Foregroundcolor',[1 0 0]);
        out = [];
        break
    elseif (outii > maxV)
        warndlg({['The argument must not be larger than ' num2str(maxV)]},'Error','modal');
        set(hObject,'Foregroundcolor',[1 0 0]);
        out = [];
        break
    else
        set(hObject,'Foregroundcolor',[0 0 0]);
        out(ii) = outii;
    end
    if length(out)>1
        set(hObject,'Backgroundcolor',[0.678 0.922 1.0]);
    else
        set(hObject,'Backgroundcolor',[1.0 1.0 1.0]);
    end
end
return


% --------------------------------------------------------------------
function ClearAll_Callback(hObject, eventdata, handles)
% hObject    handle to ClearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.radiobutton12,'Value',1);
set(handles.radiobutton2,'Value',0);
set(handles.LoadProfile,'Enable','on');
set(handles.dtot,'Enable','on');

set(handles.f, 'String', '');
set(handles.p, 'String', '');
set(handles.htg, 'String', '');
set(handles.hrg, 'String', '');
set(handles.Gt, 'String', '');
set(handles.Gr, 'String', '');
set(handles.phit_e, 'String', '');
set(handles.phir_e, 'String', '');
set(handles.phit_n, 'String', '');
set(handles.phir_n, 'String', '');
set(handles.press, 'String', '');
set(handles.temp, 'String', '');
set(handles.ChoosePolarization, 'Value', 1);
set(handles.dct,'String','500');
set(handles.dcr,'String','500');

set(handles.basicTL, 'String', '');

handles.p452 = [];
handles.p452.path.d = [];
handles.p452.path.h = [];
handles.p452.path.g = [];
handles.p452.path.r = [];
handles.p452.path.zone = [];

handles.p452.filename={};
handles.p452.pathname={};

handles.p452.dtot = [];
handles.p452.f = [];
handles.p452.p = [];
handles.p452.phit_e = [];
handles.p452.phit_n = [];
handles.p452.phir_e = [];
handles.p452.phir_n = [];
% handles.p452.ksi_t = [];
handles.p452.htg = [];
handles.p452.Gt = [];
% 
% handles.p452.phi_r = [];
% handles.p452.ksi_r = [];
handles.p452.hrg = [];
handles.p452.Gr = [];

handles.p452.DN = [];
handles.p452.N0 = [];
handles.p452.press = [];
handles.p452.temp = [];

handles.p452.dct = 500;
handles.p452.dcr = 500;


handles.p452.titleFontSize = 9;
handles.p452.ParameterChange = false;

d = cell(18,2);
d{1,1} = 'Profile';
d{1+1,1} = 'ae';
d{1+2,1} = 'd';
d{1+3,1} = 'hts';
d{1+4,1} = 'hrs';
d{1+5,1} = 'theta_t';
d{1+6,1} = 'theta_r';
d{1+7,1} = 'theta';
d{1+8,1} = 'hst';
d{1+9,1} = 'hsr';
d{1+10,1} = 'hm';
d{1+11,1} = 'hte';
d{1+12,1} = 'hre';
d{1+13,1} = 'hstd';
d{1+14,1} = 'hsrd';
d{1+15,1} = 'dlt';
d{1+16,1} = 'dlr';
d{1+17,1} = 'path type';
d{1+18,1} = 'dtm';
d{1+19,1} = 'dlm';
d{1+20,1} = 'beta0';
d{1+21,1} = 'w';

set(handles.profileParameters,'Data',d);

d1{1,1} = 'Lbfsg';
d1{2,1} = 'Lb0p';
d1{3,1} = 'Lb0b';
d1{4,1} = 'Lbulla';
d1{5,1} = 'Lbulls';
d1{6,1} = 'Ldsph';
d1{7,1} = 'Ld';
d1{8,1} = 'Lbs';
d1{9,1} = 'Lba';



set(handles.tableLoss,'Data',d1);

set(handles.axes1,'Visible','off')
set(handles.radiobutton12,'Value',1);
set(handles.radiobutton2,'Value',0);
set(handles.dtot,'Enable','off');
set(handles.LoadProfile,'Enable','on');

%%

RemoveAxes(handles.axes1);
ax = handles.axes1;

axis(ax);
cla(ax);
xlabel(ax,'');
ylabel(ax,'');
legend(ax,'hide');
title(ax,'');
set(ax,'Visible','off');
set(handles.plotResults,'Value',1);

guidata(hObject, handles);


% --- Executes on button press in LoadProfile.
function LoadProfile_Callback(hObject, eventdata, handles)
% hObject    handle to LoadProfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile( ...
    { ...
    '*.dat;*.csv;*.txt', 'Data files (*.dat,*.csv,*.txt)'; ...
       '*.*',  'All Files (*.*)'}, ...
    'Pick a file');

if (filename==0)
    
    handles.p452.path.d = [];
    handles.p452.path.h = [];
    handles.p452.path.r = [];
    handles.p452.path.g = [];
    handles.p452.path.zone = [];
    
    handles.p452.filename=[];
    handles.p452.pathname=[];
    % Update handles structure
    set(handles.LoadProfile,'String','Load');
    guidata(hObject, handles);
    
    return
    
end

handles.p452.filename=filename;

handles.p452.pathname=pathname;


try

    a = load([pathname filename]);
    handles.p452.path.d = a(:, 1);
    handles.p452.path.h = a(:, 2);
    handles.p452.path.r = a(:, 3);
    handles.p452.path.g = a(:,2) + a(:,3);
    [m,n]= size(a);
    if n == 4
        handles.p452.path.zone  = a(:, 3);
    else
        handles.p452.path.zone = ones(m,1)*2;
    end
    plotSemaphores(hObject, eventdata, handles)
    
catch
    
    try
        %disp('trying with strings')
        fid = fopen([pathname filename]);
        kk = 0;
        while(1)
           
            readLine = fgetl(fid);
            if (readLine==-1)
                break
            end

            if contains(readLine, 'Ground') % skip headers
                continue;
            end

            % check if it is comma separated or tab separated file
            if contains(readLine, ',')

                dummy = strsplit(readLine,',');
            else
                dummy = strsplit(readLine);
            end
            
            kk = kk + 1;
            d(kk) = str2double(dummy{1});
            h(kk) = str2double(dummy{2});
            r(kk) = str2double(dummy{3});
            zone(kk) = str2double(dummy{5});
            
        end
        fclose(fid);
        handles.p452.path.d = d;
        handles.p452.path.h = h;
        handles.p452.path.r = r;
        handles.p452.path.g = h + r;
        handles.p452.path.zone = zone;
        plotSemaphores(hObject, eventdata, handles)
        guidata(hObject, handles);
    catch
        
        warndlg({'File does not exist or its format is wrong.'},'Error','modal');
        handles.p452.path  = [];
        guidata(hObject, handles);
        
    end
    
    
end


handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);



function Gr_Callback(hObject, eventdata, handles)
% hObject    handle to Gr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Gr as text
%        str2double(get(hObject,'String')) returns contents of Gr as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Rx antenna gain must be a numeric value.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
    % elseif (in <=0)
    %     warndlg({'Tx antenna value must be a positive number.'},'Error','modal');
    %     set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.Gr = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Gr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function hrg_Callback(hObject, eventdata, handles)
% hObject    handle to hrg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hrg as text
%        str2double(get(hObject,'String')) returns contents of hrg as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Rx antenna height value must be a non-negative number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in <0)
    warndlg({'Rx antenna value must be a non-negative number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.hrg = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function hrg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hrg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Gt_Callback(hObject, eventdata, handles)
% hObject    handle to Gt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Gt as text
%        str2double(get(hObject,'String')) returns contents of Gt as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Tx antenna gain must be a number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
    % elseif (in <=0)
    %     warndlg({'Tx antenna value must be a positive number.'},'Error','modal');
    %     set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.Gt = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Gt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TxClutterCategory.
function TxClutterCategory_Callback(hObject, eventdata, handles)
% hObject    handle to TxClutterCategory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TxClutterCategory contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TxClutterCategory

contents=cellstr(get(hObject,'String'));
userChoiceInt = get(hObject,'Value');
userChoice=contents{userChoiceInt};

handles.p452.ParameterChange = true;
handles.p452.TxClutterCategory = userChoiceInt;
try
  
    
    if userChoiceInt == 2
        ha = 4; dk = 0.1;
    elseif userChoiceInt == 3
        ha = 5; dk = 0.07;
    elseif userChoiceInt == 4
        ha = 15; dk = 0.05;
    elseif userChoiceInt == 5
        ha = 20; dk = 0.05;
    elseif userChoiceInt == 6
        ha = 20; dk = 0.03;
    elseif userChoiceInt == 7
        ha = 9; dk = 0.025;
    elseif userChoiceInt == 8
        ha = 12; dk = 0.02;
    elseif userChoiceInt == 9
        ha = 20; dk = 0.02;
    elseif userChoiceInt == 10
        ha = 25; dk = 0.02;
    elseif userChoiceInt == 11
        ha = 35; dk = 0.02;
    elseif userChoiceInt == 12
        ha = 20; dk = 0.05;
    else
        ha = [];
        dk = [];
    end
    
    handles.p452.ha_t = ha;
    handles.p452.dk_t = dk;
    guidata(hObject, handles);
catch
    warning('Dataset menu corrupted.')
end


% --- Executes during object creation, after setting all properties.
function TxClutterCategory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TxClutterCategory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in RxClutterCategory.
function RxClutterCategory_Callback(hObject, eventdata, handles)
% hObject    handle to RxClutterCategory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RxClutterCategory contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RxClutterCategory
contents=cellstr(get(hObject,'String'));
userChoiceInt = get(hObject,'Value');
userChoice=contents{userChoiceInt};

handles.p452.ParameterChange = true;
handles.p452.RxClutterCategory = userChoiceInt;
try
    
    
    if userChoiceInt == 2
        ha = 4; dk = 0.1;
    elseif userChoiceInt == 3
        ha = 5; dk = 0.07;
    elseif userChoiceInt == 4
        ha = 15; dk = 0.05;
    elseif userChoiceInt == 5
        ha = 20; dk = 0.05;
    elseif userChoiceInt == 6
        ha = 20; dk = 0.03;
    elseif userChoiceInt == 7
        ha = 9; dk = 0.025;
    elseif userChoiceInt == 8
        ha = 12; dk = 0.02;
    elseif userChoiceInt == 9
        ha = 20; dk = 0.02;
    elseif userChoiceInt == 10
        ha = 25; dk = 0.02;
    elseif userChoiceInt == 11
        ha = 35; dk = 0.02;
    elseif userChoiceInt == 12
        ha = 20; dk = 0.05;
    else
        ha = [];
        dk = [];
    end
    
    handles.p452.ha_r = ha;
    handles.p452.dk_r = dk;
    guidata(hObject, handles);
catch
    warning('Dataset menu corrupted.')
end

% --- Executes during object creation, after setting all properties.
function RxClutterCategory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RxClutterCategory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DN_Callback(hObject, eventdata, handles)
% hObject    handle to DN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DN as text
%        str2double(get(hObject,'String')) returns contents of DN as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'DN must be a positive number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in <=0)
    warndlg({'DN must be a positive number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.DN = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function DN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function N0_Callback(hObject, eventdata, handles)
% hObject    handle to N0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of N0 as text
%        str2double(get(hObject,'String')) returns contents of N0 as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'N0 must be a positive number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in <=0)
    warndlg({'N0 must be a positive number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.N0 = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function N0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to N0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function press_Callback(hObject, eventdata, handles)
% hObject    handle to press (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of press as text
%        str2double(get(hObject,'String')) returns contents of press as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Pressure must be a non-negative number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in <0)
    warndlg({'Pressure must be a non-negative number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.press = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function press_CreateFcn(hObject, eventdata, handles)
% hObject    handle to press (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function temp_Callback(hObject, eventdata, handles)
% hObject    handle to temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of temp as text
%        str2double(get(hObject,'String')) returns contents of temp as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Temperature must be a numerical value.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
    % elseif (in <=0)
    %     warndlg({'DN must be a positive number.'},'Error','modal');
    %     set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.temp = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function temp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dct_Callback(hObject, eventdata, handles)
% hObject    handle to dct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dct as text
%        str2double(get(hObject,'String')) returns contents of dct as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Distance must be a non-negative number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in <0)
    warndlg({'Distance must be a non-negative number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.dct = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function dct_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dcr_Callback(hObject, eventdata, handles)
% hObject    handle to dcr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dcr as text
%        str2double(get(hObject,'String')) returns contents of dcr as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Distance must be a non-negative number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in <0)
    warndlg({'Distance must be a non-negative number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.dcr = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function dcr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dcr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
if (get(hObject,'Value'))
    set(handles.radiobutton12,'Value',0);
    set(handles.dtot,'Enable','on');
    set(handles.LoadProfile,'Enable','off');
    handles.p452.path.d=[];
    handles.p452.path.h=[];
    handles.p452.path.zone=[];
    handles.p452.filename={};
else
    set(handles.radiobutton12,'Value',1);
    set(handles.dtot,'ForegroundColor',[0 0 0]);
    set(handles.dtot,'Enable','off');
    set(handles.LoadProfile,'Enable','on');
    handles.p452.dtot = [];
    set(handles.dtot,'String','');
    
end
handles.p452.ParameterChange = true;
guidata(hObject, handles);



function dtot_Callback(hObject, eventdata, handles)
% hObject    handle to dtot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dtot as text
%        str2double(get(hObject,'String')) returns contents of dtot as a double

in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Distance must be a positive number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in <=0)
    warndlg({'Distance must be a positive number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.dtot = in;
% rule of thumb: 10 points per decade
N = floor(10*log10(handles.p452.dtot));
if N < 100
    N = 100;
end
handles.p452.path.d = linspace(0,in,N).';
handles.p452.path.h = zeros(N,1);
handles.p452.path.r = zeros(N,1);
handles.p452.path.g = zeros(N,1);
handles.p452.path.zone = 2*ones(N,1);

handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function dtot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dtot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (get(hObject,'Value'))
    
    set(handles.radiobutton2,'Value',0);
    set(handles.dtot,'Enable','off');
    set(handles.dtot,'String', '');
    set(handles.LoadProfile,'Enable','on');
    handles.p452.dtot = [];
else
    set(handles.radiobutton2,'Value',1);
    set(handles.dtot,'ForegroundColor',[0 0 0]);
    set(handles.dtot,'Enable','on');
    set(handles.LoadProfile,'Enable','off');
    handles.p452.path.d = [];
    handles.p452.path.h = [];
    handles.p452.path.r = [];
    handles.p452.path.g = [];
    handles.p452.path.zone = [];
    handles.p452.filename = {};
end
handles.p452.ParameterChange = true;
guidata(hObject, handles);


function basicTL_Callback(hObject, eventdata, handles)
% hObject    handle to basicTL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of basicTL as text
%        str2double(get(hObject,'String')) returns contents of basicTL as a double


% --- Executes during object creation, after setting all properties.
function basicTL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to basicTL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------


% --------------------------------------------------------------------
function WorstMonthDN_Callback(hObject, eventdata, handles)
% hObject    handle to WorstMonthDN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
C = imread('./private/Fig12.png');
h = figure;
set(h, 'Name', 'Maximum monthly values of DN')
image(C);
axis off

% --------------------------------------------------------------------
function SurfaceRefractivityN0_Callback(hObject, eventdata, handles)
% hObject    handle to SurfaceRefractivityN0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

C = imread('./private/Fig13.png');
h = figure;
set(h, 'Name', 'Sea-level surface refractivity N0')
image(C);
axis off

% --------------------------------------------------------------------
function AnnualDN_Callback(hObject, eventdata, handles)
% hObject    handle to AnnualDN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

C = imread('./private/Fig11.png');
h = figure;
set(h, 'Name', 'Average annual values of DN')
image(C);
axis off


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msg =  {'- This program computes the basic transmission loss according to'; ...
        '  ITU-R P.452-18.'; ' ';...
'- The main implementation of the recommendation is MATLAB function'; ...
'  tl_p452.m placed in this folder that can be used independently'; ...
'  of this Graphical User Interface but needs the functions '; ...
'  defined in the folder ./private.'; ' ';...
'- Hydrometeor-scatter prediction is not implemented in this version.'; ' ';...
'- Test functions to verify/validate the current implementation are placed'; ...
'  in ./private folder.'; ' '; ...
'- v3.15.11.23,  Ivica Stevanovic, OFCOM (CH)';};
h = msgbox(msg,'About');


% --------------------------------------------------------------------
function ValidationTest_Callback(hObject, eventdata, handles)
% hObject    handle to ValidationTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% s = pwd;
% if ~exist('test_deltaBullington.m','file')
%     addpath([s '/test/'])
% end
success = 0;
fail = 0;
[s,f] = test_deltaBullington();
success = s;
fail = f;
%
% [s,f] = test_path_1();
% success = success + s;
% fail = fail + f;
% %
% [s,f] = test_path_2();
% success = success + s;
% fail = fail + f;
% %
% [s,f] = test_ClutterLoss();
% success = success + s;
% fail = fail + f;

%%
msg = {sprintf('*** %d (out of %d) test(s) succeeded.', success, success+fail); ...
        sprintf('***               %d test(s) failed.', fail)};

h = msgbox(msg,'Validation Test');
return


% --- Executes on mouse press over axes background.

function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles
if strcmp( get(handles.figure1,'selectionType') , 'normal')
disp('Left Click')
end
if strcmp( get(handles.figure1,'selectionType') , 'open')
disp('Left Double Click')
end

function RemoveAxes(ax)

try
    cla(ax);
    xlabel(ax,'');
    ylabel(ax,'');
    title(ax,'');
    legend(ax,'hide');
    set(ax,'Visible','off');
    
catch
    fprintf(1,'Problem removing axes from GUI.\n');
end

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function RadioMaps_Callback(hObject, eventdata, handles)
% hObject    handle to RadioMaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text96_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text96 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function phit_e_Callback(hObject, eventdata, handles)
% hObject    handle to phit_e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phit_e as text
%        str2double(get(hObject,'String')) returns contents of phit_e as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Tx longitude value must be a number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in < -180 && in > 180)
    warndlg({'Tx longitude must be in the range [-180, 180].'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.phit_e = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function phit_e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phit_e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phit_n_Callback(hObject, eventdata, handles)
% hObject    handle to phit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phit_n as text
%        str2double(get(hObject,'String')) returns contents of phit_n as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Tx latitude value must be a number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in <= -90 && in >= 90)
    warndlg({'Tx latitude must be in the range (-90, 90).'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.phit_n = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function phit_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phir_n_Callback(hObject, eventdata, handles)
% hObject    handle to phir_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phir_n as text
%        str2double(get(hObject,'String')) returns contents of phir_n as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Rx latitude value must be a number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in <= -90 && in >= 90)
    warndlg({'Rx latitude must be in the range (-90, 90).'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.phir_n = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function phir_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phir_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function phir_e_Callback(hObject, eventdata, handles)
% hObject    handle to phir_e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of phir_e as text
%        str2double(get(hObject,'String')) returns contents of phir_e as a double
in = str2double(get(hObject, 'String'));
if (isnan(in))
    warndlg({'Rx longitude value must be a number.'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
elseif (in < -180 && in > 180)
    warndlg({'Rx longitude must be in the range [-180, 180].'},'Error','modal');
    set(hObject,'Foregroundcolor',[1 0 0]);
else
    set(hObject,'Foregroundcolor',[0 0 0]);
end
handles.p452.phir_e = in;
handles.p452.ParameterChange = true;
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function phir_e_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phir_e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
