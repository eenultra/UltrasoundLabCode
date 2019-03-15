**********************************************************************

  MATLAB Interface for Optris PI-Series
	
  Version Information:  libirimager 2.1.0		
  Date:                 July 10th, 2017
  Documentation:        www.evocortex.com				
  Contact:              info@evocortex.com	
					
**********************************************************************

1) Dependencies:
  The library is built with toolset version v120 (Visual Studio 2013). 
  Get the Redistributable packages for 32-Bit-Systems from (*1) and 
  for 64-Bit-Systems from (*2).
  
2) Additional Software
  To use the library libirimager via MATLAB's loadlibrary() command a 
  compatible compiler must be available on the system. See (*3) for 
  detailed information.
  
  Successfully tested compilers are: 
    - MinGW 4.9
    - Microsoft Visual C++ 2013 Professional
    - Microsoft Windows SDK 7.1

**********************************************************************

*1) https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe

*2) https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe

*3) https://de.mathworks.com/support/compilers.html