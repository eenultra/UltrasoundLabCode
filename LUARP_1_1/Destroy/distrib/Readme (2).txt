Add Splash Folder into folder where compiled matlab is located.

Edit "Launch Program.bat" to launch the compiled matlab executable file.

Add the following code to the beginning of the matlab GUI "..._OpeningFcn(hObject, eventdata, handles, varargin)" function and enjoy.




% If there is a splash screen for deployed version, kill it since this code
% is now running and is MCR is no longer loading.
if isdeployed
    nameOfExe='mshta.exe';
    dosCmd = ['taskkill /f /im "' nameOfExe '"'];
    display('Close splashscreen (mshta.exe)')
    dos(dosCmd);
end