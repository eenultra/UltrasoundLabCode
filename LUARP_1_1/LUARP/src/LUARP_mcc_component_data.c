/*
 * MATLAB Compiler: 4.9 (R2008b)
 * Date: Thu Aug 23 13:06:20 2012
 * Arguments: "-B" "macro_default" "-o" "LUARP" "-W" "WinMain:LUARP" "-d"
 * "U:\PhD\Pete\My UARP\LUARP_1_1\LUARP\src" "-T" "link:exe" "-v"
 * "U:\PhD\Pete\My UARP\LUARP_1_1\LUARP_GUI.m" 
 */

#include "mclmcrrt.h"

#ifdef __cplusplus
extern "C" {
#endif
const unsigned char __MCC_LUARP_session_key[] = {
    '5', 'F', '2', 'F', 'B', '9', '2', '2', 'F', '1', '6', '9', 'C', '3', 'D',
    'D', 'D', '0', 'C', '2', '9', 'F', 'A', '3', 'C', '1', '2', '0', '2', 'D',
    'C', 'F', '7', '8', 'A', 'A', '2', '8', '8', 'B', '4', '4', 'E', '4', 'A',
    '1', 'E', '4', '8', '4', 'C', '8', '9', 'E', '5', 'F', '2', '8', '0', 'F',
    'B', '7', '7', '1', 'E', '3', '1', 'F', '0', 'C', '7', 'B', 'D', 'B', 'C',
    'D', '8', 'E', '4', 'D', '0', '8', '8', 'B', '1', 'B', 'D', '5', 'E', 'C',
    '5', '6', 'E', 'C', 'E', '6', '3', 'A', '9', '7', 'B', '0', '3', 'C', '3',
    '1', 'C', '0', '0', '2', 'A', '5', 'F', '6', 'F', '8', '8', '2', '3', '2',
    '8', '3', '8', 'D', '4', '7', '5', '2', 'F', 'A', '5', '0', '7', '9', '9',
    'D', 'A', 'E', 'E', '2', 'F', '0', '2', '2', '7', '6', '5', 'D', 'D', 'F',
    '6', 'C', 'B', 'F', 'D', '4', '4', '9', '8', '9', '5', '8', '3', '7', '6',
    '0', '9', 'A', 'C', '7', '9', 'C', '0', 'B', 'B', '1', '6', 'E', 'C', '6',
    'A', '7', '7', '7', '0', '2', 'F', 'D', '3', '9', 'A', '5', '9', 'F', 'B',
    '8', 'F', 'F', '5', '9', 'C', '7', '2', '3', '1', '2', '1', '1', 'A', '2',
    '0', '3', '4', 'C', '3', '7', 'E', 'E', '4', 'B', '8', '4', '5', '0', '0',
    '1', '0', '2', '6', 'B', '3', '2', '6', '9', '5', '1', 'B', '1', '7', '9',
    '8', '2', '8', '4', 'C', '4', 'E', '4', '1', '9', '9', 'F', 'E', 'B', 'D',
    'E', '\0'};

const unsigned char __MCC_LUARP_public_key[] = {
    '3', '0', '8', '1', '9', 'D', '3', '0', '0', 'D', '0', '6', '0', '9', '2',
    'A', '8', '6', '4', '8', '8', '6', 'F', '7', '0', 'D', '0', '1', '0', '1',
    '0', '1', '0', '5', '0', '0', '0', '3', '8', '1', '8', 'B', '0', '0', '3',
    '0', '8', '1', '8', '7', '0', '2', '8', '1', '8', '1', '0', '0', 'C', '4',
    '9', 'C', 'A', 'C', '3', '4', 'E', 'D', '1', '3', 'A', '5', '2', '0', '6',
    '5', '8', 'F', '6', 'F', '8', 'E', '0', '1', '3', '8', 'C', '4', '3', '1',
    '5', 'B', '4', '3', '1', '5', '2', '7', '7', 'E', 'D', '3', 'F', '7', 'D',
    'A', 'E', '5', '3', '0', '9', '9', 'D', 'B', '0', '8', 'E', 'E', '5', '8',
    '9', 'F', '8', '0', '4', 'D', '4', 'B', '9', '8', '1', '3', '2', '6', 'A',
    '5', '2', 'C', 'C', 'E', '4', '3', '8', '2', 'E', '9', 'F', '2', 'B', '4',
    'D', '0', '8', '5', 'E', 'B', '9', '5', '0', 'C', '7', 'A', 'B', '1', '2',
    'E', 'D', 'E', '2', 'D', '4', '1', '2', '9', '7', '8', '2', '0', 'E', '6',
    '3', '7', '7', 'A', '5', 'F', 'E', 'B', '5', '6', '8', '9', 'D', '4', 'E',
    '6', '0', '3', '2', 'F', '6', '0', 'C', '4', '3', '0', '7', '4', 'A', '0',
    '4', 'C', '2', '6', 'A', 'B', '7', '2', 'F', '5', '4', 'B', '5', '1', 'B',
    'B', '4', '6', '0', '5', '7', '8', '7', '8', '5', 'B', '1', '9', '9', '0',
    '1', '4', '3', '1', '4', 'A', '6', '5', 'F', '0', '9', '0', 'B', '6', '1',
    'F', 'C', '2', '0', '1', '6', '9', '4', '5', '3', 'B', '5', '8', 'F', 'C',
    '8', 'B', 'A', '4', '3', 'E', '6', '7', '7', '6', 'E', 'B', '7', 'E', 'C',
    'D', '3', '1', '7', '8', 'B', '5', '6', 'A', 'B', '0', 'F', 'A', '0', '6',
    'D', 'D', '6', '4', '9', '6', '7', 'C', 'B', '1', '4', '9', 'E', '5', '0',
    '2', '0', '1', '1', '1', '\0'};

static const char * MCC_LUARP_matlabpath_data[] = 
  { "LUARP/", "$TOOLBOXDEPLOYDIR/", "$TOOLBOXMATLABDIR/general/",
    "$TOOLBOXMATLABDIR/ops/", "$TOOLBOXMATLABDIR/lang/",
    "$TOOLBOXMATLABDIR/elmat/", "$TOOLBOXMATLABDIR/randfun/",
    "$TOOLBOXMATLABDIR/elfun/", "$TOOLBOXMATLABDIR/specfun/",
    "$TOOLBOXMATLABDIR/matfun/", "$TOOLBOXMATLABDIR/datafun/",
    "$TOOLBOXMATLABDIR/polyfun/", "$TOOLBOXMATLABDIR/funfun/",
    "$TOOLBOXMATLABDIR/sparfun/", "$TOOLBOXMATLABDIR/scribe/",
    "$TOOLBOXMATLABDIR/graph2d/", "$TOOLBOXMATLABDIR/graph3d/",
    "$TOOLBOXMATLABDIR/specgraph/", "$TOOLBOXMATLABDIR/graphics/",
    "$TOOLBOXMATLABDIR/uitools/", "$TOOLBOXMATLABDIR/strfun/",
    "$TOOLBOXMATLABDIR/imagesci/", "$TOOLBOXMATLABDIR/iofun/",
    "$TOOLBOXMATLABDIR/audiovideo/", "$TOOLBOXMATLABDIR/timefun/",
    "$TOOLBOXMATLABDIR/datatypes/", "$TOOLBOXMATLABDIR/verctrl/",
    "$TOOLBOXMATLABDIR/codetools/", "$TOOLBOXMATLABDIR/helptools/",
    "$TOOLBOXMATLABDIR/winfun/", "$TOOLBOXMATLABDIR/demos/",
    "$TOOLBOXMATLABDIR/timeseries/", "$TOOLBOXMATLABDIR/hds/",
    "$TOOLBOXMATLABDIR/guide/", "$TOOLBOXMATLABDIR/plottools/",
    "toolbox/local/", "toolbox/shared/controllib/",
    "toolbox/shared/dastudio/", "$TOOLBOXMATLABDIR/datamanager/",
    "toolbox/compiler/", "toolbox/control/control/",
    "toolbox/control/ctrlguis/", "toolbox/control/ctrlobsolete/",
    "toolbox/control/ctrlutil/", "toolbox/shared/slcontrollib/",
    "toolbox/ident/ident/", "toolbox/ident/nlident/",
    "toolbox/ident/idobsolete/", "toolbox/ident/idutils/",
    "toolbox/images/colorspaces/", "toolbox/images/images/",
    "toolbox/images/iptformats/", "toolbox/images/iptutils/",
    "toolbox/shared/imageslib/", "toolbox/shared/spcuilib/",
    "toolbox/signal/signal/", "toolbox/signal/sigtools/", "toolbox/stats/" };

static const char * MCC_LUARP_classpath_data[] = 
  { "java/jar/toolbox/control.jar", "java/jar/toolbox/images.jar" };

static const char * MCC_LUARP_libpath_data[] = 
  { "bin/win32/" };

static const char * MCC_LUARP_app_opts_data[] = 
  { "" };

static const char * MCC_LUARP_run_opts_data[] = 
  { "" };

static const char * MCC_LUARP_warning_state_data[] = 
  { "off:MATLAB:dispatcher:nameConflict" };


mclComponentData __MCC_LUARP_component_data = { 

  /* Public key data */
  __MCC_LUARP_public_key,

  /* Component name */
  "LUARP",

  /* Component Root */
  "",

  /* Application key data */
  __MCC_LUARP_session_key,

  /* Component's MATLAB Path */
  MCC_LUARP_matlabpath_data,

  /* Number of directories in the MATLAB Path */
  58,

  /* Component's Java class path */
  MCC_LUARP_classpath_data,
  /* Number of directories in the Java class path */
  2,

  /* Component's load library path (for extra shared libraries) */
  MCC_LUARP_libpath_data,
  /* Number of directories in the load library path */
  1,

  /* MCR instance-specific runtime options */
  MCC_LUARP_app_opts_data,
  /* Number of MCR instance-specific runtime options */
  0,

  /* MCR global runtime options */
  MCC_LUARP_run_opts_data,
  /* Number of MCR global runtime options */
  0,
  
  /* Component preferences directory */
  "LUARP_ECAD1318EE9F0F7DE7713EE8BA8EE482",

  /* MCR warning status data */
  MCC_LUARP_warning_state_data,
  /* Number of MCR warning status modifiers */
  1,

  /* Path to component - evaluated at runtime */
  NULL

};

#ifdef __cplusplus
}
#endif


