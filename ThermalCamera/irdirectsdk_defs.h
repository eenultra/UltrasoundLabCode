#ifndef __IRDIRECTSDK_DEFS__
#define __IRDIRECTSDK_DEFS__

#if _WIN32 && !IRDIRECTSDK_STATIC
#define __CALLCONV __cdecl
#ifdef IRDIRECTSDK_EXPORTS
#define __IRDIRECTSDK_API__ __declspec(dllexport)
#else
#define __IRDIRECTSDK_API__ __declspec(dllimport)
#endif
#else
#define __IRDIRECTSDK_API__
#define __CALLCONV
#endif

#ifndef OPTRISVID
#define OPTRISVID 0x0403
#endif

#ifndef OPTRISPID
#define OPTRISPID 0xDE37
#endif

#endif
